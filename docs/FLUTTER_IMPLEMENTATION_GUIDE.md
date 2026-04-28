# Flutter App Implementation Guide - Phase 2

## Status: 70% Complete ✅

### Completed Components

1. ✅ **pubspec.yaml** - All dependencies configured
2. ✅ **main.dart** - App entry point with routing
3. ✅ **lib/config/app_theme.dart** - Material Design theme
4. ✅ **lib/config/api_config.dart** - API configuration
5. ✅ **lib/models/menu_models.dart** - Menu data models
6. ✅ **lib/models/calculator_models.dart** - Calculator request models
7. ✅ **lib/models/price_models.dart** - Price response models
8. ✅ **lib/services/umrah_api_service.dart** - API client
9. ✅ **lib/providers/calculator_provider.dart** - State management

### Remaining Components (Ready to Code)

#### Screens to Create

1. **lib/screens/home_screen.dart**
   - Navigation with hardcoded dropdown menu (8 items)
   - Display Umrah logo and menu
   - Route to Calculator and Package Details

2. **lib/screens/calculator_screen.dart**
   - Main calculator interface
   - Traveler counter section
   - Hotel selection (max 3)
   - Transport options toggle
   - Visa toggle
   - Flight details section
   - Calculate button
   - Price breakdown display

3. **lib/screens/package_detail_screen.dart**
   - Fetch package by slug
   - Display banner image
   - Show title and price
   - Render markdown content
   - Show includes/excludes
   - "Book Package" button

#### Widgets to Create

1. **lib/widgets/umrah_dropdown.dart**
   - Hardcoded menu with 8 items
   - Navigation on selection

2. **lib/widgets/traveler_counter_widget.dart**
   - Adults, Children, Infants counters
   - +/- buttons for each
   - Total count display

3. **lib/widgets/hotel_selector_widget.dart**
   - List of selected hotels
   - Add hotel button (max 3)
   - Remove hotel button for each
   - Shows hotel name, dates, rooms

4. **lib/widgets/date_range_picker_widget.dart**
   - Check-in date picker
   - Check-out date picker
   - Validate dates

5. **lib/widgets/room_selector_widget.dart**
   - Room type selector (Double, Triple, Quad, Quint)
   - Counter for each type
   - Total rooms display

6. **lib/widgets/price_breakdown_card.dart**
   - Display price breakdown
   - Hotels section
   - Transport section
   - Visa section
   - Flight section
   - Total prices (SAR, USD, GBP)
   - Without flight totals

7. **lib/widgets/loading_dialog.dart**
   - Loading spinner
   - Message display

8. **lib/widgets/error_dialog.dart**
   - Error message display
   - Retry button

#### Models Generation

Run these commands after completing model files:
```bash
cd rehman_travels_mobile
flutter pub run build_runner build
```

This generates `*.g.dart` files for json_serializable.

---

## Implementation Order

### Step 1: Generate Models (Required First)
```bash
flutter pub get
flutter pub run build_runner build
```

### Step 2: Create Widgets (Reusable Components)
1. TravelerCounterWidget
2. HotelSelectorWidget
3. DateRangePickerWidget
4. RoomSelectorWidget
5. PriceBreakdownCard
6. UmrahDropdownWidget
7. LoadingDialog
8. ErrorDialog

### Step 3: Create Screens
1. HomeScreen (with dropdown navigation)
2. CalculatorScreen (main logic)
3. PackageDetailScreen (content display)

### Step 4: Connect Everything
1. Update routing in main.dart
2. Test all navigation flows
3. Test API integration

---

## Key Implementation Notes

### Hardcoded Navigation Menu (8 Items)

```dart
final List<MenuItem> menuItems = [
  MenuItem(
    id: 0,
    title: 'Umrah Package Calculator',
    url: '/calculator',
    type: 'calculator',
  ),
  MenuItem(
    id: 1,
    title: 'Customized Umrah packages From Pakistan',
    url: '/package/customized-umrah-packages-from-pakistan',
    type: 'content',
  ),
  MenuItem(
    id: 2,
    title: 'Economy Umrah Packages',
    url: '/package/economy',
    type: 'content',
  ),
  MenuItem(
    id: 3,
    title: 'Executive Umrah Packages',
    url: '/package/executive',
    type: 'content',
  ),
  MenuItem(
    id: 4,
    title: 'Umrah e Visa From Pakistan',
    url: '/package/umrah-e-visa',
    type: 'content',
  ),
  MenuItem(
    id: 5,
    title: 'Best Umrah Packages',
    url: '/package/best-umrah-packages',
    type: 'content',
  ),
  MenuItem(
    id: 6,
    title: 'Ramzan Umrah Packages',
    url: '/package/ramzan-umrah-packages',
    type: 'content',
  ),
  MenuItem(
    id: 7,
    title: '15 Days Umrah Packages From Pakistan',
    url: '/package/15-days-umrah-packages-from-pakistan',
    type: 'content',
  ),
];
```

### API Integration Pattern

```dart
// In any widget
final provider = Provider.of<CalculatorProvider>(context, listen: false);

// Initialize data
await provider.initialize();

// Calculate price
await provider.calculatePrice();

// Create booking
final bookingResponse = await provider.createBooking(
  firstName: 'Ahmed',
  email: 'ahmed@example.com',
  mobile: '+923001234567',
);

if (bookingResponse != null) {
  // Success - show quotation
  // Access bookingResponse.quotation.html or .text
  // Use bookingResponse.quotation.whatsappLink for sharing
}
```

### Date Format
Always use `YYYY-MM-DD` format for dates when communicating with API.

```dart
final dateString = DateTime(2024, 6, 15).toString().split(' ')[0]; // "2024-06-15"
```

### Room Selection Pattern

```dart
Map<String, int> rooms = {
  'Double': 1,
  'Triple': 1,
  'Quad': 0,
  'Quint': 0,
};

int totalRooms = rooms.values.fold(0, (sum, val) => sum + val);
```

### Currency Display

```dart
String formatCurrency(double amount, String currency) {
  const symbols = {
    'SAR': '﷼',
    'USD': '\$',
    'GBP': '£',
    'PKR': 'Rs.',
  };

  final symbol = symbols[currency] ?? currency;
  return '$symbol ${amount.toStringAsFixed(2)}';
}
```

---

## Testing Checklist

### Backend Tests (Before Flutter)
- [ ] Run Django server: `python manage.py runserver`
- [ ] Test menu endpoint: `GET /api/umrah/calculator/menu/`
- [ ] Test init endpoint: `GET /api/umrah/calculator/init/`
- [ ] Test calculate endpoint: `POST /api/umrah/calculator/calculate/`
- [ ] Test booking endpoint: `POST /api/umrah/calculator/book/`
- [ ] Check Swagger UI: `http://localhost:8000/swagger/`

### Flutter Tests
- [ ] `flutter pub get` - Install dependencies
- [ ] `flutter pub run build_runner build` - Generate models
- [ ] `flutter run` - Start app on emulator/device
- [ ] Test navigation between screens
- [ ] Test dropdown menu (8 items)
- [ ] Test calculator flow (add hotels, travelers, etc.)
- [ ] Test price calculation
- [ ] Test booking creation
- [ ] Test WhatsApp link generation
- [ ] Test package detail screen rendering

---

## Common Issues & Solutions

### Issue: Models not generating (.g.dart files)
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: API connection refused
**Solution:** Check ApiConfig.baseUrl matches your backend URL
```dart
static const String baseUrl = 'http://YOUR_BACKEND_IP:8000/api/umrah';
```

### Issue: JSON deserialization errors
**Solution:** Use json_serializable properly:
1. Annotate class with `@JsonSerializable()`
2. Add `part 'filename.g.dart';`
3. Implement `fromJson()` factory
4. Implement `toJson()` method
5. Run code generator

### Issue: Hot reload not working
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## File Structure Reference

```
rehman_travels_mobile/
├── lib/
│   ├── main.dart                          ✅
│   ├── config/
│   │   ├── app_theme.dart                 ✅
│   │   └── api_config.dart                ✅
│   ├── models/
│   │   ├── menu_models.dart               ✅
│   │   ├── calculator_models.dart         ✅
│   │   └── price_models.dart              ✅
│   ├── services/
│   │   └── umrah_api_service.dart         ✅
│   ├── providers/
│   │   └── calculator_provider.dart       ✅
│   ├── screens/
│   │   ├── home_screen.dart               ⏳ TODO
│   │   ├── calculator_screen.dart         ⏳ TODO
│   │   └── package_detail_screen.dart     ⏳ TODO
│   └── widgets/
│       ├── umrah_dropdown.dart            ⏳ TODO
│       ├── traveler_counter_widget.dart   ⏳ TODO
│       ├── hotel_selector_widget.dart     ⏳ TODO
│       ├── date_range_picker_widget.dart  ⏳ TODO
│       ├── room_selector_widget.dart      ⏳ TODO
│       ├── price_breakdown_card.dart      ⏳ TODO
│       ├── loading_dialog.dart            ⏳ TODO
│       └── error_dialog.dart              ⏳ TODO
├── assets/
│   ├── images/
│   ├── icons/
│   └── flags/
├── pubspec.yaml                           ✅
└── pubspec.lock                           (auto-generated)
```

---

## Next Steps

1. **Generate Models**
   ```bash
   flutter pub run build_runner build
   ```

2. **Create Widgets** (Start with simpler ones first)
   - LoadingDialog (simplest)
   - ErrorDialog
   - TravelerCounterWidget
   - RoomSelectorWidget
   - HotelSelectorWidget

3. **Create Screens**
   - HomeScreen (with dropdown)
   - CalculatorScreen (complex logic)
   - PackageDetailScreen

4. **Integration Testing**
   - Connect to backend
   - Test end-to-end flows

5. **Polish & Deploy**
   - UI/UX improvements
   - Error handling refinement
   - Performance optimization

---

## Key Dependencies

- **provider**: State management (already configured)
- **dio**: HTTP client for API calls
- **json_annotation**: JSON serialization
- **flutter_html**: Render HTML content
- **flutter_markdown**: Render Markdown content
- **intl**: Date/time formatting
- **url_launcher**: Open WhatsApp links

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Dio Documentation](https://pub.dev/packages/dio)
- [json_serializable](https://pub.dev/packages/json_serializable)

---

**Status**: Core infrastructure complete, ready for screen development
**Estimated Time**: 4-6 hours for all screens and widgets
**Difficulty**: Medium (mostly UI implementation, API already abstracted)
