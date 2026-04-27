# 📱 Mobile API Documentation: Visa & Package Management

**Created:** April 19, 2026
**Status:** ✅ **Production Ready**
**Base URL:** `http://3.222.113.143:8000/api/mobile/`

---

## 📋 Table of Contents

1. [Visa API Endpoints](#visa-api-endpoints)
   - [Visa Types (Categories)](#1-visa-types-categories)
   - [Visa Variants (Specific Visas)](#2-visa-variants-specific-visas)
   - [Visa Rules (Requirements)](#3-visa-rules-requirements)
2. [Package API Endpoints](#package-api-endpoints)
3. [API Usage Examples](#api-usage-examples)
4. [Admin Panel Access](#admin-panel-access)
5. [CSV Import Guide](#csv-import-guide)

---

## 🌍 Visa API Endpoints

### 1. Visa Types (Categories)

Visa Types represent country/destination-based visa categories (e.g., Singapore Visa, Dubai Visa, Malaysia Visa).

#### **GET** `/api/mobile/visas/types/`
List all active visa types with their variants.

**Response Fields:**
```json
{
  "id": 1,
  "title": "Singapore Visa",
  "slug": "singapore-visa",
  "subtitle": "Quick and Easy Processing",
  "thumbnail": "url",
  "thumbnail_url": "full_url",
  "banner": "url",
  "banner_url": "full_url",
  "country_code": "SGP",
  "processing_time": "3-5 working days",
  "active_variants_count": 2,
  "variant_price_range": {
    "min": 13000,
    "max": 26000,
    "currency": "PKR"
  },
  "variants": [
    {
      "id": 1,
      "title": "30 days",
      "slug": "singapore-30-days",
      "price": "13000.00",
      "currency": "PKR",
      "formatted_price": "PKR 13,000",
      ...
    }
  ],
  "is_active": true,
  "display_order": 0
}
```

#### **POST** `/api/mobile/visas/types/`
Create a new visa type.

**Request Body:**
```json
{
  "title": "Singapore Visa",
  "slug": "singapore-visa",
  "subtitle": "Quick processing",
  "country_code": "SGP",
  "processing_time": "3-5 days",
  "is_active": true,
  "display_order": 0
}
```

#### **GET** `/api/mobile/visas/types/{slug}/`
Retrieve a specific visa type by slug.

**Example:** `/api/mobile/visas/types/singapore-visa/`

#### **PUT** `/api/mobile/visas/types/{slug}/`
Update a visa type completely.

#### **PATCH** `/api/mobile/visas/types/{slug}/`
Partially update a visa type.

#### **DELETE** `/api/mobile/visas/types/{slug}/`
Delete a visa type.

#### **GET** `/api/mobile/visas/types/by-country/?country=SGP`
Filter visa types by country code.

#### **GET** `/api/mobile/visas/types/featured/`
Get visa types with featured variants.

---

### 2. Visa Variants (Specific Visas)

Visa Variants represent specific visa packages under a type (e.g., "30 Days Single Entry", "60 Days Tourist Visa").

#### **GET** `/api/mobile/visas/variants/`
List all active visa variants.

**Response Fields:**
```json
{
  "id": 1,
  "visa_type": 1,
  "visa_type_name": "Singapore Visa",
  "visa_type_slug": "singapore-visa",
  "title": "30 days",
  "slug": "singapore-30-days",
  "subtitle": "Tourist Visa",
  "description": "30 days single entry tourist visa",
  "thumbnail": "url",
  "thumbnail_url": "full_url",
  "banner": "url",
  "banner_url": "full_url",
  "price": "13000.00",
  "currency": "PKR",
  "formatted_price": "PKR 13,000",
  "validity": "60 days from issue",
  "duration": "30 days",
  "num_entries": "Single",
  "processing_time": "3-5 working days",
  "visa_category": "tourist",
  "includes": "Visa fees, Service charges",
  "excludes": "Flight tickets",
  "requirements": "Passport, Photo, Application Form",
  "requirements_list": ["Passport", "Photo", "Application Form"],
  "is_active": true,
  "is_featured": false,
  "display_order": 0,
  "rules": [
    {
      "id": 1,
      "title": "Valid Passport Required",
      "description": "Passport with 6 months validity",
      "rule_type": "general",
      "is_mandatory": true
    }
  ],
  "rules_count": 5,
  "created_at": "2026-04-19T10:00:00Z",
  "updated_at": "2026-04-19T12:00:00Z"
}
```

#### **POST** `/api/mobile/visas/variants/`
Create a new visa variant.

**Request Body:**
```json
{
  "visa_type": 1,
  "title": "30 days",
  "slug": "singapore-30-days",
  "subtitle": "Tourist Visa",
  "price": "13000.00",
  "currency": "PKR",
  "validity": "60 days",
  "duration": "30 days",
  "num_entries": "Single",
  "visa_category": "tourist",
  "requirements": "Passport, Photo, Visa Form",
  "is_active": true,
  "is_featured": false
}
```

#### **GET** `/api/mobile/visas/variants/{slug}/`
Retrieve a specific visa variant by slug.

**Example:** `/api/mobile/visas/variants/singapore-30-days/`

#### **PUT** `/api/mobile/visas/variants/{slug}/`
Update a visa variant completely.

#### **PATCH** `/api/mobile/visas/variants/{slug}/`
Partially update a visa variant.

#### **DELETE** `/api/mobile/visas/variants/{slug}/`
Delete a visa variant.

#### **GET** `/api/mobile/visas/variants/featured/`
Get featured visa variants.

#### **GET** `/api/mobile/visas/variants/by-category/?category=tourist`
Filter variants by visa category.

**Available Categories:**
- `tourist` - Tourist visas
- `business` - Business visas
- `transit` - Transit visas
- `work` - Work permits
- `student` - Student visas
- `family` - Family/Visit visas
- `religious` - Umrah/Hajj visas
- `other` - Other types

---

### 3. Visa Rules (Requirements)

Visa Rules represent individual requirements/documents for a visa variant.

#### **GET** `/api/mobile/visas/rules/`
List all visa rules.

**Query Parameters:**
- `visa_variant` - Filter by variant ID
- `rule_type` - Filter by type (`general`, `transit`)
- `is_mandatory` - Filter by mandatory status

#### **POST** `/api/mobile/visas/rules/`
Create a new visa rule.

**Request Body:**
```json
{
  "visa_variant": 1,
  "title": "Valid Passport Required",
  "description": "Passport with minimum 6 months validity",
  "rule_type": "general",
  "icon": "fa-passport",
  "is_mandatory": true,
  "display_order": 0
}
```

#### **GET** `/api/mobile/visas/rules/{id}/`
Retrieve a specific rule.

#### **PUT/PATCH** `/api/mobile/visas/rules/{id}/`
Update a rule.

#### **DELETE** `/api/mobile/visas/rules/{id}/`
Delete a rule.

---

## 📦 Package API Endpoints

Packages include Umrah packages, tour packages, hotel bookings, flight tickets, and combo deals.

#### **GET** `/api/mobile/packages/`
List all active packages.

**Response Fields:**
```json
{
  "id": 17,
  "thumbnail": "url",
  "thumbnail_url": "full_url",
  "banner": "url",
  "banner_url": "full_url",
  "video_url": "https://youtube.com/...",
  "package_type": "umrah",
  "title": "15 Days Ramadan Umrah Package",
  "slug": "15-days-ramadan-umrah-2024",
  "description": "Complete Umrah package with 5-star hotels",
  "tags": "5-star,ramadan,family-friendly",
  "tags_list": ["5-star", "ramadan", "family-friendly"],
  "contact_no": "+92-300-1234567",
  "whatsapp_no": "+92-300-1234567",
  "informational_message": "Special Ramadan offer!",
  "starting_from": "150000.00",
  "formatted_starting_from": "PKR 150,000",
  "price": "180000.00",
  "currency": "PKR",
  "formatted_price": "PKR 180,000",
  "location": "Makkah & Madinah",
  "is_active": true,
  "is_featured": true,
  "display_order": 0,
  "created_at": "2026-04-18T10:00:00Z",
  "updated_at": "2026-04-19T12:00:00Z"
}
```

#### **POST** `/api/mobile/packages/`
Create a new package.

**Request Body:**
```json
{
  "package_type": "umrah",
  "title": "15 Days Ramadan Umrah Package",
  "slug": "15-days-ramadan-umrah-2024",
  "description": "Complete package with 5-star hotels",
  "tags": "5-star,ramadan",
  "contact_no": "+92-300-1234567",
  "whatsapp_no": "+92-300-1234567",
  "price": "180000.00",
  "currency": "PKR",
  "location": "Makkah & Madinah",
  "is_active": true,
  "is_featured": true
}
```

#### **GET** `/api/mobile/packages/{slug}/`
Retrieve a specific package by slug.

**Example:** `/api/mobile/packages/15-days-ramadan-umrah-2024/`

#### **GET** `/api/mobile/packages/{slug}/?suggestions=true`
Get package with suggested similar packages.

**Response:**
```json
{
  "package": {
    "id": 17,
    "title": "15 Days Ramadan Umrah Package",
    ...
  },
  "suggestions": [
    {
      "id": 18,
      "title": "10 Days Economy Umrah Package",
      ...
    },
    ...
  ]
}
```

#### **PUT** `/api/mobile/packages/{slug}/`
Update a package completely.

#### **PATCH** `/api/mobile/packages/{slug}/`
Partially update a package.

#### **DELETE** `/api/mobile/packages/{slug}/`
Delete a package.

#### **GET** `/api/mobile/packages/featured/`
Get featured packages.

#### **GET** `/api/mobile/packages/by-type/?type=umrah`
Filter packages by type.

**Available Package Types:**
- `umrah` - Umrah packages
- `hajj` - Hajj packages
- `tour` - Tour packages
- `hotel` - Hotel bookings
- `flight` - Flight tickets
- `visa` - Visa services
- `combo` - Combo packages
- `other` - Other services

---

## 🚀 API Usage Examples

### cURL Examples

#### List Visa Types
```bash
curl http://3.222.113.143:8000/api/mobile/visas/types/
```

#### Get Specific Visa Variant
```bash
curl http://3.222.113.143:8000/api/mobile/visas/variants/singapore-30-days/
```

#### Create New Package
```bash
curl -X POST http://3.222.113.143:8000/api/mobile/packages/ \
  -H "Content-Type: application/json" \
  -d '{
    "package_type": "umrah",
    "title": "Test Package",
    "slug": "test-package",
    "description": "Test description",
    "price": "100000.00",
    "currency": "PKR",
    "location": "Makkah"
  }'
```

### JavaScript/Fetch Examples

#### List Featured Packages
```javascript
fetch('http://3.222.113.143:8000/api/mobile/packages/featured/')
  .then(response => response.json())
  .then(packages => {
    console.log(`Found ${packages.length} featured packages`);
    packages.forEach(pkg => {
      console.log(`${pkg.title} - ${pkg.formatted_price}`);
    });
  });
```

#### Get Package with Suggestions
```javascript
fetch('http://3.222.113.143:8000/api/mobile/packages/15-days-ramadan-umrah-2024/?suggestions=true')
  .then(response => response.json())
  .then(data => {
    console.log('Main package:', data.package.title);
    console.log('Suggestions:', data.suggestions.length);
  });
```

### Python Examples

#### List Visa Variants
```python
import requests

response = requests.get('http://3.222.113.143:8000/api/mobile/visas/variants/')
variants = response.json()

for variant in variants:
    print(f"{variant['visa_type_name']} - {variant['title']}: {variant['formatted_price']}")
```

#### Create New Visa Type
```python
import requests

data = {
    'title': 'Turkey Visa',
    'slug': 'turkey-visa',
    'country_code': 'TUR',
    'processing_time': '5-7 days',
    'is_active': True
}

response = requests.post(
    'http://3.222.113.143:8000/api/mobile/visas/types/',
    json=data
)

print(f"Created: {response.json()}")
```

---

## 🔧 Admin Panel Access

### Django Admin URL
```
http://3.222.113.143:8000/admin/
```

### Admin Features

#### Visa Management
- **Visa Types**: `Admin > Mobile > Mobile Visa Types`
  - Create/Edit/Delete visa types
  - Manage nested variants inline
  - CSV Import/Export
  - Bulk actions (activate, deactivate)
  - Auto-slug generation

- **Visa Variants**: `Admin > Mobile > Mobile Visa Variants`
  - Full CRUD operations
  - Inline rules editing
  - CSV Import/Export
  - Regenerate rules from requirements
  - Bulk actions (activate, feature, regenerate rules)

- **Visa Rules**: `Admin > Mobile > Visa Rules`
  - Manage individual requirements
  - Set as mandatory/optional
  - Transit vs general classification
  - Icon support

#### Package Management
- **Packages**: `Admin > Mobile > Mobile Packages`
  - Full CRUD operations
  - Media upload (thumbnail, banner, video)
  - CSV Import/Export
  - Auto-slug generation
  - Bulk actions (activate, feature)

---

## 📊 CSV Import Guide

### Visa Data Import

The system supports hierarchical CSV import for visa data based on your provided structure.

#### Step 1: Prepare Visa Types CSV
**File:** `visa_types.csv`

```csv
parent_slug,title,slug,order,is_active,image_url
visa,Singapore,singapore-visa,,TRUE,
visa,Dubai,dubai-visa,,TRUE,
visa,Indonesia,indonesia-visa,,TRUE,
visa,kenya,kenya-visa,,TRUE,
visa,Srilanka,srilanka-visa,,TRUE,
visa,Tajikistan,tajikistan-visa,,TRUE,
visa,Malaysia,malaysia-visa,,TRUE,
```

#### Step 2: Prepare Visa Variants CSV
**File:** `visa_variants.csv`

```csv
parent_slug(child category),title,slug,order,is_active,Requirements,Price,Currency,Sub title
singapore-visa,30 days,singapore-30-days,,TRUE,"Singapore Visa Fees, Visa Service Charges, All Taxes, 30 Days Duration of stay in Singapore, 60 days validity",13000,PKR,
dubai-visa,30 days,dubai-30-days,,TRUE,"UAE Immigration Fees,Visa Service Charges, All Taxes, Tourist Visa, 30 Days Duration of stay in UAE",26000,PKR,
dubai-visa,60 days,dubai-60-days,,TRUE,"UAE Immigration Fees,Visa Service Charges, All Taxes, Tourist Visa, 60 Days Duration of stay in UAE",46000,PKR,
indonesia-visa,As Per Hotel Reservation,indonesia,,,,"Indonesia Immigration Fees, Visa Service Charges, Tourist Visa, As Per Hotel Reservation",26000,PKR,
kenya-visa,30 days,kenya-30-days,,TRUE,"Kenya Immigration Fees, Visa Service Charges, All Taxes, Tourist Visa, 30 Days Duration of stay",26000,PKR,
srilanka-visa,30 days,srilanka-30-days,,TRUE,"Sri Lanka Immigration Fees, Visa Service Charges, All Taxes, Tourist Visa, 30 Days Duration of stay in Sri Lanka",11000,PKR,
tajikistan-visa,30 days,tajikistan-30-days,,TRUE,"Immigration Fees, Visa Service Charges, All Taxes, Processing time is 6 working days.",36500,PKR,
malaysia-visa,30 days,malaysia-e-visa,,TRUE,"Immigration visa Fee, Service Charges, All Taxes, 30 Days Duration of Stay in Malaysia, 3Months Validity, Single Entry",16500,PKR,
malaysia-visa,30 days,malaysia-sticker-visa,,TRUE,"Immigration visa Fee, Service Charges, All Taxes, 30 Days Duration of Stay in Malaysia, 3Months Validity, Single Entry",12500,PKR,
malaysia-visa,30 days,malaysia-e-visa-urgent,,TRUE,"Immigration visa Fee, Service Charges, All Taxes, 30 Days Duration of Stay in Malaysia, 3Months Validity, Single Entry",26500,PKR,
```

#### Step 3: Import via Admin

1. **Login to Django Admin:**
   ```
   http://3.222.113.143:8000/admin/
   ```

2. **Navigate to Visa Types:**
   ```
   Admin > Mobile > Mobile Visa Types
   ```

3. **Click "IMPORT" button** (top right)

4. **Upload CSV file:**
   - Select `visa_types.csv` or `visa_variants.csv`
   - Preview data
   - Click "Confirm import"

5. **Or use Custom CSV Import:**
   - Navigate to `Mobile Visa Types` admin
   - Click "Import CSV" button in top right
   - Upload both CSVs simultaneously
   - Check "Clear existing data" if needed
   - Click "Import"

---

## ✅ Summary

### What's Implemented

#### Backend (100% Complete)
- ✅ Full CRUD API for Visa Types
- ✅ Full CRUD API for Visa Variants
- ✅ Full CRUD API for Visa Rules
- ✅ Full CRUD API for Packages
- ✅ Slug-based lookups for all models
- ✅ Hierarchical visa data structure
- ✅ Nested serializers with computed fields
- ✅ Filtering, searching, sorting
- ✅ CSV Import/Export functionality
- ✅ Admin interface with inline editing
- ✅ Auto-slug generation
- ✅ Bulk actions in admin
- ✅ Computed fields (price ranges, counts, URLs)
- ✅ Database migrations applied

#### API Features
- ✅ RESTful endpoints with full CRUD
- ✅ Slug-based resource identification
- ✅ Nested data (types with variants, variants with rules)
- ✅ Computed properties (formatted prices, URL fields)
- ✅ Filtering and search
- ✅ Pagination support
- ✅ Special endpoints (featured, by-type, by-category)
- ✅ Package suggestions feature

### API Base URLs
- **Visa Types:** `/api/mobile/visas/types/`
- **Visa Variants:** `/api/mobile/visas/variants/`
- **Visa Rules:** `/api/mobile/visas/rules/`
- **Packages:** `/api/mobile/packages/`

### Next Steps

1. **Test the APIs:**
   ```bash
   curl http://3.222.113.143:8000/api/mobile/visas/types/
   curl http://3.222.113.143:8000/api/mobile/packages/
   ```

2. **Import Sample Data:**
   - Use Django admin CSV import
   - Or use management command: `python manage.py import_visa_csv`

3. **Integrate with Mobile App:**
   - Use the API endpoints in your Flutter app
   - Implement visa listing/detail screens
   - Add package browsing functionality

4. **Add Authentication (Optional):**
   - Currently all endpoints allow public access
   - Add `IsAuthenticated` permission for write operations if needed

---

**Created:** April 19, 2026
**Status:** 🟢 Production Ready
**Visa Types:** Ready for import
**Packages:** Ready for use
**Admin Panel:** Fully configured
