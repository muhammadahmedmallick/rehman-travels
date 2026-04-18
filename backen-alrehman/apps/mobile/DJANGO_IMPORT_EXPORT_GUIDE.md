# Django Import-Export Feature Guide

## Overview

Your admin interface now has **TWO ways** to import CSV data:

1. **Custom CSV Upload** (Green button) - Imports both files at once
2. **Django Import-Export** (Built-in) - Import each model separately

This guide covers the **built-in Django Import-Export** feature.

---

## 🎯 How to Use Django Import-Export

### Step 1: Import Visa Types First

**Important:** Always import visa types BEFORE variants!

1. Go to: **Admin > Mobile > Mobile Visa Types**
2. Click **"IMPORT"** button (top right, near "ADD MOBILE VISA TYPE")
3. Choose your `navigation_minimal - Visa.csv` file
4. Click **"Submit"**
5. Review the preview
6. Click **"Confirm import"**

### Step 2: Import Visa Variants

After visa types are imported:

1. Go to: **Admin > Mobile > Mobile Visa Variants**
2. Click **"IMPORT"** button
3. Choose your `navigation_minimal - Child Variant.csv` file
4. Click **"Submit"**
5. Review the preview
6. Click **"Confirm import"**

---

## 📋 CSV Column Mapping

### Visa Types CSV

Your CSV columns are automatically mapped:

| CSV Column | Database Field | Notes |
|------------|---------------|-------|
| `title` | `title` | Country name (e.g., "Singapore", "Dubai") |
| `order` | `display_order` | Display order (numeric) |
| `is_active` | `is_active` | Active status (defaults to True) |
| `slug` | (not used) | For reference only |
| `parent_slug` | (not used) | For reference only |
| `image_url` | (not used) | For reference only |

**Auto-Generated Fields:**
- `country_code` - Automatically detected from title
- `subtitle` - Auto-generated as "{Country} - Quick and Easy Processing"
- `description` - Auto-generated as "Get your {Country} with hassle-free processing"

### Visa Variants CSV

Your CSV columns are automatically mapped:

| CSV Column | Database Field | Notes |
|------------|----------------|-------|
| `parent_slug(child category)` | `visa_type` | Matched to parent visa type |
| `title` | `title` | Variant name (e.g., "30 days") |
| `Requirements` | `includes` | What's included |
| `Requirements` | `description` | Also copied to description |
| `Price` | `price` | Numeric price |
| `Currency` | `currency` | Currency code (e.g., "PKR") |
| `Sub title` | `subtitle` | Subtitle text |
| `slug` | (not used) | For reference only |
| `order` | `display_order` | Display order (defaults to 0) |
| `is_active` | `is_active` | Active status (defaults to True) |

**Auto-Matched Fields:**
- `visa_type` - Automatically matched from parent_slug patterns:
  - "singapore-visa" → Singapore
  - "dubai-visa" → Dubai
  - "indonesia-visa" → Indonesia
  - "kenya-visa" → kenya
  - "srilanka-visa" → Srilanka
  - "tajikistan-visa" → Tajikistan
  - "malaysia-visa" → Malaysia

---

## 🔧 What Was Fixed

The error you encountered was because the import system couldn't match parent slugs to visa types. Here's what was fixed:

### 1. Created Custom Widget
```python
class CustomVisaTypeWidget(ForeignKeyWidget):
    """Matches visa types by slug patterns"""
```

This widget now intelligently matches slugs like "singapore-visa" to the visa type "Singapore".

### 2. Updated Column Names
Changed column mappings to match your actual CSV structure:
- `parent_slug(child category)` → `visa_type`
- `Requirements` → `includes` and `description`
- `Price` → `price`
- `Currency` → `currency`
- `Sub title` → `subtitle`

### 3. Added Auto-Processing
Both resources now have `before_import_row` methods that:
- Set sensible defaults
- Auto-generate missing fields
- Extract country codes
- Process data before saving

---

## ✅ Expected Results

### After Importing Visa Types
You should see:
- ✅ 7 visa types created (or 1 skipped if already exists)
- Each with proper country codes
- Auto-generated subtitles and descriptions

### After Importing Visa Variants
You should see:
- ✅ 10 variants created (or skipped if duplicates)
- Each properly linked to parent visa type
- Prices and currency set correctly
- Requirements populated in includes field

---

## 🎨 Import Preview

Before confirming, you'll see a preview like this:

```
┌─────────────────────────────────────────────────┐
│  Import Preview                                  │
├─────────────────────────────────────────────────┤
│  New: 7 records                                  │
│  Update: 0 records                               │
│  Delete: 0 records                               │
│  Skip: 0 records                                 │
│  Error: 0 records                                │
├─────────────────────────────────────────────────┤
│  [Confirm Import]  [Cancel]                      │
└─────────────────────────────────────────────────┘
```

---

## 🚦 Troubleshooting

### Error: "null value in column visa_type_id"
**Solution:** ✅ FIXED! The custom widget now properly matches parent slugs.

### Error: "Could not import row"
**Causes:**
- Visa types not imported first
- Invalid parent_slug that doesn't match any visa type
- Missing required fields

**Solution:**
1. Import visa types first
2. Verify parent_slug values match the expected patterns
3. Check all required fields are present

### Some Records Skipped
This is normal if records already exist. The system will skip duplicates.

### Need to Re-import
If you need to start over:
1. Go to the model list page
2. Select all records
3. Choose "Delete selected" from actions dropdown
4. Confirm deletion
5. Re-import the CSV

---

## 📊 Comparison: Two Import Methods

| Feature | Custom Upload | Django Import-Export |
|---------|--------------|---------------------|
| **Button Color** | Green | Gray/Blue |
| **Button Text** | "📤 Import from CSV" | "IMPORT" |
| **Files** | 2 files at once | 1 file at a time |
| **Order** | Automatic | Manual (types first, then variants) |
| **Preview** | No preview | Yes, with review |
| **Rules Created** | Yes (auto-generated) | No (manual) |
| **Best For** | Quick bulk import | Reviewing before import |

---

## 💡 Recommendations

### Use Custom Upload When:
- ✅ You have both CSV files ready
- ✅ You trust the data
- ✅ You want rules auto-created
- ✅ You want a faster process

### Use Django Import-Export When:
- ✅ You want to review data first
- ✅ You're updating existing records
- ✅ You only have one file
- ✅ You want more control

---

## 📝 Step-by-Step Checklist

### Using Django Import-Export

- [ ] Login to admin panel
- [ ] Navigate to Mobile > Mobile Visa Types
- [ ] Click "IMPORT" button (gray, top right)
- [ ] Upload `navigation_minimal - Visa.csv`
- [ ] Click "Submit"
- [ ] Review the preview (should show "New: 7")
- [ ] Click "Confirm import"
- [ ] Wait for success message
- [ ] Navigate to Mobile > Mobile Visa Variants
- [ ] Click "IMPORT" button
- [ ] Upload `navigation_minimal - Child Variant.csv`
- [ ] Click "Submit"
- [ ] Review the preview (should show "New: 10")
- [ ] Click "Confirm import"
- [ ] Verify data in the list views

---

## 🎉 Success Indicators

After successful import, you should see:

**Visa Types:**
- Singapore (SGP)
- Dubai (ARE)
- Indonesia (IDN)
- kenya (KEN)
- Srilanka (LKA)
- Tajikistan (TJK)
- Malaysia (MYS)

**Visa Variants:**
- 10 variants with proper parent relationships
- Prices ranging from PKR 11,000 to PKR 46,000
- Requirements text populated
- All marked as active

**API Verification:**
```bash
curl http://localhost:8000/api/mobile/visas/types/
```

Should return JSON with all 7 visa types and their variants.

---

## 🔄 Need Help?

If you still encounter errors:

1. **Check Django logs:**
   ```bash
   docker logs rehman_travels_web
   ```

2. **Verify CSV format:**
   - Open CSV in text editor
   - Check column names match exactly (including parentheses)
   - Ensure no extra spaces or special characters

3. **Clear existing data:**
   - Delete all visa variants first
   - Then delete all visa types
   - Re-import from scratch

4. **Use Custom Upload Instead:**
   - Click the green "📤 Import from CSV" button
   - Upload both files at once
   - Let the system handle everything

---

**Last Updated:** April 18, 2026
**Status:** ✅ Fixed and Working
**Error Fixed:** null value in column "visa_type_id"
**Solution:** Custom widget for slug-to-type matching
