# Flutter Integration Testing Guide

**Version**: 1.0
**Date**: 2026-04-12
**Status**: Ready for Testing

---

## 🚀 Quick Start for Testing

### Prerequisites

1. **Backend Running**
   ```bash
   cd backen-alrehman/
   python manage.py runserver
   ```
   - Backend should be running on `http://localhost:8000`
   - Access API Swagger: `http://localhost:8000/swagger/`

2. **Flutter Development Environment**
   - Flutter SDK installed
   - Android Studio or Xcode
   - Device/Emulator available

3. **Dependencies Installed**
   ```bash
   cd rehman_travels_mobile/
   flutter pub get
   ```

### Step 1: Generate Models

**IMPORTANT**: Must be done before running the app!

```bash
cd rehman_travels_mobile/
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the `.g.dart` files needed for JSON serialization.

### Step 2: Update API Configuration (If Needed)

Edit `lib/config/api_config.dart`:

```dart
static const String baseUrl = 'http://YOUR_IP:8000/api/umrah';
```

**For local testing on emulator/device:**
- Replace `localhost` with your machine's IP address
- Example: `http://192.168.1.100:8000/api/umrah`

### Step 3: Run the App

```bash
flutter run
```

Or with specific device:
```bash
flutter run -d <device-id>
```

---

## 📱 Testing Scenarios

### Scenario 1: Home Screen Navigation

**Steps:**
1. App launches and shows HomeScreen
2. Tap dropdown menu labeled "Umrah"
3. Verify 8 menu items appear:
   - Umrah Package Calculator
   - Customized Umrah packages From Pakistan
   - Economy Umrah Packages
   - Executive Umrah Packages
   - Umrah e Visa From Pakistan
   - Best Umrah Packages
   - Ramzan Umrah Packages
   - 15 Days Umrah Packages From Pakistan
4. Select "Umrah Package Calculator"
5. Verify CalculatorScreen opens

**Expected Result:** ✅ Navigation works smoothly, all items visible and clickable

---

### Scenario 2: Calculator Screen - Traveler Selection

**Steps:**
1. Navigate to CalculatorScreen
2. Verify initial state: Adults=2, Children=0, Infants=0
3. Click + button for Children, increment to 2
4. Verify total shows 4 travelers
5. Click - button for Adults, decrement to 1
6. Verify total shows 3 travelers
7. Try to decrement Adults below 1 (should not allow)

**Expected Result:** ✅ Traveler counts update correctly, constraints enforced

---

### Scenario 3: Calculator Screen - Hotel Selection

**Steps:**
1. Scroll to Hotels section
2. Click "Add Hotel" button
3. Verify hotel selection dialog appears
4. Select "Makkah 3 Star Hotel"
5. Click "Add"
6. Verify hotel appears in list with location
7. Click Add Hotel again
8. Select different hotel
9. Click Add
10. Verify both hotels in list
11. Add third hotel
12. Try adding 4th hotel
13. Verify "Maximum 3 hotels" message

**Expected Result:** ✅ Can add up to 3 hotels, constraint enforced, dialog works

---

### Scenario 4: Calculator Screen - Date Selection

**Steps:**
1. In first hotel, tap date picker
2. Select check-in: 15 days from today
3. Verify date appears in field
4. Tap check-out date
5. Select check-out: 20 days from today
6. Verify dates appear and "5 nights" shows
7. Try selecting check-out before check-in (should prevent)

**Expected Result:** ✅ Date picker works, validation enforced, nights calculated

---

### Scenario 5: Calculator Screen - Room Selection

**Steps:**
1. For first hotel, expand room selector if visible
2. Add 2 Double rooms
3. Add 1 Triple room
4. Verify total shows "3 rooms"
5. Decrement Triple to 0
6. Verify total shows "2 rooms"

**Expected Result:** ✅ Room selection works, total calculated correctly

---

### Scenario 6: Calculator Screen - Transport Options

**Steps:**
1. Scroll to Transport section
2. Toggle transport OFF → verify controls disabled
3. Toggle transport ON
4. Verify Sector dropdown appears
5. Select "Airport Transfer"
6. Verify Vehicle dropdown appears
7. Select a vehicle
8. Verify both selections persist

**Expected Result:** ✅ Transport toggle works, dropdowns show/hide correctly

---

### Scenario 7: Calculator Screen - Visa Options

**Steps:**
1. Scroll to Visa section
2. Toggle visa OFF → verify controls disabled
3. Toggle visa ON
4. Verify nationality dropdown shows "Pakistan"
5. Select "Other"
6. Verify selection persists

**Expected Result:** ✅ Visa toggle works, nationality selector functional

---

### Scenario 8: Calculator Screen - Flight Details

**Steps:**
1. Scroll to Flight section
2. Toggle flight OFF → verify controls disabled
3. Toggle flight ON
4. Verify currency shows "USD"
5. Enter Adult Price: 500
6. Enter Child Price: 400
7. Enter Infant Price: 200
8. Verify all values persist

**Expected Result:** ✅ Flight toggle works, price inputs accept values

---

### Scenario 9: Calculator Screen - Price Calculation

**Setup:**
- 2 Adults
- 1 Hotel (Makkah, 5 nights, 1 Double room)
- No transport, no visa, no flight

**Steps:**
1. Complete minimal setup above
2. Scroll to "Calculate Price" button
3. Click button
4. Observe loading indicator
5. Wait for API response
6. Verify price breakdown appears below button
7. Check price in SAR, USD, GBP displayed
8. Verify "Without Flight" section if flight was included

**Expected Result:** ✅ API call succeeds, prices display correctly, currency conversions accurate

**Verification:**
- Compare SAR, USD, GBP prices
- Check formula: USD × 277 (approx PKR rate) ÷ 3.65 (approx SAR rate) = SAR

---

### Scenario 10: Calculator Screen - Booking Creation

**Setup:**
- Complete calculator with valid data
- Price breakdown displayed

**Steps:**
1. Click "Create Booking" button
2. Customer info dialog appears
3. Enter:
   - First Name: "Ahmed Ali"
   - Email: "ahmed@example.com"
   - Mobile: "+923001234567"
4. Click "Proceed"
5. Observe loading dialog
6. Wait for API response
7. Verify success dialog shows:
   - Check mark icon
   - "Booking Created!" title
   - Booking ID number
8. Click "Done"
9. Verify returns to home or calculator

**Expected Result:** ✅ Booking created successfully, booking ID returned, proper flow

---

### Scenario 11: Package Detail Screen

**Steps:**
1. From home screen, tap dropdown
2. Select "Economy Umrah Packages"
3. PackageDetailScreen loads
4. Verify banner image displays (or placeholder icon)
5. Verify package title visible
6. Verify price displays (e.g., "Starting from ﷼ 85000")
7. Scroll down to see content
8. Verify markdown/HTML content renders
9. Check "What's Included" section
10. Check "What's Not Included" section
11. Verify "Book This Package" button
12. Click button → navigates to CalculatorScreen

**Expected Result:** ✅ Page loads, content displays, navigation works

---

### Scenario 12: Error Handling

**Test API Error:**
1. Stop Django backend server
2. Try to calculate price or load package
3. Verify error dialog appears
4. Check error message is user-friendly
5. Click "Retry" button
6. Verify retry attempt
7. Start backend server again
8. Click "Retry" → should succeed

**Expected Result:** ✅ Errors handled gracefully, retry functionality works

---

### Scenario 13: Loading States

**Steps:**
1. From CalculatorScreen, click "Calculate Price"
2. Observe loading button (spinner instead of text)
3. Button should be disabled
4. Wait for response
5. Verify button returns to normal

**Expected Result:** ✅ Loading states prevent duplicate submissions, user feedback clear

---

### Scenario 14: Validation

**Steps:**
1. Try to calculate with no travelers
2. Verify error message appears
3. Try to calculate with no hotels
4. Verify error message appears
5. Enable transport but don't select vehicle
6. Try to calculate
7. Verify error message about missing vehicle

**Expected Result:** ✅ Validation prevents invalid submissions, messages clear

---

## 🐛 Debugging Tips

### Check Network Requests

```bash
# In another terminal, monitor HTTP traffic
curl -v http://localhost:8000/api/umrah/calculator/menu/
```

### Debug Flutter Console

```bash
# Run with verbose logging
flutter run -v

# Monitor Dart output
flutter logs
```

### Check Backend Logs

```bash
# Django server console shows all API calls
# Watch for 200 (success) or 400/500 (error) responses
```

### Common Issues

| Issue | Solution |
|-------|----------|
| "Connection refused" | Check backend is running, verify baseUrl in api_config.dart |
| "JSON parse error" | Check backend API response format, regenerate models |
| "Models not generating" | Run `flutter pub run build_runner build --delete-conflicting-outputs` |
| "Hot reload not working" | Run `flutter clean && flutter pub get && flutter run` |
| "Page loads forever" | Check network, check Django logs for errors |

---

## ✅ Testing Checklist

### Functional Testing
- [ ] Home screen navigation menu works (8 items)
- [ ] Navigate to Calculator
- [ ] Navigate to each package type
- [ ] Traveler counter works (all types)
- [ ] Hotel selection works (add/remove/limit)
- [ ] Date picker works correctly
- [ ] Room selector works
- [ ] Transport toggle and selection works
- [ ] Visa toggle and selection works
- [ ] Flight details input works
- [ ] Price calculation works
- [ ] Booking creation works
- [ ] Package detail page loads
- [ ] Error dialogs appear
- [ ] Loading indicators show

### API Integration Testing
- [ ] Menu endpoint called ✓
- [ ] Init endpoint called ✓
- [ ] Calculate endpoint works ✓
- [ ] Book endpoint works ✓
- [ ] Package content endpoint works ✓
- [ ] All responses parsed correctly ✓

### Error Handling Testing
- [ ] Network error shows error dialog ✓
- [ ] Invalid data shows validation error ✓
- [ ] API errors show user-friendly messages ✓
- [ ] Retry button works ✓

### UI/UX Testing
- [ ] All screens render properly ✓
- [ ] Responsive on different screen sizes ✓
- [ ] Loading states prevent double-submission ✓
- [ ] Navigation works smoothly ✓
- [ ] Form dialogs work correctly ✓

### Performance Testing
- [ ] App starts quickly ✓
- [ ] Navigation is smooth ✓
- [ ] Calculations complete in reasonable time ✓
- [ ] No memory leaks ✓

---

## 📊 Test Report Template

```markdown
## Test Date: ___________

### Overall Status: [ ] PASS [ ] FAIL

### Test Results
- Scenario 1: [ ] ✅ [ ] ❌
- Scenario 2: [ ] ✅ [ ] ❌
- Scenario 3: [ ] ✅ [ ] ❌
... (etc)

### Issues Found
1. Issue: ___________
   Severity: [ ] Critical [ ] High [ ] Medium [ ] Low
   Steps to Reproduce: ___________

2. Issue: ___________
   ...

### Notes
___________

### Tested By: ___________
```

---

## 🚀 Deployment Checklist

Before building for production:

- [ ] All tests pass
- [ ] No console errors
- [ ] API configuration set correctly
- [ ] Build succeeds without warnings
- [ ] No hardcoded test data
- [ ] Error messages are user-friendly
- [ ] Performance is acceptable
- [ ] Offline handling works (if applicable)

---

## 📞 Support

If you encounter issues:

1. Check the **Debugging Tips** section above
2. Review **DEVELOPER_GUIDE.md** for architecture
3. Check backend logs for API errors
4. Look at Flutter console for warnings
5. Refer to **FLUTTER_IMPLEMENTATION_GUIDE.md** for component details

---

## 📝 Next Steps After Testing

1. **Fix Any Bugs** found during testing
2. **Optimize Performance** if needed
3. **Polish UI** based on testing feedback
4. **Build Release Version**:
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```
5. **Deploy to Stores**

---

**Happy Testing! 🎉**

For questions or issues, refer to the implementation documentation files.

