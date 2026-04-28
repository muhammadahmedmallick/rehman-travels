# Developer Guide - Umrah Package System

## 📚 Architecture Overview

This document explains how all components work together.

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     FLUTTER MOBILE APP                      │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │   HomeScreen │  │CalculatorUI  │  │PackageDetailUI  │ │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘ │
│         │                 │                    │           │
│         └─────────────────┼────────────────────┘           │
│                           │                               │
│         ┌─────────────────▼────────────────┐              │
│         │   CalculatorProvider (State)     │              │
│         │  - User selections               │              │
│         │  - Price breakdown               │              │
│         │  - Hotels, transport, visa       │              │
│         └──────────────┬──────────────────┘              │
│                        │                                │
│         ┌──────────────▼──────────────┐               │
│         │   UmrahApiService (API)     │               │
│         │  - getMenu()                │               │
│         │  - getCalculatorInit()      │               │
│         │  - calculatePrice()         │               │
│         │  - createBooking()          │               │
│         └──────────────┬──────────────┘               │
└────────────────────────┼────────────────────────────────┘
                         │ HTTP (JSON)
         ┌───────────────▼──────────────┐
         │      DJANGO REST API         │
         │                              │
         │  /api/umrah/calculator/      │
         │  - menu/                     │
         │  - init/                     │
         │  - calculate/                │
         │  - book/                     │
         └───────────────┬──────────────┘
                         │
      ┌──────────────────▼──────────────────┐
      │  Django Models (Read from MySQL)    │
      │                                     │
      │  - UmrahHotels                      │
      │  - UmrahHotelRoomPeriods            │
      │  - UmrahHotelRoomPrices             │
      │  - UmrahVisas                       │
      │  - UmrahVehicles                    │
      │  - UmrahTransportSectors            │
      │  - Currencies                       │
      │  - ContentPages (for menu)          │
      └─────────────────────────────────────┘
                         │
         ┌───────────────▼──────────────┐
         │      MySQL Database          │
         │  (Shared with Laravel app)   │
         └──────────────────────────────┘
```

---

## 🔄 Data Flow Examples

### Example 1: Calculating a Package Price

```
User Input (Flutter App)
    ↓
    ├─ Select travelers: Adults=2, Children=1
    ├─ Select hotel: Makkah, Jun 15-25
    ├─ Select rooms: Double=1, Triple=1
    ├─ Enable transport: Sector=1, Vehicle=2
    ├─ Enable visa: Nationality=Pakistan
    └─ Add flight: USD 500/adult, 400/child
    ↓
CalculatorProvider builds BookingRequest
    ↓
POST /api/umrah/calculator/calculate/
    ↓
Django Backend
    ├─ Query UmrahHotels for pricing periods
    ├─ Calculate weekday/weekend nights (Thu-Fri = weekend)
    ├─ Get room prices for selected type
    ├─ Calculate transport cost (regular or per-person)
    ├─ Get visa price (× traveler count)
    ├─ Convert flight fares: USD → PKR → SAR
    ├─ Convert to USD & GBP for display
    └─ Return PriceBreakdown
    ↓
CalculatorProvider receives response
    ├─ Updates priceBreakdown state
    └─ UI refreshes with prices
    ↓
User sees breakdown:
    ├─ Hotels: ﷼ 15,000
    ├─ Transport: ﷼ 1,500
    ├─ Visa: ﷼ 1,500
    ├─ Flight: ﷼ 1,325
    ├─ Total: ﷼ 19,325 | $ 6,940 | £ 5,521
    └─ Without Flight: ﷼ 18,000 | $ 6,465 | £ 5,143
```

### Example 2: Creating a Booking

```
User Input (Flutter App)
    ↓
    ├─ First Name: Ahmed
    ├─ Email: ahmed@example.com
    ├─ Mobile: +923001234567
    └─ (All previous calculator selections)
    ↓
CalculatorProvider.createBooking()
    ↓
POST /api/umrah/calculator/book/
    ↓
Django Backend
    ├─ Find/Create Customer (by email or phone)
    ├─ Create UmrahBookingCustomers record
    ├─ Create UmrahBookings records (for each hotel)
    ├─ Create UmrahTicketDetails (if flight included)
    ├─ Generate HTML quotation
    ├─ Calculate price breakdown
    └─ Return BookingResponse
        ├─ booking_id: 1523
        ├─ customer_id: 8745
        ├─ quotation HTML
        └─ WhatsApp link
    ↓
Flutter App
    ├─ Show confirmation with booking ID
    ├─ Display quotation
    └─ Offer WhatsApp share
```

### Example 3: Fetching Package Details

```
User taps "Economy Packages" in dropdown menu
    ↓
Navigator.pushNamed(
  context,
  '/package-detail',
  arguments: {'slug': 'economy'}
)
    ↓
PackageDetailScreen builds with slug='economy'
    ↓
GET /api/umrah/packages/by-url/?url=umrah-packages/economy
    ↓
Django Backend
    ├─ Query ContentPages where urllink='umrah-packages/economy'
    ├─ Parse HTML to Markdown (html2text)
    ├─ Return PackageContent with:
    │   ├─ title: "Economy Umrah Packages"
    │   ├─ price: "85000" SAR
    │   ├─ content.html: Raw HTML
    │   └─ content.markdown: Markdown version
    ↓
Flutter App
    ├─ Display banner image
    ├─ Show title & price
    ├─ Render markdown content with flutter_markdown
    ├─ Show includes/excludes
    └─ "Book Package" button → Go to Calculator
```

---

## 📍 Key Files & Locations

### Backend (Django)

**API Endpoints**
```
backen-alrehman/apps/umrah/
├── calculator_views.py      # 4 API endpoints
├── services.py              # Price calculation logic
├── utils.py                 # Helpers (validation, formatting)
└── urls.py                  # Route definitions
```

**Price Calculation**
- `services.UmrahPriceCalculator` - Main calculator class
  - `calculate_hotels()` - Hotel pricing with periods
  - `calculate_transport()` - Transport costs
  - `calculate_visa()` - Visa fees
  - `calculate_flight()` - Flight fare conversion
  - `_count_weekday_weekend()` - Day counting logic
  - `_convert_to_sar()` - Currency conversion

**Database Models** (Read from apps.cms)
- `UmrahHotels` - Hotel master data
- `UmrahHotelRoomPeriods` - Pricing periods
- `UmrahHotelRoomPrices` - Room prices
- `UmrahVisas` - Visa packages
- `UmrahVehicles` - Transport vehicles
- `UmrahTransportSectors` - Transport sectors
- `UmrahVehiclePrices` - Vehicle pricing
- `Currencies` - Exchange rates
- `ContentPages` - Package content

### Flutter (Mobile App)

**Project Structure**
```
rehman_travels_mobile/lib/
├── main.dart                    # Entry point
├── config/
│   ├── app_theme.dart          # Theme definition
│   └── api_config.dart         # API configuration
├── models/
│   ├── menu_models.dart        # Menu structures
│   ├── calculator_models.dart  # Request models
│   └── price_models.dart       # Response models
├── services/
│   └── umrah_api_service.dart  # HTTP client
├── providers/
│   └── calculator_provider.dart # State management
├── screens/
│   ├── home_screen.dart        # Home with menu
│   ├── calculator_screen.dart  # Main calculator
│   └── package_detail_screen.dart # Content display
└── widgets/
    ├── umrah_dropdown.dart     # Menu dropdown
    ├── traveler_counter.dart   # Traveler selector
    ├── hotel_selector.dart     # Hotel picker
    ├── date_range_picker.dart  # Date selector
    ├── room_selector.dart      # Room counter
    ├── price_breakdown.dart    # Price display
    ├── loading_dialog.dart     # Loading indicator
    └── error_dialog.dart       # Error display
```

---

## 🔌 API Contract

### Menu Endpoint
```
GET /api/umrah/calculator/menu/

Response:
{
  "parent": {"id": 2, "title": "Umrah", "url": "/umrah"},
  "items": [
    {"id": 0, "title": "Calculator", "url": "/Umrhbookingdyn", "type": "calculator"},
    {"id": 15, "title": "Economy", "url": "/umrah-packages/economy", "type": "content"},
    ... 6 more items
  ]
}
```

### Calculator Init Endpoint
```
GET /api/umrah/calculator/init/

Response:
{
  "hotels": {
    "makkah": [Hotel, Hotel, ...],
    "madinah": [Hotel, Hotel, ...]
  },
  "transport": {
    "sectors": [Sector, ...],
    "vehicles": [Vehicle, ...],
    "prices": [VehiclePrice, ...]
  },
  "visas": [VisaOption, ...],
  "currencies": [CurrencyData, ...]
}
```

### Calculate Endpoint
```
POST /api/umrah/calculator/calculate/

Request:
{
  "travelers": {"adults": 2, "children": 1, "infants": 0},
  "hotels": [...],
  "transport": {"enabled": true, "sector_id": 1, "vehicle_id": 2},
  "visa": {"enabled": true, "nationality": "Pakistan"},
  "flight": {"enabled": true, "currency": "USD", ...}
}

Response:
{
  "breakdown": {...},
  "totals": {"sar": 19325, "usd": 6940, "gbp": 5521, ...},
  "summary": {...}
}
```

### Book Endpoint
```
POST /api/umrah/calculator/book/

Request: (Same as calculate + customer info)
{
  "customer": {"first_name": "Ahmed", "email": "ahmed@example.com", "mobile": "+923001234567"},
  "city_id": 5,
  ... (same as calculate request)
}

Response:
{
  "success": true,
  "booking_id": 1523,
  "customer_id": 8745,
  "totals": {...},
  "quotation": {
    "html": "<div>...</div>",
    "text": "...",
    "whatsapp_link": "https://api.whatsapp.com/send?...",
    "whatsapp_link_custom": "..."
  }
}
```

---

## 💡 Key Implementation Details

### Pricing Logic

**Weekend Days**
- Thursday & Friday are weekends
- Different rates for weekend vs weekday rooms

**Currency Conversion**
- All prices stored in SAR (Saudi Riyal)
- Conversion path: USD → PKR → SAR
  ```
  PKR = USD * Currency.rate(USD)
  SAR = PKR / Currency.rate(SAR)
  ```

**Vehicle Special Case**
- Vehicle ID 5 = 50 SAR per person (adults + children)
- Regular vehicles = Fixed price for entire group

**Ramadan Pricing**
- ashraType = '1' means special Ramadan period
- Uses flat rate, ignores weekday/weekend split

### Validation Rules
- Minimum 1 traveler (adult or child)
- Maximum 3 hotels
- If transport enabled, sector & vehicle required
- Check-in < check-out dates

### Phone Number Format
- Always stored/displayed as +92XXXXXXXXX
- Input normalization in utils.normalize_phone()

---

## 🧪 Testing Scenarios

### Test Case 1: Simple Package
- 2 adults
- 1 hotel (Makkah, 5 nights)
- No transport, no visa, no flight
- Expected: Hotel price only

### Test Case 2: Full Package
- 2 adults, 1 child, 1 infant
- 2 hotels (Makkah 10 nights, Madinah 5 nights)
- Transport enabled
- Visa enabled
- Flight enabled (USD prices)
- Expected: Complete breakdown in 3 currencies

### Test Case 3: Period Overlap
- Multiple pricing periods for same hotel
- Booking dates span multiple periods
- Expected: Correct allocation per period

### Test Case 4: Currency Conversion
- Flight prices in USD
- Verify conversion to SAR and GBP
- Expected: Consistent rates

---

## 🐛 Debugging Tips

### Backend Debugging
```python
# In services.py, add logging
import logging
logger = logging.getLogger(__name__)

logger.info(f"Calculating hotels: {request_data}")
logger.debug(f"Found {len(hotel_results)} hotels")
```

### Flutter Debugging
```dart
// In any service/provider
print('API Request: ${request.toJson()}');
print('API Response: ${response.toJson()}');

// State changes
debugPrint('Calculator state changed: $priceBreakdown');
```

### Common Issues

**Issue**: Price doesn't match expected
**Solution**: Check weekday/weekend logic - Thu/Fri are 4-5 (0-indexed)

**Issue**: Currency conversion wrong
**Solution**: Verify rates in database - check Currency table

**Issue**: Hotel not found
**Solution**: Check hotelLocation is exactly 'Makkah' or 'Madinah'

**Issue**: Flutter models not generating
**Solution**: Run `flutter pub run build_runner build --delete-conflicting-outputs`

---

## 📊 Database Queries (Reference)

### Get active hotels in Makkah
```sql
SELECT * FROM umrah_hotels
WHERE hotellocation='Makkah' AND hotelstatus='1'
ORDER BY hotelname;
```

### Get pricing for hotel between dates
```sql
SELECT
  hp.roomtype,
  hp.ondaymarkup,
  hp.offdaymarkup,
  hrp.periodfrom,
  hrp.periodto,
  hrp.ashratype
FROM umrah_hotel_room_periods hrp
JOIN umrah_hotel_room_prices hp ON hp.periodid = hrp.id
WHERE hrp.hotelid = ?
  AND hrp.periodstatus = '1'
  AND (hrp.periodfrom <= ? AND hrp.periodto >= ?)
ORDER BY hrp.periodfrom;
```

### Get visa price by nationality
```sql
SELECT * FROM umrah_visas
WHERE umrahvisanationality = ?
  AND umrahvisapricestatus = '1'
  AND umrahvisaperiodfrom <= ?
  AND umrahvisaperiodto >= ?;
```

---

## 📚 Resources

- **Flutter**: https://flutter.dev/docs
- **Provider**: https://pub.dev/packages/provider
- **Dio**: https://pub.dev/packages/dio
- **Django**: https://www.djangoproject.com/
- **DRF**: https://www.django-rest-framework.org/

---

**Document Version**: 1.0
**Last Updated**: 2026-04-12
**Maintainer**: Development Team
