# Admin CSV Upload Guide

## 🎯 Overview

A new **CSV Import** feature has been added to the Django admin interface, allowing you to easily upload and import visa data through your web browser - no command line needed!

## 📍 How to Access

1. **Login to Django Admin**
   ```
   http://your-domain.com/admin/
   or
   http://localhost:8000/admin/
   ```

2. **Navigate to Mobile Visa Types**
   - Click on **"Mobile"** in the left sidebar
   - Click on **"Mobile Visa Types"**

3. **Click the Import Button**
   - You'll see a blue **"📤 Import from CSV"** button in the top right
   - Click this button to access the upload page

## 📤 Using the CSV Import Feature

### Step-by-Step Instructions

1. **Access the Import Page**
   - Navigate to: `Admin > Mobile > Mobile Visa Types`
   - Click **"📤 Import from CSV"** button

2. **Review Current Statistics**
   - The page shows your current database statistics:
     - Number of Visa Types
     - Number of Visa Variants
     - Number of Visa Rules

3. **Upload Your CSV Files**

   **File 1: Visa Types CSV**
   - Click "Choose File" for the first upload field
   - Select your visa types CSV file (parent categories)
   - Example file: `navigation_minimal - Visa.csv`

   **File 2: Visa Variants CSV**
   - Click "Choose File" for the second upload field
   - Select your visa variants CSV file (child options with pricing)
   - Example file: `navigation_minimal - Child Variant.csv`

4. **Optional: Clear Existing Data**
   - ⚠️ **Warning:** Only check this if you want to delete all existing visa data
   - If checked, the system will remove all visa types, variants, and rules before importing
   - Leave unchecked to update existing records or add new ones

5. **Click Import**
   - Click the **"📤 Import CSV Files"** button
   - Wait for the import to complete (usually takes a few seconds)

6. **Review Results**
   - Success messages will show:
     - ✅ Import completion status
     - 📊 Updated statistics (types, variants, rules created)
   - Any errors will be displayed in red boxes

## 📋 CSV File Requirements

### Visa Types CSV Format

**Required Columns:**
```csv
parent_slug,title,slug,order,is_active,image_url
```

**Example:**
```csv
parent_slug,title,slug,order,is_active,image_url
visa,Singapore,singapore-visa,,,
visa,Dubai,dubai-visa,,,
visa,Malaysia,malaysia-visa,,,
```

### Visa Variants CSV Format

**Required Columns:**
```csv
parent_slug(child category),title,slug,order,is_active,Requirements,Price,Currency,Sub title
```

**Example:**
```csv
parent_slug(child category),title,slug,order,is_active,Requirements,Price,Currency,Sub title
singapore-visa,30 days,singapore-30-days,,,"Visa Fees, Service Charges, 30 Days Duration",13000,PKR,
dubai-visa,30 days,dubai-30-days,,,"Immigration Fees, Tourist Visa, 30 Days Duration",26000,PKR,
```

## ✨ What Happens During Import

The system automatically:

1. **Creates/Updates Visa Types**
   - Extracts country codes (SGP, ARE, IDN, etc.)
   - Sets up proper display ordering
   - Adds default descriptions

2. **Creates/Updates Visa Variants**
   - Links variants to their parent visa types
   - Parses pricing information
   - Extracts duration, validity, and processing times
   - Determines visa categories (tourist, business, etc.)

3. **Generates Visa Rules**
   - Splits comma-separated requirements into individual rules
   - Creates database entries for each rule
   - Links rules to their variants

4. **Maintains Relationships**
   - All parent-child relationships are preserved
   - Foreign keys are properly set up
   - Data integrity is maintained

## 🔄 Update vs Fresh Import

### Update Existing Data (Recommended)
- **Leave "Clear Existing Data" UNCHECKED**
- Existing records with matching titles will be updated
- New records will be added
- Nothing is deleted
- Safe for production use

### Fresh Import (Caution!)
- **CHECK "Clear Existing Data"**
- ⚠️ Deletes ALL existing visa data first
- Then imports from scratch
- **Cannot be undone!**
- Use only when you want to completely replace all data

## 🎬 Video Walkthrough (Steps)

1. Login to admin panel
2. Click "Mobile" → "Mobile Visa Types"
3. Click "📤 Import from CSV" button
4. Upload first CSV (Visa Types)
5. Upload second CSV (Variants)
6. Leave "Clear Existing Data" unchecked (unless starting fresh)
7. Click "📤 Import CSV Files"
8. Wait for success message
9. Review statistics
10. Check the data in the admin list

## 📊 Sample Import Results

After a successful import, you might see:

```
✅ CSV import completed successfully!
📊 Current Statistics: 7 visa types, 10 variants, 49 rules
```

**Example Data Imported:**
- Singapore: 1 variant @ PKR 13,000
- Dubai/UAE: 2 variants @ PKR 26,000 - 46,000
- Indonesia: 1 variant @ PKR 26,000
- Kenya: 1 variant @ PKR 26,000
- Sri Lanka: 1 variant @ PKR 11,000
- Tajikistan: 1 variant @ PKR 36,500
- Malaysia: 1 variant @ PKR 26,500

## ❌ Troubleshooting

### Error: "Please upload a CSV file"
- **Solution:** Make sure your files have `.csv` extension
- Check that you're uploading the correct file format

### Error: "Parent not found for slug: xyz"
- **Solution:** Ensure the visa types CSV is uploaded first
- Check that slugs in the variants CSV match those in types CSV
- Verify there are no typos in the slug names

### Error: "Import failed: [error message]"
- **Solution:** Check the error message for details
- Verify CSV file format matches the expected structure
- Ensure CSV files are not corrupted or empty
- Check that all required columns are present

### No Button Visible
- **Solution:** Clear browser cache and refresh
- Make sure you're logged in as an admin user
- Verify you have permissions to access Mobile Visa Types

### Import Takes Too Long
- **Solution:** Large CSV files may take time
- Wait at least 1-2 minutes before refreshing
- Check server logs for progress
- Consider breaking large files into smaller batches

## 🔒 Permissions Required

To use this feature, your admin user must have:
- ✅ Permission to view Mobile Visa Types
- ✅ Permission to add/change Mobile Visa Types
- ✅ Permission to add/change Mobile Visa Variants
- ✅ Permission to add/change Visa Rules

Superusers have all permissions by default.

## 📁 Files Created

This feature includes the following new files:

1. **Form:** `apps/mobile/forms.py`
   - CSV upload form with validation

2. **Admin View:** Modified `apps/mobile/admin.py`
   - Custom view handler for CSV import
   - URL routing for the import page

3. **Template:** `apps/mobile/templates/admin/mobile/visa_csv_import.html`
   - Beautiful upload interface
   - Instructions and validation

4. **Button Template:** `apps/mobile/templates/admin/mobile/mobilevisatype/change_list.html`
   - Adds "Import from CSV" button to admin list

5. **Management Command:** `apps/mobile/management/commands/import_visa_csv.py`
   - Backend logic for CSV processing
   - Can also be used via command line

## 🚀 Alternative: Command Line

If you prefer using the command line, you can still use:

```bash
docker exec rehman_travels_web python manage.py import_visa_csv \
  /path/to/visa_types.csv \
  /path/to/variants.csv \
  --clear  # optional
```

## 📞 Support

For issues or questions:
1. Check the error messages displayed on the page
2. Review this guide for common solutions
3. Check `CSV_IMPORT_GUIDE.md` for detailed format specifications
4. Verify your CSV files match the expected format

## 🎉 Success!

Once imported, your visa data will be:
- ✅ Visible in the admin interface
- ✅ Available via REST API
- ✅ Ready for mobile app consumption
- ✅ Fully searchable and filterable

---

**Created:** April 18, 2026
**Feature Location:** Admin > Mobile > Mobile Visa Types > Import from CSV
**Admin URL:** `/admin/mobile/mobilevisatype/import-csv/`
