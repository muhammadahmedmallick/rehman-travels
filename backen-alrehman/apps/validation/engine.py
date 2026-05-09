"""
Validation Engine
=================

Usage
-----
    from apps.validation.engine import ValidationEngine

    result = ValidationEngine.validate(
        schema_type='process_payment',
        fields={'name': 'Ali', 'amount': ''},
    )
    # result.valid        → False
    # result.errors       → {'amount': [{'code': 'FIELD_REQUIRED', 'message': 'amount is required.'}]}
    # result.to_response()→ dict ready for DRF Response

Extending
---------
To add a new rule type:
  1. Add it to models.RuleType choices.
  2. Add an `ErrorCode` constant to models.ErrorCode.
  3. Add a default message to models.DEFAULT_MESSAGES.
  4. Add a `_check_<rule_type>` static method here following the pattern below.
  5. Register it in `_RULE_HANDLERS` at the bottom of this file.

Everything else (DB lookup, message resolution, response shape) is automatic.
"""

import re
import logging
from dataclasses import dataclass, field
from decimal import Decimal, InvalidOperation
from typing import Any

from apps.validation.models import (
    DEFAULT_MESSAGES,
    ErrorCode,
    FieldRule,
    RuleType,
    ValidationSchema,
)

logger = logging.getLogger(__name__)


# ─── Result types ─────────────────────────────────────────────────────────────

@dataclass
class FieldError:
    code: str
    message: str

    def to_dict(self) -> dict:
        return {'code': self.code, 'message': self.message}


@dataclass
class ValidationResult:
    valid: bool
    schema_type: str
    errors: dict[str, list[FieldError]] = field(default_factory=dict)

    def to_response(self) -> dict:
        return {
            'valid': self.valid,
            'schema_type': self.schema_type,
            'errors': {
                field_name: [e.to_dict() for e in errs]
                for field_name, errs in self.errors.items()
            },
        }

    @classmethod
    def system_error(cls, schema_type: str, code: str, message: str) -> 'ValidationResult':
        """Return a result for system-level errors (bad payload, unknown schema)."""
        return cls(
            valid=False,
            schema_type=schema_type,
            errors={'__all__': [FieldError(code=code, message=message)]},
        )


# ─── Individual rule checkers ─────────────────────────────────────────────────
# Each checker receives (value, rule_value) and returns None on pass
# or an ErrorCode string on failure.

def _check_required(value: Any, rule_value: str) -> str | None:
    if value is None or str(value).strip() == '':
        return ErrorCode.FIELD_REQUIRED
    return None


def _check_min_length(value: Any, rule_value: str) -> str | None:
    try:
        limit = int(rule_value)
    except (ValueError, TypeError):
        return None  # misconfigured rule — skip silently
    if len(str(value)) < limit:
        return ErrorCode.MIN_LENGTH
    return None


def _check_max_length(value: Any, rule_value: str) -> str | None:
    try:
        limit = int(rule_value)
    except (ValueError, TypeError):
        return None
    if len(str(value)) > limit:
        return ErrorCode.MAX_LENGTH
    return None


def _check_regex(value: Any, rule_value: str) -> str | None:
    try:
        if not re.fullmatch(rule_value, str(value)):
            return ErrorCode.REGEX_MISMATCH
    except re.error:
        logger.error('ValidationEngine: invalid regex pattern: %s', rule_value)
    return None


def _check_email(value: Any, rule_value: str) -> str | None:
    pattern = r'^[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9.\-]+$'
    if not re.fullmatch(pattern, str(value).strip()):
        return ErrorCode.INVALID_EMAIL
    return None


def _check_phone(value: Any, rule_value: str) -> str | None:
    # Accepts international (+923001234567), local (03001234567),
    # and 11-digit local formats.
    pattern = r'^\+?[0-9]{7,15}$'
    cleaned = re.sub(r'[\s\-()]', '', str(value))
    if not re.fullmatch(pattern, cleaned):
        return ErrorCode.INVALID_PHONE
    return None


def _check_numeric(value: Any, rule_value: str) -> str | None:
    try:
        Decimal(str(value))
    except (InvalidOperation, ValueError, TypeError):
        return ErrorCode.NUMERIC_ONLY
    return None


def _check_min_value(value: Any, rule_value: str) -> str | None:
    try:
        if Decimal(str(value)) < Decimal(rule_value):
            return ErrorCode.MIN_VALUE
    except (InvalidOperation, ValueError, TypeError):
        return ErrorCode.NUMERIC_ONLY
    return None


def _check_max_value(value: Any, rule_value: str) -> str | None:
    try:
        if Decimal(str(value)) > Decimal(rule_value):
            return ErrorCode.MAX_VALUE
    except (InvalidOperation, ValueError, TypeError):
        return ErrorCode.NUMERIC_ONLY
    return None


def _check_in_choices(value: Any, rule_value: str) -> str | None:
    choices = [c.strip() for c in rule_value.split(',') if c.strip()]
    if str(value).strip() not in choices:
        return ErrorCode.INVALID_CHOICE
    return None


def _check_max_decimal(value: Any, rule_value: str) -> str | None:
    try:
        limit = int(rule_value)
        d = Decimal(str(value))
        # Count digits after decimal point
        sign, digits, exponent = d.as_tuple()
        decimal_places = max(0, -exponent)
        if decimal_places > limit:
            return ErrorCode.MAX_DECIMAL
    except (InvalidOperation, ValueError, TypeError):
        return ErrorCode.NUMERIC_ONLY
    return None


def _check_boolean(value: Any, rule_value: str) -> str | None:
    if isinstance(value, bool):
        return None
    if str(value).lower() in ('true', 'false', '1', '0', 'yes', 'no'):
        return None
    return ErrorCode.INVALID_BOOLEAN


# ─── Rule handler registry ────────────────────────────────────────────────────
# Maps RuleType → checker function.
# Add new checkers here when extending the engine.

_RULE_HANDLERS: dict[str, callable] = {
    RuleType.REQUIRED:    _check_required,
    RuleType.MIN_LENGTH:  _check_min_length,
    RuleType.MAX_LENGTH:  _check_max_length,
    RuleType.REGEX:       _check_regex,
    RuleType.EMAIL:       _check_email,
    RuleType.PHONE:       _check_phone,
    RuleType.NUMERIC:     _check_numeric,
    RuleType.MIN_VALUE:   _check_min_value,
    RuleType.MAX_VALUE:   _check_max_value,
    RuleType.IN_CHOICES:  _check_in_choices,
    RuleType.MAX_DECIMAL: _check_max_decimal,
    RuleType.BOOLEAN:     _check_boolean,
}


# ─── Engine ───────────────────────────────────────────────────────────────────

class ValidationEngine:
    """
    Stateless engine.  All public methods are class-level for easy import.
    """

    @classmethod
    def validate(cls, schema_type: str, fields: dict) -> ValidationResult:
        """
        Main entry point.

        Parameters
        ----------
        schema_type : str
            The `data.type` value sent by the client.
        fields : dict
            The `data.fields` dict sent by the client.

        Returns
        -------
        ValidationResult
        """
        # ── 1. Fetch schema ──────────────────────────────────────────────────
        try:
            schema = (
                ValidationSchema.objects
                .prefetch_related('rules')
                .get(schema_type=schema_type, is_active=True)
            )
        except ValidationSchema.DoesNotExist:
            logger.warning('ValidationEngine: unknown schema_type=%s', schema_type)
            return ValidationResult.system_error(
                schema_type,
                ErrorCode.SCHEMA_NOT_FOUND,
                f'No active validation schema found for type "{schema_type}".',
            )

        # ── 2. Gather active rules, ordered ──────────────────────────────────
        rules: list[FieldRule] = list(
            schema.rules.filter(is_active=True).order_by('field_name', 'order')
        )

        # ── 3. Run rules field by field ───────────────────────────────────────
        errors: dict[str, list[FieldError]] = {}

        for rule in rules:
            fname = rule.field_name
            value = fields.get(fname)  # None if field not submitted at all

            # Skip non-required rules when field is absent/empty
            # (REQUIRED itself must still run)
            if rule.rule_type != RuleType.REQUIRED:
                if value is None or str(value).strip() == '':
                    continue

            handler = _RULE_HANDLERS.get(rule.rule_type)
            if handler is None:
                logger.error(
                    'ValidationEngine: no handler for rule_type=%s (rule id=%s)',
                    rule.rule_type, rule.pk,
                )
                continue

            failed_code = handler(value, rule.rule_value)

            if failed_code:
                err = FieldError(
                    code=failed_code,
                    message=rule.resolve_message(fname, str(value) if value is not None else ''),
                )
                errors.setdefault(fname, []).append(err)

                # Honour fail_fast: stop checking further rules for this field
                if schema.fail_fast:
                    # To skip remaining rules for this field, we rely on the
                    # fact that rules are field-sorted; we track which fields
                    # already have a fail-fast error.
                    # (Simpler: collect all then filter — done below.)
                    pass

        if schema.fail_fast:
            # Keep only the first error per field
            errors = {f: [errs[0]] for f, errs in errors.items()}

        return ValidationResult(
            valid=len(errors) == 0,
            schema_type=schema_type,
            errors=errors,
        )

    @classmethod
    def get_schema_info(cls, schema_type: str) -> dict | None:
        """
        Returns metadata about a schema (fields + rules) for documentation
        or client-side pre-validation hints.
        """
        try:
            schema = (
                ValidationSchema.objects
                .prefetch_related('rules')
                .get(schema_type=schema_type, is_active=True)
            )
        except ValidationSchema.DoesNotExist:
            return None

        field_map: dict[str, list] = {}
        for rule in schema.rules.filter(is_active=True).order_by('field_name', 'order'):
            field_map.setdefault(rule.field_name, []).append({
                'rule_type':  rule.rule_type,
                'rule_value': rule.rule_value,
                'error_code': rule.error_code,
            })

        return {
            'schema_type': schema.schema_type,
            'description': schema.description,
            'fail_fast':   schema.fail_fast,
            'fields':      field_map,
        }
