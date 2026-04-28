"""
Validation engine models.

Two tables power the rule engine:

  ValidationSchema   — one row per "type" (e.g. "process_payment")
  FieldRule          — one row per rule applied to one field in a schema

Design goals
------------
* Rules are stored in the DB → schemas can be added / edited without deploys.
* Each rule carries its own error_code + error_message so messages are
  fully customisable per schema / field / rule, not hard-coded in code.
* Placeholder support in messages: {field}, {value}, {limit}.
* Easy to extend: add new rule_type choices without touching existing rows.
"""

from django.db import models


# ─── Rule type catalogue ────────────────────────────────────────────────────
class RuleType(models.TextChoices):
    REQUIRED       = 'required',       'Required'
    MIN_LENGTH     = 'min_length',     'Minimum Length'
    MAX_LENGTH     = 'max_length',     'Maximum Length'
    REGEX          = 'regex',          'Regex Pattern'
    EMAIL          = 'email',          'Valid Email'
    PHONE          = 'phone',          'Valid Phone'
    NUMERIC        = 'numeric',        'Numeric Only'
    MIN_VALUE      = 'min_value',      'Minimum Value'
    MAX_VALUE      = 'max_value',      'Maximum Value'
    IN_CHOICES     = 'in_choices',     'Allowed Choices'
    MAX_DECIMAL    = 'max_decimal',    'Max Decimal Places'
    BOOLEAN        = 'boolean',        'Boolean'


# ─── Standard error code catalogue ─────────────────────────────────────────
class ErrorCode(models.TextChoices):
    FIELD_REQUIRED   = 'FIELD_REQUIRED',   'Field Required'
    MIN_LENGTH       = 'MIN_LENGTH',       'Min Length Violation'
    MAX_LENGTH       = 'MAX_LENGTH',       'Max Length Violation'
    REGEX_MISMATCH   = 'REGEX_MISMATCH',   'Regex Mismatch'
    INVALID_EMAIL    = 'INVALID_EMAIL',    'Invalid Email'
    INVALID_PHONE    = 'INVALID_PHONE',    'Invalid Phone'
    NUMERIC_ONLY     = 'NUMERIC_ONLY',     'Numeric Only'
    MIN_VALUE        = 'MIN_VALUE',        'Min Value Violation'
    MAX_VALUE        = 'MAX_VALUE',        'Max Value Violation'
    INVALID_CHOICE   = 'INVALID_CHOICE',   'Invalid Choice'
    MAX_DECIMAL      = 'MAX_DECIMAL',      'Max Decimal Violation'
    INVALID_BOOLEAN  = 'INVALID_BOOLEAN',  'Invalid Boolean'
    # System-level codes (not stored in FieldRule, returned by the engine)
    SCHEMA_NOT_FOUND = 'SCHEMA_NOT_FOUND', 'Schema Not Found'
    INVALID_PAYLOAD  = 'INVALID_PAYLOAD',  'Invalid Payload'


# ─── Default messages (fallback if FieldRule.error_message is blank) ────────
DEFAULT_MESSAGES = {
    ErrorCode.FIELD_REQUIRED:   '{field} is required.',
    ErrorCode.MIN_LENGTH:       '{field} must be at least {limit} characters.',
    ErrorCode.MAX_LENGTH:       '{field} must be no more than {limit} characters.',
    ErrorCode.REGEX_MISMATCH:   '{field} contains an invalid value.',
    ErrorCode.INVALID_EMAIL:    '{field} must be a valid email address.',
    ErrorCode.INVALID_PHONE:    '{field} must be a valid phone number.',
    ErrorCode.NUMERIC_ONLY:     '{field} must be a numeric value.',
    ErrorCode.MIN_VALUE:        '{field} must be at least {limit}.',
    ErrorCode.MAX_VALUE:        '{field} must be no more than {limit}.',
    ErrorCode.INVALID_CHOICE:   '{field} must be one of: {limit}.',
    ErrorCode.MAX_DECIMAL:      '{field} must have no more than {limit} decimal places.',
    ErrorCode.INVALID_BOOLEAN:  '{field} must be a boolean (true/false).',
}


# ─── Models ─────────────────────────────────────────────────────────────────

class ValidationSchema(models.Model):
    """
    One schema per "type" string (e.g. "process_payment", "booking_form").
    Groups all the field rules that apply to that type.
    """
    schema_type = models.CharField(
        max_length=100, unique=True, db_index=True,
        help_text='Unique identifier sent by the client as data.type (e.g. "process_payment").',
    )
    description = models.TextField(
        blank=True,
        help_text='Human-readable description of what this schema validates.',
    )
    # When fail_fast=True the engine stops at the FIRST failing rule per field.
    # When False it collects ALL rule failures for every field.
    fail_fast = models.BooleanField(
        default=True,
        help_text='Stop at the first failing rule per field (recommended).',
    )
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'validation_schemas'
        verbose_name = 'Validation Schema'
        verbose_name_plural = 'Validation Schemas'
        ordering = ['schema_type']

    def __str__(self):
        return self.schema_type


class FieldRule(models.Model):
    """
    One rule applied to one field within a ValidationSchema.

    Multiple FieldRule rows can target the same field_name — they are
    evaluated in `order` ascending.  Use `order` to control priority:
    e.g. run REQUIRED (order=1) before REGEX (order=2).

    Placeholders supported in error_message:
        {field}  → the field name
        {value}  → the submitted value
        {limit}  → the rule_value (e.g. "6" for min_length)
    """
    schema = models.ForeignKey(
        ValidationSchema,
        on_delete=models.CASCADE,
        related_name='rules',
    )
    field_name = models.CharField(
        max_length=100,
        help_text='Key in the fields dict (e.g. "name", "amount").',
    )
    rule_type = models.CharField(
        max_length=30,
        choices=RuleType.choices,
        help_text='The kind of validation to perform.',
    )
    # rule_value meaning depends on rule_type:
    #   min_length / max_length  → integer string, e.g. "6"
    #   regex                    → the pattern string, e.g. "^[A-Za-z]+$"
    #   min_value / max_value    → numeric string, e.g. "1"
    #   in_choices               → comma-separated, e.g. "PKR,USD,EUR"
    #   max_decimal              → integer string, e.g. "2"
    #   required / email / phone / numeric / boolean → leave blank
    rule_value = models.CharField(
        max_length=500, blank=True, default='',
        help_text='Rule parameter (pattern, limit, choices…). Leave blank for rules that need no parameter.',
    )
    error_code = models.CharField(
        max_length=50,
        choices=ErrorCode.choices,
        help_text='Standardised error code returned to the client on failure.',
    )
    error_message = models.CharField(
        max_length=500, blank=True, default='',
        help_text=(
            'Custom message. Leave blank to use the default. '
            'Supports {field}, {value}, {limit} placeholders.'
        ),
    )
    order = models.PositiveSmallIntegerField(
        default=10,
        help_text='Rules are evaluated lowest-order-first within the same field.',
    )
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'validation_field_rules'
        verbose_name = 'Field Rule'
        verbose_name_plural = 'Field Rules'
        ordering = ['schema', 'field_name', 'order']

    def __str__(self):
        return f'{self.schema.schema_type} › {self.field_name} [{self.rule_type}]'

    def resolve_message(self, field_name: str, value: str = '') -> str:
        """Return the final error message with placeholders filled in."""
        template = self.error_message.strip() or DEFAULT_MESSAGES.get(self.error_code, self.error_code)
        return template.format(
            field=field_name,
            value=value,
            limit=self.rule_value,
        )
