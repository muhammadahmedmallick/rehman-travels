# 🚀 Quick Start: Package API

## 📍 Files Created

1. **API Documentation**: `PACKAGE_API_DOCUMENTATION.md` - Complete API reference
2. **Sample CSV**: `packages_sample.csv` - Ready-to-import package data
3. **This file**: Quick reference for getting started

---

## 🔧 Essential CURL Commands

### 1. List All Packages
```bash
curl http://3.222.113.143:8000/api/mobile/packages/
```

### 2. Get Package by Slug
```bash
curl http://3.222.113.143:8000/api/mobile/packages/15-days-ramadan-umrah-2024/
```

### 3. Get Package with Suggestions (Most Useful!)
```bash
curl "http://3.222.113.143:8000/api/mobile/packages/15-days-ramadan-umrah-2024/?suggestions=true"
```

### 4. Get Featured Packages
```bash
curl http://3.222.113.143:8000/api/mobile/packages/featured/
```

### 5. Filter by Type
```bash
curl "http://3.222.113.143:8000/api/mobile/packages/by-type/?type=umrah"
```

### 6. Search Packages
```bash
curl "http://3.222.113.143:8000/api/mobile/packages/?search=ramadan"
```

### 7. Filter + Search + Sort
```bash
curl "http://3.222.113.143:8000/api/mobile/packages/?package_type=umrah&is_featured=true&ordering=-created_at"
```

---

## 📤 How to Import Sample CSV

### Method 1: Django Admin (Easiest)

1. **Login to Admin:**
   ```
   http://3.222.113.143:8000/admin/
   ```

2. **Navigate to Packages:**
   ```
   Admin > Mobile > Mobile Packages
   ```

3. **Import CSV:**
   - Click **"IMPORT"** button at top right
   - Choose file: `packages_sample.csv`
   - Click "Submit"
   - Preview the data
   - Click "Confirm import"

4. **Done!** You now have 15 sample packages

### Method 2: Django Shell

```bash
docker exec rehman_travels_web python manage.py shell
```

```python
from apps.mobile.models import MobilePackage
import csv

with open('/app/packages_sample.csv', 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        MobilePackage.objects.create(
            video_url=row['video_url'],
            package_type=row['package_type'],
            title=row['title'],
            slug=row['slug'],
            description=row['description'],
            tags=row['tags'],
            contact_no=row['contact_no'],
            whatsapp_no=row['whatsapp_no'],
            informational_message=row['informational_message'],
            starting_from=float(row['starting_from']) if row['starting_from'] else None,
            price=float(row['price']),
            currency=row['currency'],
            location=row['location'],
            is_active=row['is_active'].upper() == 'TRUE',
            is_featured=row['is_featured'].upper() == 'TRUE',
            display_order=int(row['display_order'])
        )
print("Import complete!")
```

---

## 📋 Sample CSV Preview

The `packages_sample.csv` file contains **15 ready-to-use packages**:

1. **15 Days Ramadan Umrah Package 2024** (Featured, PKR 180,000)
2. **10 Days Economy Umrah Package** (PKR 95,000)
3. **40 Days Hajj Package 2024** (Featured, PKR 500,000)
4. **7 Days Dubai Tour Package** (Featured, PKR 85,000)
5. **5 Days Turkey Tour Package** (PKR 135,000)
6. **5-Star Makkah Hotel Booking** (PKR 30,000)
7. **Karachi to Jeddah Flight Ticket** (PKR 55,000)
8. **Umrah + Dubai Combo Package** (Featured, PKR 225,000)
9. **20 Days VIP Umrah Package** (Featured, PKR 350,000)
10. **3 Days Murree Tour Package** (PKR 18,000)
11. **4 Days Naran Kaghan Tour** (PKR 25,000)
12. **6 Days Malaysia Tour Package** (Featured, PKR 110,000)
13. **4-Star Madinah Hotel Booking** (PKR 22,000)
14. **UAE Visit Visa (30 Days)** (PKR 15,000)
15. **5 Days Skardu Hunza Tour** (Featured, PKR 55,000)

**Package Types Included:**
- Umrah packages (4)
- Tour packages (6)
- Hajj package (1)
- Hotel bookings (2)
- Flight ticket (1)
- Combo package (1)
- Visa service (1)

---

## 🎯 Testing the API

### Quick Test Script

```bash
#!/bin/bash

echo "Testing Package API..."
echo ""

echo "1. Listing all packages:"
curl -s http://3.222.113.143:8000/api/mobile/packages/ | python3 -m json.tool | head -30
echo ""

echo "2. Getting featured packages:"
curl -s http://3.222.113.143:8000/api/mobile/packages/featured/ | python3 -m json.tool | head -20
echo ""

echo "3. Searching for 'umrah':"
curl -s "http://3.222.113.143:8000/api/mobile/packages/?search=umrah" | python3 -m json.tool | head -20
echo ""

echo "All tests complete!"
```

Save as `test_packages_api.sh` and run:
```bash
chmod +x test_packages_api.sh
./test_packages_api.sh
```

---

## 📱 Mobile App Integration

### Example: Fetch and Display Packages

```javascript
// Fetch all packages
fetch('http://3.222.113.143:8000/api/mobile/packages/')
  .then(response => response.json())
  .then(packages => {
    console.log('Total packages:', packages.length);
    packages.forEach(pkg => {
      console.log(`${pkg.title} - ${pkg.formatted_price}`);
    });
  });

// Fetch package with suggestions
fetch('http://3.222.113.143:8000/api/mobile/packages/15-days-ramadan-umrah-2024/?suggestions=true')
  .then(response => response.json())
  .then(data => {
    console.log('Main package:', data.package.title);
    console.log('Related packages:', data.suggestions.length);
  });

// Filter by type
fetch('http://3.222.113.143:8000/api/mobile/packages/?package_type=umrah&is_featured=true')
  .then(response => response.json())
  .then(packages => {
    console.log('Featured Umrah packages:', packages.length);
  });
```

---

## 🔍 Troubleshooting

### If API returns 404:

1. **Restart Django server:**
   ```bash
   docker-compose -f /path/to/docker-compose.yml restart web
   ```

2. **Check if migration is applied:**
   ```bash
   docker exec rehman_travels_web python manage.py showmigrations mobile
   ```

3. **Verify packages table exists:**
   ```bash
   docker exec rehman_travels_web python manage.py dbshell
   ```
   ```sql
   \dt mobile_packages;
   SELECT COUNT(*) FROM mobile_packages;
   ```

4. **Check URL routing:**
   ```bash
   docker exec rehman_travels_web python manage.py show_urls | grep package
   ```

---

## ✅ What's Been Implemented

### Backend (100% Complete)
- ✅ MobilePackage model with all fields
- ✅ Database migration applied
- ✅ PackageSerializer with computed properties
- ✅ PackageViewSet with all endpoints
- ✅ URL routing registered
- ✅ Admin interface with CSV import/export
- ✅ Filtering, searching, pagination support

### Documentation
- ✅ Complete API documentation (PACKAGE_API_DOCUMENTATION.md)
- ✅ Sample CSV with 15 packages (packages_sample.csv)
- ✅ Quick start guide (this file)
- ✅ CURL examples for all endpoints
- ✅ Mobile app integration examples

### Admin Features
- ✅ List, create, edit, delete packages
- ✅ CSV import/export
- ✅ Bulk actions (activate, deactivate, feature, unfeature)
- ✅ Auto-slug generation
- ✅ Search and filtering
- ✅ Organized fieldsets

---

## 🎉 You're All Set!

**Next Steps:**
1. Import the sample CSV via admin
2. Test the API endpoints with CURL
3. Integrate into your mobile app
4. Add real images and update content

**Need Help?**
- Full documentation: `PACKAGE_API_DOCUMENTATION.md`
- Sample data: `packages_sample.csv`
- Admin panel: `http://3.222.113.143:8000/admin/mobile/mobilepackage/`

---

**Created:** April 18, 2026
**Status:** 🟢 Ready for Production
**Sample Packages:** 15 included
