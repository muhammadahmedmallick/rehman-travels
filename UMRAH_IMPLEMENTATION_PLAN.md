# Umrah Package System - Flutter + Python Implementation Plan

## Overview

Implement a complete Umrah package system with:
- **Backend**: Django REST Framework endpoints added to existing `backen-alrehman/` project
- **Frontend**: Flutter mobile app with hardcoded navigation + dynamic content from API
- **Features**: Package listing, calculator with price calculation, and full booking creation

## User Requirements Summary

1. **First URL (Different)**: `/Umrhbookingdyn` - Interactive calculator with hotel selection, transport, visa
2. **Other URLs (Same Pattern)**: `/umrah-packages/{slug}` - Static content pages (economy, executive, etc.)
3. **No Schema Changes**: Use existing Laravel database tables (read-only integration)
4. **Content Format**: Return both HTML and Markdown for Flutter flexibility
5. **Booking Logic**: Two separate endpoints for price calculation vs full booking creation

---

# Part 1: Python Backend Implementation

## A. Django App Structure

**Location**: `/Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/`

Create new Django app:
```
apps/umrah/
├── __init__.py
├── models.py          # Import existing models from apps.cms
├── serializers.py     # Serializers for all endpoints
├── views.py           # ViewSets and custom views
├── urls.py            # URL routing
├── services.py        # Business logic (price calculation)
├── utils.py           # Helper functions (currency conversion, date calculations)
└── admin.py           # Django admin configuration
```

## B. Models (Use Existing)

All required models already exist in `apps/cms/models.py`:
- `ParentPages` - Menu structure
- `ContentPages` - Package content
- `Customers` - Customer records
- `UmrahBookingCustomers` - Main booking records
- `UmrahBookings` - Hotel bookings
- `UmrahTicketDetails` - Flight fare details
- `UmrahHotels` - Hotel master data
- `UmrahHotelRoomPeriods` - Pricing periods
- `UmrahHotelRoomPrices` - Room prices (Double/Triple/Quad/Quint)
- `UmrahVisas` - Visa pricing by nationality
- `UmrahVehicles` - Transport vehicle types
- `UmrahTransportSectors` - Transport sectors
- `UmrahVehiclePrices` - Sector-vehicle pricing
- `Currencies` - Currency conversion rates

**Action**: Import these models into `apps/umrah/models.py` for use in serializers/views.

## C. API Endpoints to Create

### 1. Menu Navigation API
**Endpoint**: `GET /api/umrah/menu/`

**Purpose**: Get Umrah dropdown menu structure for Flutter app

**Response**:
```json
{
  "parent": {
    "id": 2,
    "title": "Umrah",
    "url": "/umrah"
  },
  "items": [
    {
      "id": 1,
      "title": "Umrah Package Calculator",
      "url": "/Umrhbookingdyn",
      "type": "calculator"
    },
    {
      "id": 15,
      "title": "Economy Umrah Packages",
      "url": "/umrah-packages/economy",
      "type": "content"
    }
  ]
}
```

**Implementation**: Filter `ContentPages` where `parentid=2` (Umrah) and `status=1`, ordered by `sequence`.

---

### 2. Package Content API
**Endpoint**: `GET /api/umrah/packages/{slug}/`

**Purpose**: Get static content for package pages (economy, executive, etc.)

**Example**: `GET /api/umrah/packages/economy/`

**Response**:
```json
{
  "id": 15,
  "title": "Economy Umrah Packages",
  "url": "umrah-packages/economy",
  "meta": {
    "title": "Affordable Economy Umrah Packages 2026 | Rehman Travels",
    "description": "Book cheap economy umrah packages...",
    "canonical_url": "umrah-packages/economy"
  },
  "images": {
    "banner": "/assets/Umrah/economy-banner.webp",
    "card": "/assets/Umrah/economy-card.jpg"
  },
  "pricing": {
    "currency": "SAR",
    "price": "85000"
  },
  "content": {
    "html": {
      "short_description": "<p>Affordable umrah package...</p>",
      "description": "<h2>Package Details</h2>...",
      "includes": "<ul><li>Return flight tickets</li>...</ul>",
      "excludes": "<ul><li>Personal expenses</li>...</ul>"
    },
    "markdown": {
      "short_description": "Affordable umrah package...",
      "description": "## Package Details\n...",
      "includes": "- Return flight tickets\n- Hotel accommodation\n...",
      "excludes": "- Personal expenses\n- Extra baggage\n..."
    }
  }
}
```

**Implementation**:
- Query `ContentPages` by `urllink` field
- Convert HTML to Markdown using `html2text` library
- Return both formats

---

### 3. Calculator Initial Data API
**Endpoint**: `GET /api/umrah/calculator/init/`

**Purpose**: Get all dropdown options for the calculator

**Response** includes:
- Hotels (Makkah & Madinah) with pricing periods
- Transport sectors and vehicles with prices
- Visa options by nationality
- Currency rates

---

### 4. Price Calculation API
**Endpoint**: `POST /api/umrah/calculator/calculate/`

**Purpose**: Calculate price WITHOUT creating booking records

**Request Body**:
```json
{
  "travelers": {"adults": 2, "children": 1, "infants": 0},
  "hotels": [
    {
      "location": "Makkah",
      "hotel_id": 1,
      "check_in": "2024-06-15",
      "check_out": "2024-06-25",
      "rooms": {"Double": 1, "Triple": 1, "Quad": 0, "Quint": 0}
    }
  ],
  "transport": {"enabled": true, "sector_id": 1, "vehicle_id": 2},
  "visa": {"enabled": true, "nationality": "Pakistan"},
  "flight": {
    "enabled": true,
    "currency": "USD",
    "adult_price": 500,
    "child_price": 400,
    "infant_price": 100
  }
}
```

**Response**:
```json
{
  "breakdown": {
    "hotels": {"total": 15000, "details": [...]},
    "transport": {"total": 1500, ...},
    "visa": {"total": 1500, ...},
    "flight": {"total": 1325, ...}
  },
  "totals": {
    "sar": 19325,
    "usd": 6940,
    "gbp": 5521
  }
}
```

---

### 5. Booking Creation API
**Endpoint**: `POST /api/umrah/calculator/book/`

**Purpose**: Create full booking records in database

**Request Body**: Same as calculate endpoint + customer info
```json
{
  "customer": {
    "first_name": "Ahmed",
    "email": "ahmed@example.com",
    "mobile": "+923001234567"
  },
  "city_id": 5,
  ...same as calculate request...
}
```

**Response**:
```json
{
  "success": true,
  "booking_id": 1523,
  "customer_id": 8745,
  "quotation": {
    "html": "<div>...formatted quotation HTML...</div>",
    "whatsapp_link": "https://api.whatsapp.com/send?phone=923001234567&text=..."
  }
}
```

---

## D. Business Logic Implementation

### File: `apps/umrah/services.py`

**Key Methods**:
- `calculate_hotels()` - Hotel prices with period overlap logic
- `calculate_weekday_weekend()` - Count Thu/Fri (weekend) vs Sat-Wed (weekday)
- `calculate_transport()` - Transport: vehicle_id=5 special case (50 SAR per person)
- `calculate_visa()` - Per-person visa calculation
- `calculate_flight()` - Convert flight fares to SAR via PKR
- `convert_to_sar()` - Currency conversion via PKR intermediary
- `convert_from_sar()` - Convert SAR to other currency

### File: `apps/umrah/utils.py`

**Helper Functions**:
- `normalize_phone()` - Format phone to +92XXXXXXXXX
- `generate_quotation_html()` - Generate printable quotation
- `create_whatsapp_link()` - Generate WhatsApp share link
- `validate_date_range()` - Validate booking dates

---

## E. Implementation Details

### Currency Conversion Formula

All prices stored in SAR. Conversion process:
```
1. Input Amount (USD/GBP/etc.) → PKR
   PKR = Amount × Currency.currencyRate

2. PKR → SAR
   SAR = PKR ÷ SAR.currencyRate

3. SAR → Output Currency
   PKR = SAR × SAR.currencyRate
   Output = PKR ÷ OutputCurrency.currencyRate
```

### Weekend Logic

- **Weekdays (onDays)**: Saturday, Sunday, Monday, Tuesday, Wednesday
- **Weekends (offDays)**: Thursday, Friday

### Special Cases

1. **Vehicle ID 5**: 50 SAR per person (adults + children only)
2. **Regular Vehicles**: Single price for entire group
3. **Ramadan Periods** (`ashraType=1`): Flat rate, ignore weekday/weekend split
4. **Maximum Hotels**: 3 per booking
5. **Phone Format**: +92XXXXXXXXX (10 digits after +92)

---

# Part 2: Flutter App Implementation

## A. Project Structure

```
lib/
├── main.dart
├── config/
│   ├── api_config.dart         # API base URLs
│   └── app_theme.dart          # Theme configuration
├── models/
│   ├── umrah_menu.dart         # Menu structure
│   ├── package_content.dart    # Content page model
│   ├── hotel.dart              # Hotel model
│   ├── booking_request.dart    # Request models
│   └── price_breakdown.dart    # Response models
├── services/
│   ├── api_service.dart        # HTTP client wrapper
│   ├── umrah_api_service.dart  # Umrah-specific API calls
│   └── cache_service.dart      # Local caching (optional)
├── providers/
│   ├── calculator_provider.dart # Calculator state management
│   └── booking_provider.dart   # Booking state
├── screens/
│   ├── home_screen.dart        # Main screen with navigation
│   ├── package_detail_screen.dart  # Content pages
│   ├── calculator_screen.dart  # Calculator UI
│   └── booking_confirmation_screen.dart
├── widgets/
│   ├── umrah_dropdown.dart     # Hardcoded dropdown
│   ├── hotel_selector.dart     # Hotel selection widget
│   ├── date_range_picker.dart  # Check-in/out selector
│   ├── traveler_counter.dart   # Adult/Child/Infant counter
│   ├── price_breakdown_card.dart  # Price display
│   └── html_content_widget.dart   # HTML/Markdown renderer
└── utils/
    ├── date_utils.dart
    ├── currency_formatter.dart
    └── validators.dart
```

## B. Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State Management
  dio: ^5.4.0                   # HTTP client
  json_annotation: ^4.8.1       # JSON serialization
  flutter_html: ^3.0.0-beta.2   # HTML rendering
  flutter_markdown: ^0.6.18     # Markdown rendering
  intl: ^0.18.1                 # Date handling
  flutter_spinkit: ^5.2.0       # Loading spinners
  url_launcher: ^6.2.2          # WhatsApp links

dev_dependencies:
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
```

## C. Hardcoded Navigation Menu

### File: `lib/widgets/umrah_dropdown.dart`

8 Menu Items (Calculator + 7 Package Types):
1. Umrah Package Calculator → `/calculator`
2. Customized Umrah packages From Pakistan → `/package/customized-umrah-packages-from-pakistan`
3. Economy Umrah Packages → `/package/economy`
4. Executive Umrah Packages → `/package/executive`
5. Umrah e Visa From Pakistan → `/package/umrah-e-visa`
6. Best Umrah Packages → `/package/best-umrah-packages`
7. Ramzan Umrah Packages → `/package/ramzan-umrah-packages`
8. 15 Days Umrah Packages From Pakistan → `/package/15-days-umrah-packages-from-pakistan`

---

# Part 3: Implementation Steps

## Phase 1: Python Backend Setup (2-3 hours)

1. Create Django App: `python manage.py startapp umrah apps/umrah`
2. Add to `INSTALLED_APPS` in `config/settings/base.py`
3. Create Serializers (`apps/umrah/serializers.py`)
4. Implement Business Logic (`apps/umrah/services.py`, `apps/umrah/utils.py`)
5. Create Views (`apps/umrah/views.py`)
6. Configure URLs (`apps/umrah/urls.py` + update `config/urls.py`)
7. Test Endpoints using Swagger UI

## Phase 2: Flutter App Setup (3-4 hours)

1. Create Flutter Project: `flutter create rehman_travels_app`
2. Add Dependencies to `pubspec.yaml`
3. Generate Models with `json_serializable`
4. Create API Service Layer
5. Create State Management (Provider setup)
6. Build UI Screens (Calculator, Package Detail)
7. Create Reusable Widgets

## Phase 3: Integration & Testing (2 hours)

1. Connect Flutter to Python API
2. End-to-End Testing (calculator, content, booking)
3. Error Handling (network, validation, empty states)

## Phase 4: Polish & Deployment (1-2 hours)

1. UI Polish (loading states, error messages, confirmations)
2. Performance (caching, image optimization)
3. Build & Deploy (Backend Docker + Flutter APK/IPA)

---

# Critical Files Reference

## Python Backend

| File Path | Status | Purpose |
|-----------|--------|---------|
| `backen-alrehman/apps/umrah/serializers.py` | CREATE | API serializers |
| `backen-alrehman/apps/umrah/views.py` | CREATE | ViewSets and endpoints |
| `backen-alrehman/apps/umrah/services.py` | CREATE | Price calculation logic |
| `backen-alrehman/apps/umrah/utils.py` | CREATE | Helper functions |
| `backen-alrehman/apps/umrah/urls.py` | CREATE | URL routing |
| `backen-alrehman/config/urls.py` | UPDATE | Add umrah routes |
| `backen-alrehman/config/settings/base.py` | UPDATE | Add to INSTALLED_APPS |

## Flutter App

| File Path | Status | Purpose |
|-----------|--------|---------|
| `lib/services/umrah_api_service.dart` | CREATE | API integration |
| `lib/models/*.dart` | CREATE | Data models |
| `lib/providers/calculator_provider.dart` | CREATE | State management |
| `lib/screens/calculator_screen.dart` | CREATE | Main calculator UI |
| `lib/screens/package_detail_screen.dart` | CREATE | Content display |
| `lib/widgets/umrah_dropdown.dart` | CREATE | Hardcoded navigation |
| `pubspec.yaml` | UPDATE | Add dependencies |

## Reference Files (Laravel - for logic understanding)

| File Path | Lines | Reference For |
|-----------|-------|--------------|
| `legacy-app/rehman-travels/app/Http/Controllers/Website/UmrahController.php` | 77-256 | Price calculation logic |
| `legacy-app/rehman-travels/resources/js/Pages/Website/Umrah/Umrhbookingdyn.vue` | 1-1243 | UI/UX reference |
| `legacy-app/rehman-travels/app/Models/Site/ParentPage.php` | 28-54 | Menu structure logic |

---

# Testing Checklist

## Backend API Tests

- [ ] `GET /api/umrah/menu/` returns menu structure
- [ ] `GET /api/umrah/packages/economy/` returns content with HTML + Markdown
- [ ] `GET /api/umrah/calculator/init/` returns all dropdown data
- [ ] `POST /api/umrah/calculator/calculate/` returns price breakdown
- [ ] `POST /api/umrah/calculator/book/` creates database records
- [ ] Currency conversion works correctly (PKR intermediary)
- [ ] Weekend/weekday calculation is accurate
- [ ] Vehicle ID 5 special case (50 SAR per person)
- [ ] Ramadan period pricing (ashraType=1)
- [ ] Period overlap logic handles edge cases

## Flutter App Tests

- [ ] Navigation dropdown shows all 8 items
- [ ] Tapping menu items navigates correctly
- [ ] Package detail screen renders HTML/Markdown
- [ ] Calculator loads initial data
- [ ] Hotel selection works (max 3 hotels)
- [ ] Date pickers work correctly
- [ ] Traveler counter validation
- [ ] Transport toggle enables/disables fields
- [ ] Visa toggle works
- [ ] Calculate button shows price breakdown
- [ ] Booking button creates booking
- [ ] WhatsApp link opens correctly
- [ ] Error states display properly
- [ ] Loading states show during API calls

---

**Status**: Plan Complete - Ready for Implementation
**Last Updated**: 2026-04-12
