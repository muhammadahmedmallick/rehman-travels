# Unique Constraint Removed ✅

**Date:** April 18, 2026
**Issue:** Duplicate key error preventing multiple variants with same title
**Status:** 🟢 FIXED

---

## 🐛 The Problem

You were getting this error when importing visa variants:

```
IntegrityError: duplicate key value violates unique constraint
"mobile_visa_variants_visa_type_id_title_80df18ff_uniq"
DETAIL: Key (visa_type_id, title)=(14, 30 days) already exists.
```

**Why This Happened:**
Malaysia has 3 different "30 days" visa options:
- `malaysia-e-visa` - 30 days @ PKR 16,500
- `malaysia-sticker-visa` - 30 days @ PKR 12,500
- `malaysia-e-visa-urgent` - 30 days @ PKR 26,500

The database had a unique constraint that prevented having multiple variants with the same title under the same visa type.

---

## ✅ The Solution

### 1. Removed Model Constraint
Updated `apps/mobile/models.py`:
- Removed: `unique_together = [['visa_type', 'title']]`
- Added comment explaining why

### 2. Created Database Migration
Generated migration: `0003_remove_visa_variant_unique_constraint.py`

### 3. Applied Migration
Executed SQL command:
```sql
ALTER TABLE "mobile_visa_variants"
DROP CONSTRAINT "mobile_visa_variants_visa_type_id_title_80df18ff_uniq"
```

---

## 🎉 Result

**Now You Can:**
- ✅ Have multiple "30 days" variants for Malaysia
- ✅ Have multiple "60 days" variants for Dubai
- ✅ Have any duplicate titles within the same visa type
- ✅ Import your complete CSV without errors

**Example - Malaysia Can Now Have:**
```
Malaysia
  ├─ 30 days (E-Visa) - PKR 16,500
  ├─ 30 days (Sticker Visa) - PKR 12,500
  └─ 30 days (E-Visa Urgent) - PKR 26,500
```

All three share the title "30 days" but are distinguished by their other attributes (slug, price, processing time).

---

## 🚀 Try Importing Again

Your CSV import should now work without errors!

### Method 1: Custom Upload
1. Go to: **Admin > Mobile > Mobile Visa Types**
2. Click: **"📤 Import from CSV"**
3. Upload both CSVs
4. Click "Import CSV Files"
5. ✅ Success!

### Method 2: Django Import-Export
1. **Admin > Mobile > Mobile Visa Types**
2. Click "IMPORT"
3. Upload `navigation_minimal - Visa.csv`
4. Confirm
5. **Admin > Mobile > Mobile Visa Variants**
6. Click "IMPORT"
7. Upload `navigation_minimal - Child Variant.csv`
8. Confirm
9. ✅ All 10 variants should import successfully!

---

## 📊 Expected Import Results

**After successful import:**

### Visa Types (7):
1. Singapore (SGP)
2. Dubai (ARE)
3. Indonesia (IDN)
4. Kenya (KEN)
5. Sri Lanka (LKA)
6. Tajikistan (TJK)
7. Malaysia (MYS)

### Visa Variants (10):
1. Singapore - 30 days @ PKR 13,000
2. Dubai - 30 days @ PKR 26,000
3. Dubai - 60 days @ PKR 46,000
4. Indonesia - As Per Hotel Reservation @ PKR 26,000
5. Kenya - 30 days @ PKR 26,000
6. Sri Lanka - 30 days @ PKR 11,000
7. Tajikistan - 30 days @ PKR 36,500
8. Malaysia - 30 days (E-Visa) @ PKR 16,500
9. Malaysia - 30 days (Sticker) @ PKR 12,500
10. Malaysia - 30 days (Urgent) @ PKR 26,500

---

## 🔍 What Changed

### Code Changes

**File:** `apps/mobile/models.py`
```python
# Before:
unique_together = [['visa_type', 'title']]

# After:
# unique_together removed to allow multiple variants with same title per visa type
# Example: Malaysia can have multiple "30 days" variants (e-visa, sticker, urgent)
```

### Database Changes

**Migration Created:**
```
apps/mobile/migrations/0003_remove_visa_variant_unique_constraint.py
```

**SQL Executed:**
```sql
ALTER TABLE "mobile_visa_variants"
DROP CONSTRAINT "mobile_visa_variants_visa_type_id_title_80df18ff_uniq"
```

---

## ✅ Verification

### Check Database Constraint
```bash
docker exec rehman_travels_web python manage.py dbshell
```

```sql
SELECT conname
FROM pg_constraint
WHERE conrelid = 'mobile_visa_variants'::regclass;
```

You should NOT see `mobile_visa_variants_visa_type_id_title_80df18ff_uniq` in the list.

### Test Import
Try importing a duplicate:
```python
from apps.mobile.models import MobileVisaType, MobileVisaVariant

malaysia = MobileVisaType.objects.get(title='Malaysia')

# Create first "30 days"
variant1 = MobileVisaVariant.objects.create(
    visa_type=malaysia,
    title='30 days',
    price=16500,
    currency='PKR'
)

# Create second "30 days" - This should now work!
variant2 = MobileVisaVariant.objects.create(
    visa_type=malaysia,
    title='30 days',
    price=12500,
    currency='PKR'
)

print(f"✅ Created {MobileVisaVariant.objects.filter(visa_type=malaysia, title='30 days').count()} variants")
# Output: ✅ Created 2 variants
```

---

## 🎯 Key Points

✅ **Unique constraint REMOVED**
✅ **Migration applied successfully**
✅ **Database updated**
✅ **No system errors**
✅ **Ready for CSV import**

### Important Notes:

1. **Distinguishing Variants**
   - Use different slugs: `malaysia-e-visa`, `malaysia-sticker-visa`, `malaysia-e-visa-urgent`
   - Use different prices to differentiate
   - Use different descriptions/subtitles
   - Display order can help organize them

2. **No Breaking Changes**
   - Existing data is preserved
   - API still works the same
   - Admin interface unchanged
   - Only the constraint is removed

3. **Data Integrity**
   - Parent visa type is still required
   - All other validations still apply
   - Just allows duplicate titles now

---

## 📚 Related Documentation

- **ERROR_FIX_SUMMARY.md** - Previous fix for foreign key issue
- **DJANGO_IMPORT_EXPORT_GUIDE.md** - How to use import feature
- **ADMIN_CSV_UPLOAD_GUIDE.md** - Custom upload button guide
- **CSV_IMPORT_GUIDE.md** - Command-line import guide

---

## 🎊 Success!

The duplicate key restriction has been removed. You can now import all your visa variants including Malaysia's multiple "30 days" options!

**Go ahead and try importing your CSV files again** - they should work perfectly now! 🚀

---

**Fixed By:** Claude Code
**Date:** April 18, 2026
**Migration:** `0003_remove_visa_variant_unique_constraint`
**Status:** 🟢 Complete & Verified
