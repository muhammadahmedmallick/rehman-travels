"""
Management command: seed default ValidationSchema + FieldRule records.

Usage
-----
    python manage.py seed_validation_schemas
    python manage.py seed_validation_schemas --force   # re-creates existing schemas

Schemas seeded
--------------
  • process_payment   — payment initiation fields
  • user_register     — mobile app registration
  • booking_contact   — passenger contact info on booking screen
"""

from django.core.management.base import BaseCommand
from apps.validation.models import ErrorCode, FieldRule, RuleType, ValidationSchema


SCHEMAS = [
    {
        'schema_type': 'process_payment',
        'description': 'Validates fields submitted when initiating an APG card payment.',
        'fail_fast':   True,
        'rules': [
            # ── name ─────────────────────────────────────────────────────────
            dict(field_name='name', rule_type=RuleType.REQUIRED,   rule_value='',   error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='name', rule_type=RuleType.MIN_LENGTH, rule_value='2',  error_code=ErrorCode.MIN_LENGTH,     order=2),
            dict(field_name='name', rule_type=RuleType.MAX_LENGTH, rule_value='100',error_code=ErrorCode.MAX_LENGTH,     order=3),
            dict(field_name='name', rule_type=RuleType.REGEX,      rule_value=r'^[A-Za-z\s\'\-]+$',
                 error_code=ErrorCode.REGEX_MISMATCH,
                 error_message='name may only contain letters, spaces, hyphens and apostrophes.',
                 order=4),

            # ── amount ───────────────────────────────────────────────────────
            dict(field_name='amount', rule_type=RuleType.REQUIRED,     rule_value='',  error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='amount', rule_type=RuleType.NUMERIC,      rule_value='',  error_code=ErrorCode.NUMERIC_ONLY,   order=2),
            dict(field_name='amount', rule_type=RuleType.MIN_VALUE,    rule_value='1', error_code=ErrorCode.MIN_VALUE,      order=3),
            dict(field_name='amount', rule_type=RuleType.MAX_DECIMAL,  rule_value='2', error_code=ErrorCode.MAX_DECIMAL,    order=4),

            # ── currency ─────────────────────────────────────────────────────
            dict(field_name='currency', rule_type=RuleType.REQUIRED,   rule_value='',         error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='currency', rule_type=RuleType.IN_CHOICES, rule_value='PKR,USD,EUR,GBP,AED,SAR',
                 error_code=ErrorCode.INVALID_CHOICE,
                 error_message='currency must be one of: PKR, USD, EUR, GBP, AED, SAR.',
                 order=2),

            # ── booking_pnr ──────────────────────────────────────────────────
            dict(field_name='booking_pnr', rule_type=RuleType.REQUIRED,   rule_value='',  error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='booking_pnr', rule_type=RuleType.MIN_LENGTH, rule_value='3', error_code=ErrorCode.MIN_LENGTH,     order=2),
            dict(field_name='booking_pnr', rule_type=RuleType.MAX_LENGTH, rule_value='20',error_code=ErrorCode.MAX_LENGTH,     order=3),
        ],
    },
    {
        'schema_type': 'user_register',
        'description': 'Validates mobile app registration form fields.',
        'fail_fast':   True,
        'rules': [
            # ── full_name ────────────────────────────────────────────────────
            dict(field_name='full_name', rule_type=RuleType.REQUIRED,   rule_value='',    error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='full_name', rule_type=RuleType.MIN_LENGTH, rule_value='3',   error_code=ErrorCode.MIN_LENGTH,     order=2),
            dict(field_name='full_name', rule_type=RuleType.MAX_LENGTH, rule_value='150', error_code=ErrorCode.MAX_LENGTH,     order=3),

            # ── email ────────────────────────────────────────────────────────
            dict(field_name='email', rule_type=RuleType.REQUIRED, rule_value='', error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='email', rule_type=RuleType.EMAIL,    rule_value='', error_code=ErrorCode.INVALID_EMAIL,  order=2),
            dict(field_name='email', rule_type=RuleType.MAX_LENGTH, rule_value='254', error_code=ErrorCode.MAX_LENGTH, order=3),

            # ── phone ────────────────────────────────────────────────────────
            dict(field_name='phone', rule_type=RuleType.REQUIRED, rule_value='', error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='phone', rule_type=RuleType.PHONE,    rule_value='', error_code=ErrorCode.INVALID_PHONE,  order=2),

            # ── password ─────────────────────────────────────────────────────
            dict(field_name='password', rule_type=RuleType.REQUIRED,   rule_value='',  error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='password', rule_type=RuleType.MIN_LENGTH, rule_value='8', error_code=ErrorCode.MIN_LENGTH,
                 error_message='password must be at least 8 characters.', order=2),
            dict(field_name='password', rule_type=RuleType.MAX_LENGTH, rule_value='128', error_code=ErrorCode.MAX_LENGTH, order=3),
            dict(field_name='password', rule_type=RuleType.REGEX,
                 rule_value=r'^(?=.*[A-Za-z])(?=.*\d).+$',
                 error_code=ErrorCode.REGEX_MISMATCH,
                 error_message='password must contain at least one letter and one number.',
                 order=4),
        ],
    },
    {
        'schema_type': 'booking_contact',
        'description': 'Validates passenger contact fields on the booking screen.',
        'fail_fast':   True,
        'rules': [
            # ── email ────────────────────────────────────────────────────────
            dict(field_name='email', rule_type=RuleType.REQUIRED, rule_value='', error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='email', rule_type=RuleType.EMAIL,    rule_value='', error_code=ErrorCode.INVALID_EMAIL,  order=2),

            # ── phone ────────────────────────────────────────────────────────
            dict(field_name='phone', rule_type=RuleType.REQUIRED, rule_value='', error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='phone', rule_type=RuleType.PHONE,    rule_value='', error_code=ErrorCode.INVALID_PHONE,  order=2),

            # ── first_name ───────────────────────────────────────────────────
            dict(field_name='first_name', rule_type=RuleType.REQUIRED,   rule_value='',   error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='first_name', rule_type=RuleType.MIN_LENGTH, rule_value='2',  error_code=ErrorCode.MIN_LENGTH,     order=2),
            dict(field_name='first_name', rule_type=RuleType.MAX_LENGTH, rule_value='50', error_code=ErrorCode.MAX_LENGTH,     order=3),

            # ── last_name ────────────────────────────────────────────────────
            dict(field_name='last_name', rule_type=RuleType.REQUIRED,   rule_value='',   error_code=ErrorCode.FIELD_REQUIRED, order=1),
            dict(field_name='last_name', rule_type=RuleType.MIN_LENGTH, rule_value='2',  error_code=ErrorCode.MIN_LENGTH,     order=2),
            dict(field_name='last_name', rule_type=RuleType.MAX_LENGTH, rule_value='50', error_code=ErrorCode.MAX_LENGTH,     order=3),
        ],
    },
]


class Command(BaseCommand):
    help = 'Seed default ValidationSchema and FieldRule records.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--force',
            action='store_true',
            help='Delete and re-create existing schemas (use with caution in production).',
        )

    def handle(self, *args, **options):
        force = options['force']
        created_count = 0
        skipped_count = 0

        for schema_def in SCHEMAS:
            rules_def = schema_def.pop('rules')
            schema_type = schema_def['schema_type']

            if force:
                ValidationSchema.objects.filter(schema_type=schema_type).delete()

            schema, created = ValidationSchema.objects.get_or_create(
                schema_type=schema_type,
                defaults=schema_def,
            )

            if not created and not force:
                self.stdout.write(self.style.WARNING(f'  SKIPPED  {schema_type} (already exists, use --force to overwrite)'))
                skipped_count += 1
                schema_def['rules'] = rules_def  # restore for next iteration
                continue

            # Create rules
            for rule_data in rules_def:
                FieldRule.objects.create(schema=schema, **rule_data)

            self.stdout.write(self.style.SUCCESS(
                f'  CREATED  {schema_type}  ({len(rules_def)} rules)'
            ))
            created_count += 1
            schema_def['rules'] = rules_def  # restore

        self.stdout.write('')
        self.stdout.write(self.style.SUCCESS(f'Done. Created: {created_count}  Skipped: {skipped_count}'))
