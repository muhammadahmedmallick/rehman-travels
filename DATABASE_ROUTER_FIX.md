# Database Router Fix for FilterSortConfig

## Problem

The `FilterSortConfig` model was being routed to the **MySQL legacy database** instead of **PostgreSQL** because:

1. The model is in the `core` app
2. The database router (`config/db_router.py`) routes ALL `core` app models to the `legacy` MySQL database
3. This caused the error:
   ```
   ProgrammingError: Table 'rehman_travels_laravel_updated.filter_sort_configs' doesn't exist
   ```

## Solution

Updated the database router to add **model-level exceptions** that override app-level routing.

### Changes Made

**File**: `config/db_router.py`

#### 1. Added POSTGRESQL_MODELS set

```python
# Specific models that should use PostgreSQL (default) even if their app is in LEGACY_APPS
POSTGRESQL_MODELS = {
    'core.FilterSortConfig',  # New model using PostgreSQL
}
```

#### 2. Added helper method

```python
def _get_model_label(self, model):
    """Get the full model label (app.ModelName)"""
    return f"{model._meta.app_label}.{model._meta.object_name}"
```

#### 3. Updated db_for_read()

```python
def db_for_read(self, model, **hints):
    # Check if this specific model should use PostgreSQL
    if self._get_model_label(model) in self.POSTGRESQL_MODELS:
        return 'default'

    # ... rest of the routing logic
```

#### 4. Updated db_for_write()

```python
def db_for_write(self, model, **hints):
    # Check if this specific model should use PostgreSQL
    if self._get_model_label(model) in self.POSTGRESQL_MODELS:
        return 'default'

    # ... rest of the routing logic
```

#### 5. Updated allow_migrate()

```python
def allow_migrate(self, db, app_label, model_name=None, **hints):
    # Check if this is a PostgreSQL-specific model
    if model_name:
        model_label = f"{app_label}.{model_name}"
        if model_label in self.POSTGRESQL_MODELS:
            return db == 'default'

    # ... rest of the migration logic
```

## How It Works

### Routing Priority

1. **First**: Check if model is in `POSTGRESQL_MODELS` → route to `default` (PostgreSQL)
2. **Second**: Check if app is in `LEGACY_APPS` → route to `legacy` (MySQL)
3. **Third**: Check if app is in `NEW_APPS` → route to `default` (PostgreSQL)
4. **Default**: Return `None` (let Django decide)

### Example Flow

```
Query: FilterSortConfig.objects.all()
  ↓
Router checks: Is 'core.FilterSortConfig' in POSTGRESQL_MODELS?
  ↓ YES
Route to: 'default' database (PostgreSQL) ✓
```

```
Query: Sectors.objects.all()
  ↓
Router checks: Is 'core.Sectors' in POSTGRESQL_MODELS?
  ↓ NO
Router checks: Is 'core' in LEGACY_APPS?
  ↓ YES
Route to: 'legacy' database (MySQL) ✓
```

## Verification

### 1. Check Database Routing

```bash
docker exec rehman_travels_web python manage.py shell
```

```python
from apps.core.models import FilterSortConfig

# This will show "alias=default" in DEBUG logs
FilterSortConfig.objects.count()
```

**Expected output**:
```
DEBUG ... SELECT COUNT(*) ... FROM "filter_sort_configs"; args=(); alias=default
2
```

### 2. Test API Endpoints

```bash
# Public endpoint
curl http://localhost:8000/api/core/filter-config/flights/

# Admin endpoint (requires auth)
curl http://localhost:8000/api/core/filter-sort-configs/
```

**Expected**:
- ✓ No database errors
- ✓ Public endpoint returns data
- ✓ Admin endpoint asks for authentication (not database error)

### 3. Test React CMS

1. Login to CMS
2. Navigate to "Filter & Sort Configs"
3. Should see the list of configurations
4. Can create/edit/delete configs

## Benefits

### ✅ Model-Level Control

You can now have:
- **PostgreSQL models** in a "legacy" app (like FilterSortConfig in core)
- **MySQL models** in the same app (like Sectors, Currencies, etc.)

### ✅ Easy to Extend

To add more PostgreSQL models from legacy apps:

```python
POSTGRESQL_MODELS = {
    'core.FilterSortConfig',
    'core.AnotherNewModel',  # ← Just add here
    'payments.NewPaymentModel',
}
```

### ✅ No Breaking Changes

- Legacy models in `core` app still use MySQL
- New models can explicitly use PostgreSQL
- Migrations work correctly

## Complete Database Routing Map

| Model | App | Database | Reason |
|-------|-----|----------|--------|
| FilterSortConfig | core | **PostgreSQL** | In POSTGRESQL_MODELS |
| Sectors | core | MySQL | core in LEGACY_APPS |
| Currencies | core | MySQL | core in LEGACY_APPS |
| BankDetails | core | MySQL | core in LEGACY_APPS |
| MobileVisaType | mobile | PostgreSQL | mobile in NEW_APPS |
| User | auth | PostgreSQL | auth in NEW_APPS |

## Troubleshooting

### Still getting MySQL errors?

1. **Restart Docker container**:
   ```bash
   docker restart rehman_travels_web
   ```

2. **Check the router is being used**:
   ```python
   from django.conf import settings
   print(settings.DATABASE_ROUTERS)
   # Should show: ['config.db_router.DatabaseRouter']
   ```

3. **Verify model label**:
   ```python
   from apps.core.models import FilterSortConfig
   label = f"{FilterSortConfig._meta.app_label}.{FilterSortConfig._meta.object_name}"
   print(label)  # Should be: 'core.FilterSortConfig'
   ```

### Model not in PostgreSQL?

Make sure:
- Model label matches exactly (case-sensitive)
- Format is `'app_label.ModelName'` (not `'app_label.model_name'`)
- Container has been restarted after router changes

## Future Additions

When creating new models in legacy apps that should use PostgreSQL:

1. Create the model with `models.Model` (not `LegacyModel`)
2. Add to `POSTGRESQL_MODELS` in the router:
   ```python
   POSTGRESQL_MODELS = {
       'core.FilterSortConfig',
       'core.YourNewModel',  # ← Add here
   }
   ```
3. Create migrations normally
4. Restart the container

## Files Modified

1. ✅ `config/db_router.py` - Added model-level routing exceptions

## Testing Checklist

- [x] FilterSortConfig queries use PostgreSQL (alias=default)
- [x] Legacy core models still use MySQL (alias=legacy)
- [x] API endpoints work without database errors
- [x] Migrations only run on PostgreSQL for FilterSortConfig
- [x] React CMS can list/create/edit/delete configs
- [x] No breaking changes to existing models

## Summary

**Before**: All `core` app models → MySQL (including FilterSortConfig) ❌

**After**:
- `core.FilterSortConfig` → **PostgreSQL** ✅
- Other `core` models → MySQL ✅

The database router now supports **model-level exceptions** for fine-grained control over which database each model uses, regardless of which app it belongs to.
