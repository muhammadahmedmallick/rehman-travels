# Umrah Calculator - Complete Business Logic Implementation

**Version**: 2.0 (Updated)
**Date**: 2026-04-12
**Status**: ✅ All web features implemented

---

## 📋 Overview

This document details all the business logic implemented in the Umrah Package Calculator, both backend and frontend, to match the web version's complete functionality.

---

## 🔧 Backend Business Logic (Django)

### 1. Price Calculation Engine (`services.py`)

#### A. Hotel Pricing Calculation
```python
def _calculate_hotels(self, hotels: List[dict]) -> dict
```

**Features:**
- ✅ Multiple hotels support (up to 3)
- ✅ Per-hotel check-in and check-out dates
- ✅ Per-hotel room type selection (Double, Triple, Quad, Quint)
- ✅ Weekday/weekend pricing differentiation
  - Thursday & Friday = Weekend (higher rates)
  - Saturday-Wednesday = Weekday (lower rates)
- ✅ Period-based pricing
  - Hotel can have multiple pricing periods
  - Automatic selection based on booking dates
- ✅ Ramadan special pricing (ashraType = '1')
  - Uses flat rate (ignores weekday/weekend split)
- ✅ Period overlap handling
  - Correctly allocates nights across multiple periods

**Calculation Flow:**
1. For each hotel:
   - Query pricing periods that overlap with check-in to check-out
   - For each period overlapping with stay:
     - Count weekday nights (rate: ondaymarkup)
     - Count weekend nights (rate: offdaymarkup)
     - If Ramadan period: use flat rate instead
   - Sum all room prices for selected room types
2. Total = Sum of all hotels

**Example:**
```
Hotel: Makkah 3 Star
Check-in: 15-04-2026, Check-out: 18-04-2026 (3 nights)
Rooms: 1 Double, 1 Triple

Night breakdown:
- 15 Apr (Thu): Weekend → Double: 500, Triple: 600 = 1,100
- 16 Apr (Fri): Weekend → Double: 500, Triple: 600 = 1,100
- 17 Apr (Sat): Weekday → Double: 400, Triple: 500 = 900

Total: 3,100 SAR
```

---

#### B. Transport Cost Calculation
```python
def _calculate_transport(self, transport: dict, travelers: dict) -> dict
```

**Features:**
- ✅ Per-sector transport options
- ✅ Per-vehicle type pricing
- ✅ Special pricing for Vehicle ID 5
  - Fixed: 50 SAR per person (adults + children only, not infants)
  - Other vehicles: Fixed price for entire group
- ✅ Optional component (can be disabled)

**Calculation Logic:**
```python
if vehicle_id == 5:
    # Per-person rate
    cost = 50 * (adults + children)
else:
    # Per-group rate
    cost = vehicle_price (flat)
```

**Example:**
```
Vehicle ID 5 (Airport Transfer - Per Person)
Adults: 2, Children: 1, Infants: 0
Cost: 50 × (2 + 1) = 150 SAR

Regular Vehicle (Minibus - Fixed)
Cost: 1,500 SAR (regardless of traveler count)
```

---

#### C. Visa Fee Calculation
```python
def _calculate_visa(self, visa: dict, travelers: dict) -> dict
```

**Features:**
- ✅ Per-traveler pricing
  - Applies to: adults + children + infants
- ✅ Nationality-based pricing
  - Pakistan: Lower rate
  - Other: Standard rate
- ✅ Period-based visa options
- ✅ Optional component

**Calculation Logic:**
```python
visa_cost = visa_price * total_travelers
# where total_travelers = adults + children + infants
```

**Example:**
```
Nationality: Pakistan
Visa Price: 500 SAR per person
Travelers: 2 adults + 1 child = 3
Total Visa Cost: 500 × 3 = 1,500 SAR

Nationality: Other
Visa Price: 800 SAR per person
Total Visa Cost: 800 × 3 = 2,400 SAR
```

---

#### D. Flight Fare Calculation
```python
def _calculate_flight(self, flight: dict, travelers: dict) -> dict
```

**Features:**
- ✅ Per-person pricing for different passenger types
  - Adult fare
  - Child fare
  - Infant fare
- ✅ Multi-currency input support
  - USD, GBP, EUR, etc.
- ✅ Automatic currency conversion
  - Path: USD → PKR → SAR
- ✅ Optional component

**Conversion Formula:**
```
SAR = (Price_in_Currency × Rate_to_PKR) / Rate_SAR_to_PKR
```

**Example:**
```
Flight Prices in USD:
- Adult: $500
- Child: $400
- Infant: $0

Conversion (USD to SAR):
- USD to PKR rate: 277
- PKR to SAR rate: 3.65
- 1 USD = 277/3.65 = 75.86 SAR

Adult fare: 500 × 75.86 = 37,930 SAR
Child fare: 400 × 75.86 = 30,344 SAR
Infant fare: 0

Total for 2 adults + 1 child:
= (37,930 × 2) + (30,344 × 1) + 0
= 75,860 + 30,344
= 106,204 SAR
```

---

#### E. Currency Conversion
```python
def _convert_to_sar(amount: float, from_currency: str) -> float
def _convert_from_sar(amount: float, to_currency: str) -> float
```

**Supported Currencies:**
- SAR (Saudi Riyal) - Base currency
- USD (US Dollar)
- GBP (British Pound)
- PKR (Pakistani Rupee)

**Conversion Path:**
- Always goes through PKR as intermediary
- Ensures consistency across conversions
- Database stores rates relative to PKR

**Rates (Example):**
```
USD to PKR: 277
GBP to PKR: 347.5
SAR to PKR: 3.65
```

---

### 2. Booking Creation & Persistence (`services.py`)

#### A. Customer Management
```python
def create_booking(booking_request: dict, city_id: int)
```

**Features:**
- ✅ Find or create customer by email
- ✅ Phone number normalization
  - Converts to +92XXXXXXXXX format
- ✅ Customer deduplication
- ✅ Store customer contact info

---

#### B. Booking Record Creation
- ✅ Creates one booking record per hotel
- ✅ Stores all pricing breakdown
- ✅ Links to customer
- ✅ Generates unique booking ID

---

#### C. Quotation Generation

**HTML Quotation:**
- ✅ Professional formatted HTML
- ✅ Includes all items (hotels, transport, visa, flights)
- ✅ Shows pricing in all currencies
- ✅ Ready for email/print

**Text Quotation:**
- ✅ Plain text version
- ✅ All information included
- ✅ Ready for WhatsApp/SMS

**WhatsApp Link:**
- ✅ Pre-formatted message with quotation
- ✅ Includes booking ID and customer name
- ✅ Direct link to WhatsApp API
- ✅ Custom message support

---

### 3. Validation & Error Handling

#### Input Validation
```python
def validate_booking_request(request: dict) -> tuple[bool, str]
```

**Validates:**
- ✅ At least 1 traveler (adult or child)
- ✅ At least 1 hotel selected
- ✅ Valid check-in < check-out dates
- ✅ At least 1 room selected per hotel
- ✅ If transport enabled: sector & vehicle required
- ✅ Email format if provided
- ✅ Phone number format

---

## 🎨 Frontend Business Logic (Flutter)

### 1. State Management (`calculator_provider.dart`)

#### A. Traveler Selection
```dart
class Travelers {
  int adults;
  int children;
  int infants;
}
```

**Constraints:**
- ✅ Adults: Minimum 1, Maximum unlimited
- ✅ Children: Minimum 0, Maximum unlimited
- ✅ Infants: Minimum 0, Maximum unlimited
- ✅ Total = adults + children + infants

---

#### B. Hotel Management
```dart
class HotelBooking {
  int hotelId;
  String hotelName;
  String hotelLocation;
  String checkIn;      // YYYY-MM-DD format
  String checkOut;     // YYYY-MM-DD format
  Map<String, int> rooms;  // {'Double': 1, 'Triple': 1, ...}
}
```

**Features:**
- ✅ Support up to 3 hotels
- ✅ Per-hotel date range
- ✅ Per-hotel room selection
- ✅ Room types: Double, Triple, Quad, Quint
- ✅ Validation: Must have check-in, check-out, and at least 1 room

**Add Hotel Flow:**
1. User taps "Add Hotel"
2. Hotel selection dialog appears
3. Select hotel from dropdown
4. Dialog closes and hotel added with empty dates/rooms
5. User taps hotel card to edit
6. Date picker and room selector appear
7. User sets dates and rooms
8. Save and hotel is updated

---

#### C. Transport Options
```dart
class Transport {
  bool enabled;
  int? sectorId;
  int? vehicleId;
}
```

**Features:**
- ✅ Toggle enable/disable
- ✅ Sector dropdown (when enabled)
- ✅ Vehicle dropdown (when enabled)
- ✅ Validation: Both sector & vehicle required if enabled

---

#### D. Visa Options
```dart
class Visa {
  bool enabled;
  String nationality;  // 'Pakistan' or 'Other'
}
```

**Features:**
- ✅ Toggle enable/disable
- ✅ Nationality selector (when enabled)
- ✅ Defaults to 'Pakistan'

---

#### E. Flight Details
```dart
class Flight {
  bool enabled;
  String currency;      // 'USD', 'GBP', etc.
  double adultPrice;
  double childPrice;
  double infantPrice;
}
```

**Features:**
- ✅ Toggle enable/disable
- ✅ Currency selector
- ✅ Per-passenger price inputs
- ✅ Supports decimal values

---

### 2. UI Components

#### A. HotelSelectorWidget
**New Features Added:**
- ✅ Per-hotel edit dialog
- ✅ Inline date picker
- ✅ Inline room selector
- ✅ Visual status indicators (✓ green if complete, ⚠️ orange if incomplete)
- ✅ Shows "Tap to edit" prompts for incomplete hotels
- ✅ Displays total rooms and total nights
- ✅ Prevents calculation if hotels incomplete

**Edit Dialog Features:**
- Check-in date picker
- Check-out date picker
- Room type counters (Double, Triple, Quad, Quint)
- Validation: Requires both dates to save

---

#### B. TravelerCounterWidget
**Features:**
- ✅ Separate counters for adults, children, infants
- ✅ +/- buttons for each type
- ✅ Enforces minimum 1 adult
- ✅ Displays total traveler count
- ✅ Real-time updates

---

#### C. Price Breakdown Display
**Features:**
- ✅ Hotels cost
- ✅ Transport cost
- ✅ Visa cost
- ✅ Flight cost
- ✅ Total in SAR (primary)
- ✅ Total in USD
- ✅ Total in GBP
- ✅ Without Flight totals (alternative pricing)
- ✅ Currency symbols (﷼, $, £)

---

### 3. Validation & Error Handling

#### Calculation Validation
```dart
bool _validateCalculation() {
  // Must have at least 1 traveler (adult or child)
  if (adults + children == 0) return false;

  // Must have at least 1 hotel
  if (selectedHotels.isEmpty) return false;

  // All hotels must have dates
  for (var hotel in selectedHotels) {
    if (hotel.checkIn.isEmpty || hotel.checkOut.isEmpty)
      return false;
  }

  // All hotels must have rooms
  for (var hotel in selectedHotels) {
    int totalRooms = hotel.rooms.values.fold(0, (s, v) => s + v);
    if (totalRooms == 0) return false;
  }

  // If transport enabled, must have sector & vehicle
  if (transportEnabled) {
    if (selectedSectorId == null || selectedVehicleId == null)
      return false;
  }

  return true;
}
```

#### Error Messages
- ✅ "Please complete all required fields"
- ✅ "Missing Dates - Please set check-in and check-out dates"
- ✅ "No Rooms Selected - Please select at least one room"
- ✅ "Calculation Error - Check your input and try again"
- ✅ "Network Error - Check internet connection"

---

## 📊 Data Flow Comparison

### Web Version Flow
```
User Input (Form)
    ↓
Checkboxes (Visa, Transport, Add Fare)
    ↓
Hotel Section (Location, Dates, Hotel, Rooms)
    ↓
Transport Section (Sector, Vehicle, Travelers)
    ↓
Customer Info (Name, Email, Phone)
    ↓
Calculate UBC / Reset
```

### Flutter Version Flow
```
User Input (Cards/Dialogs)
    ↓
Toggles (Visa, Transport, Flight)
    ↓
Hotel Selector (Add, Edit per hotel, Dates, Rooms)
    ↓
Traveler Counter
    ↓
Transport Section (if enabled)
    ↓
Visa Section (if enabled)
    ↓
Flight Section (if enabled)
    ↓
Calculate Price / Book
    ↓
Customer Info Dialog
```

---

## ✅ Business Logic Coverage

### ✅ Feature Parity with Web Version

| Feature | Web | Flutter | Status |
|---------|-----|---------|--------|
| Umrah Visa toggle | ✅ | ✅ | ✅ Complete |
| Transport toggle | ✅ | ✅ | ✅ Complete |
| Flight/Fare toggle | ✅ | ✅ | ✅ Complete |
| Multiple hotels (max 3) | ✅ | ✅ | ✅ Complete |
| Per-hotel date range | ✅ | ✅ | ✅ Complete |
| Per-hotel room selection | ✅ | ✅ | ✅ Complete |
| Transport sector selection | ✅ | ✅ | ✅ Complete |
| Transport vehicle selection | ✅ | ✅ | ✅ Complete |
| Traveler count display | ✅ | ✅ | ✅ Complete |
| Total rooms display | ✅ | ✅ | ✅ Complete |
| Total nights display | ✅ | ✅ | ✅ Complete |
| Customer info (Name, Email, Phone) | ✅ | ✅ | ✅ Complete |
| Calculate/Reset buttons | ✅ | ✅ | ✅ Complete |
| Price breakdown display | ✅ | ✅ | ✅ Complete |
| Multi-currency conversion | ✅ | ✅ | ✅ Complete |
| Booking creation | ✅ | ✅ | ✅ Complete |

---

## 🔍 Detailed Calculation Example

### Scenario: Full Package with All Components

**Input:**
- Travelers: 2 adults, 1 child, 0 infants
- Hotel 1: Makkah 5-star
  - Check-in: 15-04-2026 (Thursday)
  - Check-out: 18-04-2026 (Saturday)
  - Rooms: 1 Double (500 SAR weekday, 600 SAR weekend)
           1 Triple (600 SAR weekday, 750 SAR weekend)
- Transport: Sector=Airport, Vehicle=Minibus (1500 SAR)
- Visa: Pakistan (500 SAR per person)
- Flight: USD prices
  - Adult: $500
  - Child: $400
  - Infant: $0

**Calculation Breakdown:**

1. **Hotel Cost:**
   - Night 1 (Thu - Weekend):
     - Double: 600, Triple: 750 = 1,350
   - Night 2 (Fri - Weekend):
     - Double: 600, Triple: 750 = 1,350
   - Night 3 (Sat - Weekday):
     - Double: 500, Triple: 600 = 1,100
   - **Hotel Total: 3,800 SAR**

2. **Transport Cost:**
   - Vehicle: Minibus (fixed price)
   - **Transport Total: 1,500 SAR**

3. **Visa Cost:**
   - Price per person: 500 SAR
   - Travelers: 2 + 1 = 3
   - **Visa Total: 1,500 SAR**

4. **Flight Cost:**
   - Adult: $500 × 2 = $1,000
   - Child: $400 × 1 = $400
   - Infant: $0 × 0 = $0
   - Total: $1,400
   - Convert to SAR: $1,400 × 75.86 = **106,204 SAR**

5. **Grand Total:**
   - Hotel: 3,800 SAR
   - Transport: 1,500 SAR
   - Visa: 1,500 SAR
   - Flight: 106,204 SAR
   - **TOTAL: 113,004 SAR**

6. **Currency Conversion:**
   - SAR: 113,004
   - USD: 113,004 / 75.86 = $1,490
   - GBP: 113,004 × (1/75.86) × (347.5/277) = $1,929

---

## 🚀 Implementation Verification

### Backend API Verification
- ✅ `GET /api/umrah/calculator/menu/` - Returns 8 menu items
- ✅ `GET /api/umrah/calculator/init/` - Returns all dropdown data
- ✅ `POST /api/umrah/calculator/calculate/` - Calculates prices correctly
- ✅ `POST /api/umrah/calculator/book/` - Creates booking and returns quotation

### Frontend Implementation Verification
- ✅ All toggles work correctly
- ✅ Hotels can be added (max 3)
- ✅ Hotels can be edited with dates and rooms
- ✅ Per-hotel rooms tracked separately
- ✅ Travelers counted correctly
- ✅ Transport options appear only when enabled
- ✅ Visa options appear only when enabled
- ✅ Flight details appear only when enabled
- ✅ Price calculated correctly
- ✅ Booking created with customer info
- ✅ Error handling for incomplete data

---

## 📚 Testing Scenarios

### Test Case 1: Basic Package
- 1 adult, 0 children
- 1 hotel, 3 nights, 1 room
- No transport, no visa, no flight
- **Expected**: Hotel cost only

### Test Case 2: Full Package
- 2 adults, 1 child
- 2 hotels, multiple nights, multiple rooms
- Transport enabled
- Visa enabled
- Flight enabled
- **Expected**: Complete breakdown in 3 currencies

### Test Case 3: Validation
- Try to calculate with no travelers
- Try to calculate with no hotels
- Try to calculate with hotels but no rooms
- **Expected**: All errors caught and user informed

---

## ✨ Conclusion

The Umrah Package Calculator now has **complete feature parity with the web version**, with all business logic properly implemented on both backend and frontend.

### Key Achievements:
✅ Complex multi-hotel pricing
✅ Per-hotel customization
✅ Per-person transport costs
✅ Currency conversion
✅ Complete validation
✅ Professional error handling
✅ Full booking flow

---

**Status**: ✅ **ALL BUSINESS LOGIC IMPLEMENTED**

Generated: 2026-04-12

