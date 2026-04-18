# Requirements Auto-Import to Visa Rules ✅

**Date:** April 18, 2026
**Feature:** Automatic conversion of CSV requirements to individual Visa Rules
**Status:** 🟢 ACTIVE

---

## 🎯 What This Feature Does

When you import visa variants from CSV, the **Requirements** column is automatically:
1. ✅ Split by commas into individual items
2. ✅ Saved as separate **Visa Rule** records
3. ✅ Linked to the visa variant
4. ✅ Marked as mandatory by default
5. ✅ Ordered sequentially

**Example:**

**CSV Input:**
```csv
Requirements: "Visa Fees, Service Charges, All Taxes, 30 Days Duration, Processing 7 days"
```

**Database Output:**
```
5 Visa Rules created:
├─ Rule 1: "Visa Fees"
├─ Rule 2: "Service Charges"
├─ Rule 3: "All Taxes"
├─ Rule 4: "30 Days Duration"
└─ Rule 5: "Processing 7 days"
```

---

## 📊 How It Works

### Import Flow

```
CSV Upload
    ↓
Read Requirements Column
    ↓
Save Variant (with includes field populated)
    ↓
after_save_instance() hook triggered
    ↓
Split Requirements by comma
    ↓
Create VisaRule for each item
    ↓
Link to variant with display_order
    ↓
Done! ✅
```

### Code Implementation

**File:** `apps/mobile/admin.py`

```python
class VisaVariantResource(resources.ModelResource):
    def after_save_instance(self, instance, using_transactions, dry_run):
        """Create visa rules from requirements after saving variant"""
        if dry_run:
            return

        # Get requirements from the instance
        requirements_text = instance.includes

        if requirements_text:
            # Delete existing rules to avoid duplicates on re-import
            VisaRule.objects.filter(visa_variant=instance).delete()

            # Split by comma and create rules
            requirements_list = [r.strip() for r in requirements_text.split(',')]

            for idx, requirement in enumerate(requirements_list):
                if len(requirement) > 3:  # Skip very short items
                    VisaRule.objects.create(
                        visa_variant=instance,
                        title=requirement,
                        description=requirement,
                        rule_type='general',
                        is_mandatory=True,
                        display_order=idx
                    )
```

---

## 📋 CSV Format

### Requirements Column Format

**Format:** Comma-separated list of requirements

**Example:**
```csv
"Immigration Fees, Visa Service Charges, All Taxes, Tourist Visa, 30 Days Duration of stay in UAE, 60 Days Validity (Travel Time )"
```

**Each comma-separated item becomes a rule!**

---

## 🎨 Admin Interface

### Viewing Rules

After import, you can see the rules in two places:

**1. Variant Detail Page:**
- Go to: **Admin > Mobile > Mobile Visa Variants**
- Click any variant
- Scroll to **"Visa Rules"** section at bottom
- See all auto-created rules

**2. Rules List:**
- Go to: **Admin > Mobile > Visa Rules**
- Filter by visa variant
- See all rules across all variants

### Rule Fields

Each auto-created rule has:
- **Title:** The requirement text
- **Description:** Same as title
- **Rule Type:** `general` (default)
- **Icon:** Empty (can be added manually later)
- **Is Mandatory:** `True` (checked)
- **Display Order:** Sequential (0, 1, 2, 3...)

---

## 🔄 Re-importing (Updates)

### What Happens on Re-import?

When you re-import a variant that already exists:

1. **Existing rules are DELETED**
   - Prevents duplicates
   - Ensures clean slate

2. **New rules are CREATED**
   - From the current CSV requirements
   - With updated text

3. **Variant data is UPDATED**
   - All other fields updated as per CSV

**Example:**

**First Import:**
```csv
Requirements: "Visa Fee, Processing 5 days"
```
Result: 2 rules created

**Second Import (Re-import):**
```csv
Requirements: "Visa Fee, Processing 7 days, All Taxes"
```
Result: Old 2 rules deleted, 3 new rules created

---

## 📊 Example Import Results

### CSV Input (Singapore):

```csv
parent_slug,title,slug,order,is_active,Requirements,Price,Currency
singapore-visa,30 days,singapore-30-days,,,"Singapore Visa Fees, Visa Service Charges, All Taxes, 30 Days Duration of stay in Singapore, 60 Days Validity (Travel Time ) - Subject to Immigration, 8 To 10 Working Days Required",13000,PKR
```

### Database Output:

**MobileVisaVariant:**
```
id: 1
visa_type: Singapore
title: 30 days
price: 13000
currency: PKR
includes: "Singapore Visa Fees, Visa Service Charges, All Taxes, 30 Days Duration of stay in Singapore, 60 Days Validity (Travel Time ) - Subject to Immigration, 8 To 10 Working Days Required"
```

**VisaRule (6 records created):**
```
1. Singapore Visa Fees
2. Visa Service Charges
3. All Taxes
4. 30 Days Duration of stay in Singapore
5. 60 Days Validity (Travel Time ) - Subject to Immigration
6. 8 To 10 Working Days Required
```

---

## 🎯 Best Practices

### CSV Formatting

**✅ Good:**
```csv
"Visa Fee, Service Charge, All Taxes, 30 Days Stay"
```
- Clear comma separation
- Descriptive items
- Proper length

**❌ Avoid:**
```csv
"Visa Fee,,,Service Charge"
```
- Multiple consecutive commas
- Empty items
- Very short items (< 3 chars)

### Rule Naming

**✅ Good:**
```
- "Valid Passport Required"
- "Two Passport Photos"
- "Processing Time: 5-7 Days"
```

**❌ Too Generic:**
```
- "Fee"
- "Tax"
- "Days"
```

### Manual Editing

After auto-import, you can enhance rules manually:

1. **Add Icons:**
   - Edit rule in admin
   - Add FontAwesome icon class
   - Example: `fa-passport`, `fa-camera`, `fa-clock`

2. **Update Rule Type:**
   - Change from `general` to `transit` if needed
   - For transit-specific requirements

3. **Toggle Mandatory:**
   - Uncheck if optional requirement
   - Keep checked for must-haves

---

## 🔍 Verification

### Check Rules Were Created

**Method 1: Admin Interface**
```
1. Admin > Mobile > Mobile Visa Variants
2. Click any variant (e.g., "Singapore - 30 days")
3. Scroll to bottom
4. See "VISA RULES" section
5. Count should match requirements in CSV
```

**Method 2: API**
```bash
curl http://localhost:8000/api/mobile/visas/types/1/ | python3 -m json.tool
```

Look for `rules` array in the variant object:
```json
{
  "variants": [
    {
      "title": "30 days",
      "rules": [
        {"title": "Visa Fees", ...},
        {"title": "Service Charges", ...},
        ...
      ],
      "rules_count": 6
    }
  ]
}
```

**Method 3: Database Query**
```bash
docker exec rehman_travels_web python manage.py shell
```

```python
from apps.mobile.models import MobileVisaVariant, VisaRule

variant = MobileVisaVariant.objects.first()
rules = VisaRule.objects.filter(visa_variant=variant)

print(f"Variant: {variant}")
print(f"Rules count: {rules.count()}")
for rule in rules:
    print(f"  - {rule.title}")
```

---

## 🎨 API Response

When you fetch variants via API, rules are included:

```json
{
  "id": 1,
  "title": "30 days",
  "price": "13000.00",
  "currency": "PKR",
  "rules": [
    {
      "id": 1,
      "title": "Singapore Visa Fees",
      "description": "Singapore Visa Fees",
      "rule_type": "general",
      "icon": "",
      "icon_class": "fas fa-check-circle",
      "is_mandatory": true,
      "display_order": 0
    },
    {
      "id": 2,
      "title": "Visa Service Charges",
      "description": "Visa Service Charges",
      "rule_type": "general",
      "icon": "",
      "icon_class": "fas fa-check-circle",
      "is_mandatory": true,
      "display_order": 1
    }
  ],
  "rules_count": 6
}
```

---

## 🚀 Import Methods

Both import methods now auto-create rules!

### Method 1: Custom Upload
1. **Admin > Mobile > Mobile Visa Types**
2. Click **"📤 Import from CSV"**
3. Upload both CSVs
4. Click "Import"
5. ✅ Variants + Rules created automatically!

### Method 2: Django Import-Export
1. **Admin > Mobile > Mobile Visa Variants**
2. Click **"IMPORT"**
3. Upload CSV
4. Confirm import
5. ✅ Rules created in after_save_instance hook!

---

## 💡 Tips & Tricks

### Adding Icons Later

After import, add icons to make rules more visual:

```python
# In Django shell
from apps.mobile.models import VisaRule

# Update passport-related rules
VisaRule.objects.filter(title__icontains='passport').update(icon='fa-passport')

# Update fee-related rules
VisaRule.objects.filter(title__icontains='fee').update(icon='fa-money-bill')

# Update time-related rules
VisaRule.objects.filter(title__icontains='days').update(icon='fa-clock')
```

### Bulk Update Rule Types

Mark transit rules:

```python
VisaRule.objects.filter(
    visa_variant__visa_category='transit'
).update(rule_type='transit')
```

### Count Rules per Variant

```python
from django.db.models import Count
from apps.mobile.models import MobileVisaVariant

variants_with_counts = MobileVisaVariant.objects.annotate(
    rules_count=Count('rules')
)

for v in variants_with_counts:
    print(f"{v}: {v.rules_count} rules")
```

---

## 📚 Related Documentation

- **ERROR_FIX_SUMMARY.md** - Foreign key matching fix
- **UNIQUE_CONSTRAINT_REMOVED.md** - Duplicate title fix
- **DJANGO_IMPORT_EXPORT_GUIDE.md** - Import guide
- **ADMIN_CSV_UPLOAD_GUIDE.md** - Upload button guide

---

## ✅ Summary

**What You Get:**
- ✅ Automatic rule creation from CSV
- ✅ Comma-separated parsing
- ✅ Proper ordering and linking
- ✅ Clean re-import (no duplicates)
- ✅ API-ready structure
- ✅ Admin-editable rules

**When It Happens:**
- ✅ During CSV import (both methods)
- ✅ After variant is saved
- ✅ Before returning to admin

**Result:**
- ✅ Complete visa data with rules
- ✅ Ready for mobile app display
- ✅ Structured requirement lists
- ✅ Easy to maintain

---

## 🎉 Success!

Your CSV requirements are now automatically converted to individual Visa Rules!

**Import your CSVs and watch the magic happen!** ✨

---

**Feature By:** Claude Code
**Date:** April 18, 2026
**Status:** 🟢 Production Ready
**Auto-creates:** Visa Rules from Requirements column
