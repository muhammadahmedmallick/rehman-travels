# Mobile Visa CSV Import Guide

## Overview

This guide explains how to import visa data from CSV files into the Django Mobile Visa System.

## Import Command

A Django management command has been created to import visa data from CSV files.

### Command Syntax

```bash
python manage.py import_visa_csv <visa_types_csv> <variants_csv> [--clear]
```

### Using Docker

If you're running the application in Docker:

```bash
docker exec rehman_travels_web python manage.py import_visa_csv /app/visa_types.csv /app/visa_variants.csv
```

### Parameters

- `visa_types_csv` - Path to the visa types (parent categories) CSV file
- `variants_csv` - Path to the visa variants (child options) CSV file
- `--clear` - Optional flag to clear existing visa data before import

## CSV File Formats

### Visa Types CSV Format

**Columns:** `parent_slug`, `title`, `slug`, `order`, `is_active`, `image_url`

**Example:**
```csv
parent_slug,title,slug,order,is_active,image_url
visa,Singapore,singapore-visa,,,
visa,Dubai,dubai-visa,,,
visa,Malaysia,malaysia-visa,,,
```

**Mapping to Database:**
- `title` → `MobileVisaType.title`
- `slug` → Used for linking variants
- Country codes are auto-detected from title
- `is_active` defaults to `True`
- `display_order` is set based on import order

### Visa Variants CSV Format

**Columns:** `parent_slug(child category)`, `title`, `slug`, `order`, `is_active`, `Requirements`, `Price`, `Currency`, `Sub title`

**Example:**
```csv
parent_slug(child category),title,slug,order,is_active,Requirements,Price,Currency,Sub title
singapore-visa,30 days,singapore-30-days,,,"Visa Fees, Service Charges, 30 Days Duration",13000,PKR,
dubai-visa,30 days,dubai-30-days,,,"Immigration Fees, Tourist Visa, 30 Days Duration",26000,PKR,
dubai-visa,60 days,dubai-60-days,,,"Immigration Fees, Tourist Visa, 60 Days Duration",46000,PKR,
```

**Mapping to Database:**
- `parent_slug` → Links to `MobileVisaType` by matching slug
- `title` → `MobileVisaVariant.title`
- `Requirements` → Split into individual `VisaRule` records + stored in `includes` field
- `Price` → `MobileVisaVariant.price` (as Decimal)
- `Currency` → `MobileVisaVariant.currency`
- `Sub title` → `MobileVisaVariant.subtitle`

## Import Results (Latest Run)

**Date:** April 18, 2026
**Status:** ✅ SUCCESSFUL

### Summary
- **Visa Types Imported:** 7
- **Variants Imported:** 10
- **Rules Created:** 49

### Imported Countries
1. Singapore (1 variant, PKR 13,000)
2. Dubai/UAE (2 variants, PKR 26,000 - 46,000)
3. Indonesia (1 variant, PKR 26,000)
4. Kenya (1 variant, PKR 26,000)
5. Sri Lanka (1 variant, PKR 11,000)
6. Tajikistan (1 variant, PKR 36,500)
7. Malaysia (1 variant, PKR 26,500)

## Automatic Data Processing

The import command automatically:

1. **Extracts Country Codes:**
   - Singapore → SGP
   - Dubai → ARE (United Arab Emirates)
   - Indonesia → IDN
   - Kenya → KEN
   - Sri Lanka → LKA
   - Tajikistan → TJK
   - Malaysia → MYS

2. **Determines Visa Categories:**
   - Detects "tourist", "business", "transit", "work", "student", "religious"
   - Defaults to "tourist" if not specified

3. **Parses Requirements:**
   - Splits comma-separated requirements into individual rules
   - Creates `VisaRule` records for each requirement
   - Each rule is marked as mandatory by default

4. **Extracts Details:**
   - Duration from requirements text
   - Validity periods
   - Processing times
   - Number of entries (Single/Double/Multiple)

## API Verification

After import, verify the data using the API:

```bash
# List all visa types
curl http://localhost:8000/api/mobile/visas/types/

# Get specific visa type with variants and rules
curl http://localhost:8000/api/mobile/visas/types/2/

# Filter by country
curl http://localhost:8000/api/mobile/visas/types/by_country/?country=ARE

# Get all variants
curl http://localhost:8000/api/mobile/visas/variants/
```

## Admin Interface

Access the imported data via Django Admin:

- **Visa Types:** http://localhost:8000/admin/mobile/mobilevisatype/
- **Visa Variants:** http://localhost:8000/admin/mobile/mobilevisavariant/
- **Visa Rules:** http://localhost:8000/admin/mobile/visarule/

You can also use the built-in CSV import/export functionality in the admin interface.

## Re-importing Data

To re-import data with updates:

1. **Without clearing (updates existing):**
   ```bash
   docker exec rehman_travels_web python manage.py import_visa_csv visa_types.csv variants.csv
   ```

2. **With clearing (fresh import):**
   ```bash
   docker exec rehman_travels_web python manage.py import_visa_csv visa_types.csv variants.csv --clear
   ```

   **Warning:** The `--clear` flag will delete ALL existing visa data before importing.

## Troubleshooting

### File Not Found Error
Make sure CSV files are in a location accessible from the container. Copy them to the project directory:

```bash
cp your_file.csv /Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/
```

### Parent Not Found Warning
If you see warnings like "Parent not found for slug: xyz", check that:
- The parent slug in variants CSV matches a slug in visa types CSV
- The visa types CSV was imported first
- There are no typos in the slugs

### Duplicate Entries
The import uses `update_or_create`, so duplicate imports will update existing records rather than creating duplicates.

## Files Created

- **Management Command:** `/apps/mobile/management/commands/import_visa_csv.py`
- **Documentation:** `/apps/mobile/CSV_IMPORT_GUIDE.md` (this file)

## Need Help?

For issues or questions:
1. Check the Django logs for detailed error messages
2. Verify CSV file format matches the examples above
3. Test with a small dataset first
4. Use the `--help` flag: `python manage.py import_visa_csv --help`

---

**Last Updated:** April 18, 2026
**Command Location:** `apps/mobile/management/commands/import_visa_csv.py`
