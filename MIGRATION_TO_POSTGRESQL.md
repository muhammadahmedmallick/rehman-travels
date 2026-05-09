# FilterSortConfig Migration to PostgreSQL

## Summary

The `FilterSortConfig` model has been **migrated from MySQL (legacy database) to PostgreSQL (default database)**.

## Changes Made

### 1. Model Update (`apps/core/models.py`)

**Before** (using LegacyModel):
```python
class FilterSortConfig(LegacyModel):
    # ... fields ...

    class Meta:
        managed = False
        db_table = 'filter_sort_configs'
```

**After** (using standard Django Model):
```python
class FilterSortConfig(models.Model):
    # ... fields ...
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'filter_sort_configs'
        # managed = True (default)
```

**Key Changes**:
- Removed inheritance from `LegacyModel`
- Changed to standard `models.Model`
- Removed `managed = False`
- Changed `auto_now_add=True` and `auto_now=True` for timestamps (instead of blank=True, null=True)
- Added comment: "This model uses PostgreSQL (default database)"

### 2. Migration File

**File**: `apps/core/migrations/0002_add_filtersortconfig.py`

Creates the `filter_sort_configs` table in **PostgreSQL** with:
- Serial ID (auto-incrementing)
- JSONB field for config_data
- Timestamp fields with timezone support
- Unique constraint on listing_name

### 3. Seed Command Update

**File**: `apps/core/management/commands/seed_filter_configs.py`

**Before**:
```python
# Manually created table in MySQL
with connections['legacy'].cursor() as cursor:
    cursor.execute("CREATE TABLE ...")

# Used .using('legacy')
FilterSortConfig.objects.using('legacy').update_or_create(...)
```

**After**:
```python
# Table created via Django migrations automatically
# No manual table creation needed

# Uses default database (PostgreSQL)
FilterSortConfig.objects.update_or_create(...)
```

### 4. Database Routing

Now the model automatically uses the **default database** (PostgreSQL) because:
1. It doesn't inherit from `LegacyModel`
2. It doesn't have `managed = False`
3. Django's default database router routes it to 'default'

## Database Comparison

### PostgreSQL (default) - Current ✅

```sql
CREATE TABLE filter_sort_configs (
  id SERIAL PRIMARY KEY,
  listing_name VARCHAR(50) UNIQUE NOT NULL,
  config_data JSONB NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  version VARCHAR(20) DEFAULT '1.0',
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by VARCHAR(100)
);
```

**Advantages**:
- ✅ Managed by Django migrations
- ✅ Better JSON support (JSONB with indexing)
- ✅ Proper timezone handling
- ✅ Auto-managed timestamps
- ✅ Consistent with other non-legacy models

### MySQL (legacy) - Old ❌

```sql
CREATE TABLE filter_sort_configs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  listing_name VARCHAR(50) UNIQUE NOT NULL,
  config_data JSON NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  version VARCHAR(20) DEFAULT '1.0',
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_by VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Why we moved away**:
- ❌ Manual table management required
- ❌ Less efficient JSON handling
- ❌ Inconsistent with project direction (moving to PostgreSQL)

## Migration Steps Executed

1. ✅ Updated model to use `models.Model` instead of `LegacyModel`
2. ✅ Removed old migration file (`0002_filtersortconfig.py`)
3. ✅ Created new migration (`0002_add_filtersortconfig.py`)
4. ✅ Updated seed command to remove MySQL-specific code
5. ✅ Ran migrations: `python manage.py migrate core`
6. ✅ Seeded data: `python manage.py seed_filter_configs`
7. ✅ Verified data in PostgreSQL
8. ✅ Tested API endpoints
9. ✅ Updated documentation

## Verification

### Check Data in PostgreSQL

```bash
docker exec rehman_travels_web python manage.py shell
```

```python
from apps.core.models import FilterSortConfig
print(FilterSortConfig.objects.count())  # Should be 2
print(FilterSortConfig.objects.all())    # Lists all configs
```

### Test API Endpoints

```bash
# Public endpoint (no auth)
curl http://localhost:8000/api/core/filter-config/flights/

# Admin endpoint (requires auth)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8000/api/core/filter-sort-configs/
```

### Check Database Directly

```bash
docker exec rehman_travels_web python manage.py dbshell
```

```sql
SELECT * FROM filter_sort_configs;
```

## Current State

✅ **All data is now in PostgreSQL**
- 2 configurations seeded (flights, hotels)
- API endpoints working correctly
- React CMS frontend compatible
- Django admin working

## No Action Required

The migration is **complete and transparent**. All existing functionality works the same:

- ✅ API endpoints: Same URLs, same responses
- ✅ React CMS: No changes needed
- ✅ Django Admin: Works as before
- ✅ Seed command: Works as before (just uses PostgreSQL now)

## Files Modified

1. `apps/core/models.py` - Updated FilterSortConfig model
2. `apps/core/management/commands/seed_filter_configs.py` - Removed MySQL-specific code
3. `apps/core/migrations/0002_add_filtersortconfig.py` - New migration for PostgreSQL
4. `FILTER_SORT_CONFIG_IMPLEMENTATION.md` - Updated documentation

## Rollback (If Needed)

If for some reason you need to rollback:

```bash
# Rollback migration
python manage.py migrate core 0001

# Delete migration file
rm apps/core/migrations/0002_add_filtersortconfig.py
```

Then restore the old model code. **Note**: This will delete all filter_sort_configs data in PostgreSQL.

## Future Considerations

This change aligns with the project's database strategy:
- **PostgreSQL (default)**: New features, managed by Django
- **MySQL (legacy)**: Existing tables, not managed by Django

All future models should follow this pattern and use PostgreSQL unless there's a specific reason to use the legacy database.
