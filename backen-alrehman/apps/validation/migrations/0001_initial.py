from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name='ValidationSchema',
            fields=[
                ('id',          models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('schema_type', models.CharField(db_index=True, max_length=100, unique=True,
                                                 help_text='Unique identifier sent by the client as data.type.')),
                ('description', models.TextField(blank=True)),
                ('fail_fast',   models.BooleanField(default=True,
                                                    help_text='Stop at the first failing rule per field.')),
                ('is_active',   models.BooleanField(default=True)),
                ('created_at',  models.DateTimeField(auto_now_add=True)),
                ('updated_at',  models.DateTimeField(auto_now=True)),
            ],
            options={
                'verbose_name': 'Validation Schema',
                'verbose_name_plural': 'Validation Schemas',
                'db_table': 'validation_schemas',
                'ordering': ['schema_type'],
            },
        ),
        migrations.CreateModel(
            name='FieldRule',
            fields=[
                ('id',            models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('schema',        models.ForeignKey(on_delete=django.db.models.deletion.CASCADE,
                                                    related_name='rules', to='validation.validationschema')),
                ('field_name',    models.CharField(max_length=100,
                                                   help_text='Key in the fields dict (e.g. "name", "amount").')),
                ('rule_type',     models.CharField(max_length=30,
                                                   choices=[
                                                       ('required',    'Required'),
                                                       ('min_length',  'Minimum Length'),
                                                       ('max_length',  'Maximum Length'),
                                                       ('regex',       'Regex Pattern'),
                                                       ('email',       'Valid Email'),
                                                       ('phone',       'Valid Phone'),
                                                       ('numeric',     'Numeric Only'),
                                                       ('min_value',   'Minimum Value'),
                                                       ('max_value',   'Maximum Value'),
                                                       ('in_choices',  'Allowed Choices'),
                                                       ('max_decimal', 'Max Decimal Places'),
                                                       ('boolean',     'Boolean'),
                                                   ])),
                ('rule_value',    models.CharField(blank=True, default='', max_length=500)),
                ('error_code',    models.CharField(max_length=50,
                                                   choices=[
                                                       ('FIELD_REQUIRED',  'Field Required'),
                                                       ('MIN_LENGTH',      'Min Length Violation'),
                                                       ('MAX_LENGTH',      'Max Length Violation'),
                                                       ('REGEX_MISMATCH',  'Regex Mismatch'),
                                                       ('INVALID_EMAIL',   'Invalid Email'),
                                                       ('INVALID_PHONE',   'Invalid Phone'),
                                                       ('NUMERIC_ONLY',    'Numeric Only'),
                                                       ('MIN_VALUE',       'Min Value Violation'),
                                                       ('MAX_VALUE',       'Max Value Violation'),
                                                       ('INVALID_CHOICE',  'Invalid Choice'),
                                                       ('MAX_DECIMAL',     'Max Decimal Violation'),
                                                       ('INVALID_BOOLEAN', 'Invalid Boolean'),
                                                       ('SCHEMA_NOT_FOUND','Schema Not Found'),
                                                       ('INVALID_PAYLOAD', 'Invalid Payload'),
                                                   ])),
                ('error_message', models.CharField(blank=True, default='', max_length=500)),
                ('order',         models.PositiveSmallIntegerField(default=10)),
                ('is_active',     models.BooleanField(default=True)),
            ],
            options={
                'verbose_name': 'Field Rule',
                'verbose_name_plural': 'Field Rules',
                'db_table': 'validation_field_rules',
                'ordering': ['schema', 'field_name', 'order'],
            },
        ),
    ]
