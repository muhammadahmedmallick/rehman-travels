# Package API Documentation

**Date:** April 18, 2026
**Feature:** Complete Package Management System for Mobile App
**Status:** 🟢 LIVE

---

## 📋 Table of Contents

1. [API Endpoints](#api-endpoints)
2. [CURL Examples](#curl-examples)
3. [Sample CSV Format](#sample-csv-format)
4. [Admin Interface](#admin-interface)
5. [Response Formats](#response-formats)

---

## 🎯 API Endpoints

### Base URL
```
http://3.222.113.143:8000/api/mobile/packages/
```

### Available Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/mobile/packages/` | List all active packages |
| GET | `/api/mobile/packages/{slug}/` | Get package by slug |
| GET | `/api/mobile/packages/{slug}/?suggestions=true` | Get package with suggestions |
| GET | `/api/mobile/packages/featured/` | Get featured packages only |
| GET | `/api/mobile/packages/by-type/?type=umrah` | Filter by package type |

---

## 🔧 CURL Examples

### 1. List All Packages

```bash
curl -X GET http://3.222.113.143:8000/api/mobile/packages/
```

**With Pretty Print:**
```bash
curl -X GET http://3.222.113.143:8000/api/mobile/packages/ | python3 -m json.tool
```

**Response:**
```json
[
  {
    "id": 1,
    "thumbnail": "/media/packages/thumbnails/umrah-2024.jpg",
    "thumbnail_url": "/media/packages/thumbnails/umrah-2024.jpg",
    "banner": "/media/packages/banners/umrah-banner.jpg",
    "banner_url": "/media/packages/banners/umrah-banner.jpg",
    "video_url": "https://youtube.com/watch?v=example",
    "package_type": "umrah",
    "title": "15 Days Ramadan Umrah Package 2024",
    "slug": "15-days-ramadan-umrah-2024",
    "description": "Complete Umrah package with 5-star hotels...",
    "tags": "ramadan,5-star,family-friendly",
    "tags_list": ["ramadan", "5-star", "family-friendly"],
    "contact_no": "+92-300-1234567",
    "whatsapp_no": "+92-300-1234567",
    "informational_message": "Limited slots available!",
    "starting_from": 150000.00,
    "formatted_starting_from": "PKR 150,000",
    "price": 180000.00,
    "currency": "PKR",
    "formatted_price": "PKR 180,000",
    "location": "Makkah & Madinah",
    "is_active": true,
    "is_featured": true,
    "display_order": 0,
    "created_at": "2026-04-18T12:00:00Z",
    "updated_at": "2026-04-18T12:00:00Z"
  }
]
```

### 2. Get Package by Slug

```bash
curl -X GET http://3.222.113.143:8000/api/mobile/packages/15-days-ramadan-umrah-2024/
```

**Response:** Single package object (same structure as above)

### 3. Get Package with Suggestions

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/15-days-ramadan-umrah-2024/?suggestions=true"
```

**Response:**
```json
{
  "package": {
    "id": 1,
    "title": "15 Days Ramadan Umrah Package 2024",
    "slug": "15-days-ramadan-umrah-2024",
    ...
  },
  "suggestions": [
    {
      "id": 2,
      "title": "10 Days Economy Umrah Package",
      ...
    },
    {
      "id": 3,
      "title": "Dubai Tour Package",
      ...
    }
  ]
}
```

### 4. Get Featured Packages

```bash
curl -X GET http://3.222.113.143:8000/api/mobile/packages/featured/
```

**Returns:** Array of packages where `is_featured=true`

### 5. Filter by Package Type

**Umrah Packages:**
```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/by-type/?type=umrah"
```

**Tour Packages:**
```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/by-type/?type=tour"
```

**Available Types:**
- `umrah` - Umrah Package
- `hajj` - Hajj Package
- `tour` - Tour Package
- `hotel` - Hotel Package
- `flight` - Flight Package
- `visa` - Visa Package
- `combo` - Combo Package
- `other` - Other

### 6. Search Packages

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?search=ramadan"
```

**Searches in:** title, description, tags, location

### 7. Filter by Multiple Criteria

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?package_type=umrah&is_featured=true&currency=PKR"
```

**Available Filters:**
- `package_type` - Filter by type
- `is_featured` - true/false
- `is_active` - true/false
- `currency` - PKR, USD, SAR, etc.
- `location` - Filter by location

### 8. Ordering/Sorting

```bash
# Sort by price (ascending)
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?ordering=price"

# Sort by price (descending)
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?ordering=-price"

# Sort by display order and creation date
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?ordering=display_order,-created_at"
```

**Available Ordering Fields:**
- `display_order`
- `price`
- `title`
- `created_at`
- `-field` for descending order

### 9. Pagination

```bash
# Default pagination (25 items per page)
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?page=1"

# Get page 2
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?page=2"
```

### 10. Combined Query

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?package_type=umrah&is_featured=true&ordering=-created_at&search=ramadan"
```

---

## 📊 Sample CSV Format

### CSV File: `packages_sample.csv`

```csv
thumbnail,banner,video_url,package_type,title,slug,description,tags,contact_no,whatsapp_no,informational_message,starting_from,price,currency,location,is_active,is_featured,display_order
,,"https://youtube.com/watch?v=example1",umrah,"15 Days Ramadan Umrah Package 2024","15-days-ramadan-umrah-2024","Complete Umrah package with 5-star hotels near Haram. Includes flights, accommodation, transportation, and Ziyarat.","ramadan,5-star,family-friendly","+92-300-1234567","+92-300-1234567","Limited slots available! Book before Ramadan.",150000,180000,PKR,"Makkah & Madinah",TRUE,TRUE,0
,,"https://youtube.com/watch?v=example2",umrah,"10 Days Economy Umrah Package","10-days-economy-umrah","Budget-friendly Umrah package with 3-star hotels, flights, and basic transportation included.","economy,budget,group","+92-300-1234567","+92-300-1234567","Best value for money!",80000,95000,PKR,"Makkah & Madinah",TRUE,FALSE,1
,,"",hajj,"40 Days Hajj Package 2024","40-days-hajj-2024","Complete Hajj package with premium accommodation, experienced guides, and all rituals covered.","hajj,premium,guided","+92-300-1234567","+92-300-1234567","Registration open now!",450000,500000,PKR,"Makkah, Madinah, Mina",TRUE,TRUE,2
,,"https://youtube.com/watch?v=example3",tour,"7 Days Dubai Tour Package","7-days-dubai-tour","Explore Dubai with Burj Khalifa, Desert Safari, Dubai Mall, and more. Includes flights and 4-star hotel.","dubai,luxury,adventure","+92-300-1234567","+92-300-1234567","Summer special offer!",75000,85000,PKR,"Dubai, UAE",TRUE,TRUE,3
,,"",tour,"5 Days Turkey Tour Package","5-days-turkey-tour","Visit Istanbul, Cappadocia, and more. Includes flights, hotels, breakfast, and guided tours.","turkey,historical,cultural","+92-300-1234567","+92-300-1234567","Limited time discount!",120000,135000,PKR,"Istanbul, Turkey",TRUE,FALSE,4
,,"",hotel,"5-Star Makkah Hotel Booking","5-star-makkah-hotel","Premium 5-star hotel booking near Haram. Walking distance to Masjid al-Haram.","5-star,haram-view,luxury","+92-300-1234567","+92-300-1234567","Best location guaranteed!",25000,30000,PKR,"Makkah",TRUE,FALSE,5
,,"",flight,"Karachi to Jeddah Flight Ticket","karachi-jeddah-flight","Round trip flight tickets from Karachi to Jeddah with major airlines.","flight,economy,round-trip","+92-300-1234567","+92-300-1234567","Flexible dates available",45000,55000,PKR,"Karachi to Jeddah",TRUE,FALSE,6
,,"",combo,"Umrah + Dubai Combo Package","umrah-dubai-combo","Perform Umrah and enjoy Dubai in one trip. 10 days total with hotels and flights included.","combo,umrah,dubai","+92-300-1234567","+92-300-1234567","Popular choice!",200000,225000,PKR,"Makkah, Madinah, Dubai",TRUE,TRUE,7
,,"https://youtube.com/watch?v=example4",umrah,"20 Days VIP Umrah Package","20-days-vip-umrah","Luxury VIP Umrah package with 5-star hotels, business class flights, private transportation.","vip,luxury,premium","+92-300-1234567","+92-300-1234567","Ultimate comfort experience",300000,350000,PKR,"Makkah & Madinah",TRUE,TRUE,8
,,"",tour,"3 Days Murree Tour Package","3-days-murree-tour","Domestic tour to Murree hills. Includes hotel, breakfast, and sightseeing.","domestic,hills,family","+92-300-1234567","+92-300-1234567","Weekend getaway special",15000,18000,PKR,"Murree, Pakistan",TRUE,FALSE,9
```

### CSV Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `thumbnail` | ImageField | No | Path to thumbnail image (400x300px) |
| `banner` | ImageField | No | Path to banner image (1920x400px) |
| `video_url` | URL | No | YouTube or video preview URL |
| `package_type` | Choice | Yes | Type: umrah, hajj, tour, hotel, flight, visa, combo, other |
| `title` | String | Yes | Package title/name |
| `slug` | String | No | URL-friendly identifier (auto-generated if empty) |
| `description` | Text | Yes | Detailed package description |
| `tags` | String | No | Comma-separated tags |
| `contact_no` | String | No | Contact phone number |
| `whatsapp_no` | String | No | WhatsApp number |
| `informational_message` | Text | No | Special message for customers |
| `starting_from` | Decimal | No | Starting price (optional) |
| `price` | Decimal | Yes | Package price |
| `currency` | String | Yes | Currency code (PKR, USD, SAR) |
| `location` | String | No | Package location/destination |
| `is_active` | Boolean | Yes | Enable/disable package (TRUE/FALSE) |
| `is_featured` | Boolean | Yes | Mark as featured (TRUE/FALSE) |
| `display_order` | Integer | Yes | Display order (0, 1, 2, ...) |

---

## 🎨 Admin Interface

### Access Admin Panel

```
URL: http://3.222.113.143:8000/admin/mobile/mobilepackage/
```

**Login credentials:** (Your admin credentials)

### Admin Features

1. **List View:**
   - View all packages with key information
   - Filter by type, status, currency, date
   - Search by title, description, tags, location
   - Bulk actions available

2. **Add/Edit Package:**
   - Form with organized fieldsets
   - Auto-slug generation from title
   - Media upload for thumbnail and banner
   - Rich text editor for description

3. **CSV Import:**
   - Click "IMPORT" button at top
   - Upload CSV file
   - Preview changes before confirming
   - Auto-creates packages from CSV

4. **CSV Export:**
   - Click "EXPORT" button
   - Choose format (CSV, XLSX, JSON)
   - Download all packages

5. **Bulk Actions:**
   - Select multiple packages
   - Mark as active/inactive
   - Mark as featured/unfeatured
   - Delete selected

---

## 📄 Response Format

### List Response (Array)

```json
[
  {
    "id": 1,
    "thumbnail": "/media/packages/thumbnails/...",
    "thumbnail_url": "/media/packages/thumbnails/...",
    "banner": "/media/packages/banners/...",
    "banner_url": "/media/packages/banners/...",
    "video_url": "https://youtube.com/...",
    "package_type": "umrah",
    "title": "Package Title",
    "slug": "package-slug",
    "description": "Full description...",
    "tags": "tag1,tag2,tag3",
    "tags_list": ["tag1", "tag2", "tag3"],
    "contact_no": "+92-300-1234567",
    "whatsapp_no": "+92-300-1234567",
    "informational_message": "Special message",
    "starting_from": 150000.00,
    "formatted_starting_from": "PKR 150,000",
    "price": 180000.00,
    "currency": "PKR",
    "formatted_price": "PKR 180,000",
    "location": "Makkah & Madinah",
    "is_active": true,
    "is_featured": true,
    "display_order": 0,
    "created_at": "2026-04-18T12:00:00Z",
    "updated_at": "2026-04-18T12:00:00Z"
  }
]
```

### Detail Response (Single Object)

Same structure as list item above.

### Suggestions Response

```json
{
  "package": {
    "id": 1,
    "title": "Matched Package",
    ...
  },
  "suggestions": [
    {
      "id": 2,
      "title": "Other Package 1",
      ...
    },
    {
      "id": 3,
      "title": "Other Package 2",
      ...
    }
  ]
}
```

---

## 🔍 Error Responses

### 404 Not Found

```json
{
  "detail": "Not found."
}
```

### 400 Bad Request

```json
{
  "error": "type parameter required"
}
```

---

## 💡 Usage Tips

### 1. Use Suggestions for Related Packages

When displaying a package detail page, use `?suggestions=true` to get related packages:

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/umrah-2024/?suggestions=true"
```

### 2. Filter Featured Packages for Homepage

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?is_featured=true&ordering=display_order"
```

### 3. Search with Type Filter

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?package_type=umrah&search=ramadan"
```

### 4. Get Budget-Friendly Options

```bash
curl -X GET "http://3.222.113.143:8000/api/mobile/packages/?ordering=price&package_type=umrah"
```

---

## ✅ Complete!

All package API endpoints are live and ready to use!

**Start using:**
1. Import sample CSV via admin
2. Test API endpoints with CURL
3. Integrate into your mobile app

**Need help?** Check the admin interface or API responses for detailed data.

---

**Created:** April 18, 2026
**Version:** 1.0
**Status:** 🟢 Production Ready
