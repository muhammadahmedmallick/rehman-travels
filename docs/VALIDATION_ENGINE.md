# Validation Engine

Rule-based field validation system for the Rehman Travels platform. Mobile clients send a payload describing which form to validate and what values were entered; the engine runs the matching DB-stored rules and returns standardised error codes with human-readable messages.

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Database Models](#database-models)
4. [Rule Types & Error Codes](#rule-types--error-codes)
5. [API Reference](#api-reference)
6. [Default Schemas](#default-schemas)
7. [Flutter Integration](#flutter-integration)
8. [Admin Panel](#admin-panel)
9. [Setup & Seeding](#setup--seeding)
10. [Extending the Engine](#extending-the-engine)

---

## Overview

The validation engine solves two problems:

- **Consistency** — every mobile screen that collects user input validates against the same rules as the backend. No duplicate regex patterns spread across Flutter, Django, and PHP.
- **Zero-deploy changes** — adding or tightening a rule (e.g. changing a max-length, adding a new required field) is done through Django Admin. No code change or app release required.

### Request / Response at a glance

```
POST /api/validation/validate/

Body:
{
  "data": {
    "type":   "process_payment",
    "fields": {
      "name":        "John Doe",
      "amount":      "1500",
      "currency":    "PKR",
      "booking_pnr": "ABC123"
    }
  }
}

200 OK — all rules passed:
{ "valid": true, "schema_type": "process_payment", "errors": {} }

422 Unprocessable Entity — one or more rules failed:
{
  "valid": false,
  "schema_type": "process_payment",
  "errors": {
    "amount": [
      { "code": "MIN_VALUE", "message": "amount must be at least 1." }
    ]
  }
}
```

---

## Architecture

```
Flutter app
    │
    │  POST /api/validation/validate/
    ▼
ValidateView  (apps/validation/views.py)
    │
    │  parse data.type + data.fields
    ▼
ValidationEngine.validate()  (apps/validation/engine.py)
    │
    ├── fetch ValidationSchema by schema_type
    ├── fetch active FieldRules ordered by (field_name, order)
    │
    └── for each field in fields:
          for each rule (respecting fail_fast):
              run checker function
              on failure → append FieldError { code, message }
    │
    ▼
ValidationResult.to_response()
    → 200 { valid: true  } or 422 { valid: false, errors: {...} }
```

### Key files

| File | Purpose |
|---|---|
| `apps/validation/models.py` | `ValidationSchema`, `FieldRule`, `RuleType`, `ErrorCode`, `DEFAULT_MESSAGES` |
| `apps/validation/engine.py` | `ValidationEngine`, `ValidationResult`, `FieldError`, all checker functions |
| `apps/validation/views.py` | `ValidateView` (POST), `SchemaInfoView` (GET) |
| `apps/validation/urls.py` | URL routing |
| `apps/validation/admin.py` | Django Admin registration |
| `apps/validation/serializers.py` | DRF serializers for schema introspection |
| `apps/validation/migrations/0001_initial.py` | DB migration |
| `apps/validation/management/commands/seed_validation_schemas.py` | Default schema seeder |
| `rehman_mobile_app/lib/features/validation/validation_service.dart` | Flutter client |
| `rehman_mobile_app/lib/core/constants/api_endpoints.dart` | Endpoint constants |

---

## Database Models

### ValidationSchema  (`validation_schemas`)

| Column | Type | Notes |
|---|---|---|
| `id` | BigAutoField | PK |
| `schema_type` | CharField(100) | Unique, indexed. Sent by client as `data.type` |
| `description` | TextField | Human-readable description |
| `fail_fast` | BooleanField | Stop at first error per field when true |
| `is_active` | BooleanField | Inactive schemas return 404 |
| `created_at` | DateTimeField | Auto |
| `updated_at` | DateTimeField | Auto |

### FieldRule  (`validation_field_rules`)

| Column | Type | Notes |
|---|---|---|
| `id` | BigAutoField | PK |
| `schema` | FK → ValidationSchema | Cascade delete |
| `field_name` | CharField(100) | Key in `data.fields` |
| `rule_type` | CharField(30) | See Rule Types below |
| `rule_value` | CharField(500) | Parameter for the rule (e.g. `"8"` for min_length) |
| `error_code` | CharField(50) | Standardised code returned to client |
| `error_message` | CharField(500) | Optional override; default template used if blank |
| `order` | PositiveSmallIntegerField | Rules run in ascending order per field |
| `is_active` | BooleanField | Inactive rules are skipped |

---

## Rule Types & Error Codes

### Rule Types

| `rule_type` | `rule_value` | What it checks |
|---|---|---|
| `required` | _(empty)_ | Field present and non-empty |
| `min_length` | `"N"` | `len(value) >= N` |
| `max_length` | `"N"` | `len(value) <= N` |
| `regex` | pattern string | `re.fullmatch(pattern, value)` |
| `email` | _(empty)_ | Basic email format |
| `phone` | _(empty)_ | E.164 or local format with `+` prefix |
| `numeric` | _(empty)_ | Value is a valid number |
| `min_value` | `"N"` | `Decimal(value) >= N` |
| `max_value` | `"N"` | `Decimal(value) <= N` |
| `in_choices` | `"A,B,C"` | Value is one of the comma-separated list |
| `max_decimal` | `"N"` | At most N decimal places |
| `boolean` | _(empty)_ | Value is `"true"`, `"false"`, `"1"`, or `"0"` |

### Error Codes

| Code | Meaning |
|---|---|
| `FIELD_REQUIRED` | Field is missing or blank |
| `MIN_LENGTH` | Value shorter than minimum |
| `MAX_LENGTH` | Value longer than maximum |
| `REGEX_MISMATCH` | Value does not match the required pattern |
| `INVALID_EMAIL` | Not a valid email address |
| `INVALID_PHONE` | Not a valid phone number |
| `NUMERIC_ONLY` | Value is not numeric |
| `MIN_VALUE` | Number is below the minimum |
| `MAX_VALUE` | Number is above the maximum |
| `INVALID_CHOICE` | Value is not in the allowed list |
| `MAX_DECIMAL` | Too many decimal places |
| `INVALID_BOOLEAN` | Value is not a boolean |
| `SCHEMA_NOT_FOUND` | `data.type` does not match any active schema |
| `INVALID_PAYLOAD` | Malformed request body |

### Default message templates

Each error code has a default message template with optional placeholders:

| Placeholder | Replaced with |
|---|---|
| `{field}` | Field name |
| `{value}` | Submitted value |
| `{limit}` | The rule's `rule_value` |

Example: `MIN_LENGTH` default → `"{field} must be at least {limit} characters."` → `"password must be at least 8 characters."`

A custom `error_message` on the `FieldRule` row overrides the template entirely.

---

## API Reference

### POST `/api/validation/validate/`

Validates a set of fields against a stored schema.

**Authentication:** None required (public endpoint).

**Request body:**

```json
{
  "data": {
    "type":   "<schema_type>",
    "fields": {
      "<field_name>": "<value>",
      ...
    }
  }
}
```

**Responses:**

| Status | Meaning |
|---|---|
| `200` | All rules passed — `{ "valid": true, "schema_type": "...", "errors": {} }` |
| `422` | One or more rules failed — `{ "valid": false, "schema_type": "...", "errors": { ... } }` |
| `404` | Schema not found — `{ "valid": false, "errors": { "type": [{ "code": "SCHEMA_NOT_FOUND", ... }] } }` |
| `400` | Malformed payload — `{ "valid": false, "errors": { "payload": [{ "code": "INVALID_PAYLOAD", ... }] } }` |

**Error shape** (`errors` value):

```json
{
  "<field_name>": [
    { "code": "MIN_LENGTH", "message": "name must be at least 2 characters." }
  ]
}
```

When `fail_fast` is true (default), each field has at most one error object. When false, it may have multiple.

---

### GET `/api/validation/schema/<schema_type>/`

Returns schema metadata and its full rule list. Intended for debugging and developer tooling.

**Response (200):**

```json
{
  "schema_type": "process_payment",
  "description": "Validates fields submitted when initiating an APG card payment.",
  "fail_fast": true,
  "is_active": true,
  "rules": [
    {
      "field_name": "name",
      "rule_type":  "required",
      "rule_value": "",
      "error_code": "FIELD_REQUIRED",
      "order": 1
    },
    ...
  ]
}
```

---

## Default Schemas

Three schemas are seeded by the management command.

### `process_payment`

Validates the APG card payment initiation form.

| Field | Rules |
|---|---|
| `name` | required, min_length(2), max_length(100), regex (letters/spaces/hyphens/apostrophes only) |
| `amount` | required, numeric, min_value(1), max_decimal(2) |
| `currency` | required, in_choices(PKR, USD, EUR, GBP, AED, SAR) |
| `booking_pnr` | required, min_length(3), max_length(20) |

### `user_register`

Validates the mobile app registration form.

| Field | Rules |
|---|---|
| `full_name` | required, min_length(3), max_length(150) |
| `email` | required, email, max_length(254) |
| `phone` | required, phone |
| `password` | required, min_length(8), max_length(128), regex (must contain letter + digit) |

### `booking_contact`

Validates passenger contact fields on the booking screen.

| Field | Rules |
|---|---|
| `email` | required, email |
| `phone` | required, phone |
| `first_name` | required, min_length(2), max_length(50) |
| `last_name` | required, min_length(2), max_length(50) |

---

## Flutter Integration

### Endpoint constants  (`lib/core/constants/api_endpoints.dart`)

```dart
// POST — validate a form
static const String validate = '/api/validation/validate/';

// GET — fetch schema metadata (debug/hints)
static String validationSchema(String schemaType) =>
    '/api/validation/schema/$schemaType/';
```

All validation calls go to `ApiEndpoints.coreApiBaseUrl` (the Django server).

### ValidationService  (`lib/features/validation/validation_service.dart`)

```dart
final svc = ValidationService();

final result = await svc.validate(
  schemaType: 'process_payment',
  fields: {
    'name':        nameController.text,
    'amount':      amountController.text,
    'currency':    selectedCurrency,
    'booking_pnr': pnr,
  },
);

if (!result.valid) {
  setState(() {
    _nameError     = result.firstMessage('name');
    _amountError   = result.firstMessage('amount');
    _currencyError = result.firstMessage('currency');
    _pnrError      = result.firstMessage('booking_pnr');
  });
  return; // stop form submission
}

// proceed with payment
```

**`ValidationResult` API:**

| Member | Type | Description |
|---|---|---|
| `valid` | `bool` | True if all rules passed |
| `schemaType` | `String` | Schema echoed back |
| `errors` | `Map<String, List<FieldError>>` | Field → list of errors |
| `firstMessage(field)` | `String?` | First error message for a field |
| `firstCode(field)` | `String?` | First error code for a field |

**`FieldError` API:**

| Member | Type | Description |
|---|---|---|
| `code` | `String` | Standardised error code (e.g. `MIN_LENGTH`) |
| `message` | `String` | Human-readable message |

---

## Admin Panel

Both models are registered in Django Admin at `/admin/`.

**ValidationSchema list view** shows: schema type, description, fail_fast flag, active status, rule count, last updated.

Clicking a schema opens the edit form with an inline `FieldRule` table — you can add, reorder, or deactivate rules without any code change or deployment.

**FieldRule standalone list view** lets you filter by schema, rule type, error code, or active status, and search by field name or message text.

---

## Setup & Seeding

### 1. Apply the migration

```bash
python manage.py migrate validation
```

This creates `validation_schemas` and `validation_field_rules` tables in PostgreSQL.

### 2. Seed default schemas

```bash
python manage.py seed_validation_schemas
```

Skips schemas that already exist. Use `--force` to delete and re-create:

```bash
python manage.py seed_validation_schemas --force
```

### 3. Verify

```bash
python manage.py shell -c "
from apps.validation.models import ValidationSchema
for s in ValidationSchema.objects.all():
    print(s.schema_type, s.rules.count(), 'rules')
"
```

Expected output:
```
process_payment 12 rules
user_register 11 rules
booking_contact 7 rules
```

---

## Extending the Engine

### Add a new schema

Do it through Admin (no code needed), or add a new entry in the `SCHEMAS` list in `seed_validation_schemas.py` and re-run the seeder with `--force`.

### Add a new rule type

1. Add the choice to `RuleType` in `models.py`.
2. Add the error code to `ErrorCode` and `DEFAULT_MESSAGES` in `models.py`.
3. Write a checker function in `engine.py`:

```python
def _check_my_rule(value: str, rule: FieldRule) -> bool:
    # return True if valid, False if invalid
    return True
```

4. Register it in `_RULE_HANDLERS`:

```python
_RULE_HANDLERS = {
    ...
    RuleType.MY_RULE: _check_my_rule,
}
```

5. Generate and apply a migration:

```bash
python manage.py makemigrations validation
python manage.py migrate validation
```

### Planned future capabilities

- **Array fields** — validate each item in a list individually.
- **Object fields** — nested dict validation with sub-rules.
- **Dependent field rules** — e.g. `confirm_password` must equal `password`.
- **Conditional required** — field required only when another field has a specific value.
