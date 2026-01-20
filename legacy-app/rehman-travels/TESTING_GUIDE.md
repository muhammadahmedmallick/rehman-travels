# Chunked Flight Search - Testing Guide

## Quick Test Steps

### 1. Basic Functionality Test

1. **Start the application**:
   ```bash
   php artisan serve
   npm run dev
   ```

2. **Clear cache** (important!):
   ```bash
   php artisan cache:clear
   ```

3. **Navigate to flight search**:
   - Go to: `http://localhost:8000/ticketing/cheapest-fare-flight`
   - Or: `https://www.rehmantravel.com/ticketing/cheapest-fare-flight`

4. **Perform a search**:
   - Origin: ISB (Islamabad)
   - Destination: KHI (Karachi)
   - Date: Select any future date
   - Click "Search"

5. **Observe the behavior**:
   - ✅ Should see "Searching 1/3 providers..." message
   - ✅ Progress should update to "2/3", then "3/3"
   - ✅ Results should appear progressively as providers respond
   - ✅ No multiple network calls in browser DevTools (only 1 initial + polls)

### 2. Network Testing

Open **Browser DevTools** (F12) → **Network Tab**:

**Expected Behavior**:
```
POST /ticketing/chunked-flight-search  (1st request - searchId: null)
POST /ticketing/chunked-flight-search  (2nd poll - with searchId)
POST /ticketing/chunked-flight-search  (3rd poll - with searchId)
POST /ticketing/chunked-flight-search  (4th poll - fetchMore: false)
```

**Old Behavior** (if reverted):
```
POST /ticketing/cheapest-fare-airshopping-request  (action-type: Sabre)
POST /ticketing/cheapest-fare-airshopping-request  (action-type: AirSial)
POST /ticketing/cheapest-fare-airshopping-request  (action-type: Airblue)
```

### 3. Cache Verification

**Check if cache is working**:
```bash
php artisan tinker
```

Then run:
```php
// During an active search, check cache
Cache::get('flight_search_YOUR_SEARCH_ID');

// You should see:
// [
//   "searchId" => "search_...",
//   "providers" => [...],
//   "pendingProviders" => [...],
//   "results" => [...]
// ]
```

### 4. Response Structure Test

**Inspect API Response** in DevTools → Network → Response:

**First Request**:
```json
{
  "searchId": "search_67a1b2c3d4e5f",
  "fetchMore": true,
  "data": [
    {
      "provider": "Sabre",
      "data": { /* flight data */ }
    }
  ],
  "totalProviders": 3,
  "processedCount": 1,
  "remainingCount": 2,
  "latestProvider": "Sabre",
  "latestResult": { /* ... */ }
}
```

**Subsequent Polls**:
- `fetchMore` should be `true` until last provider
- `processedCount` should increment
- `remainingCount` should decrement
- New results should appear in `latestResult`

**Final Response**:
```json
{
  "searchId": "search_67a1b2c3d4e5f",
  "fetchMore": false,  // ← Should be false
  "data": [ /* all 3 provider results */ ],
  "totalProviders": 3,
  "processedCount": 3,
  "remainingCount": 0
}
```

## Console Testing

### Manual API Test

Use `curl` or Postman to test the endpoint directly:

```bash
# First Request
curl -X POST 'http://localhost:8000/ticketing/chunked-flight-search' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRF-TOKEN: YOUR_CSRF_TOKEN' \
  -d '{
    "departureCode": "ISB",
    "arrivalCode": "KHI",
    "outboundDate": "31-01-2026",
    "inboundDate": "05-02-2026",
    "cabin": "Y",
    "adultsCount": 1,
    "childrenCount": 0,
    "infantsCount": 0,
    "tripType": "round-trip",
    "locale": "ar",
    "providers": "Sabre,AirSial,Airblue"
  }'

# Copy the searchId from response, then poll:
curl -X POST 'http://localhost:8000/ticketing/chunked-flight-search' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRF-TOKEN: YOUR_CSRF_TOKEN' \
  -d '{
    "departureCode": "ISB",
    "arrivalCode": "KHI",
    "outboundDate": "31-01-2026",
    "inboundDate": "05-02-2026",
    "cabin": "Y",
    "adultsCount": 1,
    "childrenCount": 0,
    "infantsCount": 0,
    "tripType": "round-trip",
    "locale": "ar",
    "providers": "Sabre,AirSial,Airblue",
    "searchId": "search_67a1b2c3d4e5f"
  }'
```

## Edge Cases to Test

### 1. No Providers Available
**Test**: Remove all providers from database
**Expected**: Error message "No providers available"

### 2. Single Provider
**Test**: Set providers to just "Sabre"
**Expected**:
- First request: `fetchMore: false` (only 1 provider)
- Results shown immediately

### 3. Provider Timeout
**Test**: Simulate slow external API
**Expected**:
- Request should wait for provider
- Other providers should still be queried
- Error logged but search continues

### 4. All Providers Fail
**Test**: Disconnect from external API
**Expected**: "No flights are available..." message

### 5. Cache Expiration
**Test**:
1. Start a search
2. Wait 5+ minutes
3. Try to poll with old searchId

**Expected**: Error "Search session expired or not found"

### 6. Concurrent Searches
**Test**: Open 2 browser tabs, search simultaneously
**Expected**:
- Each gets unique searchId
- Results don't mix between searches

## Debugging

### Enable Detailed Logging

Add to `ChunkedFlightSearchController.php`:
```php
\Log::info('Flight search request', [
    'searchId' => $searchId,
    'provider' => $nextProvider,
    'remainingProviders' => $searchState['pendingProviders']
]);
```

Then check logs:
```bash
tail -f storage/logs/laravel.log
```

### Frontend Console Logging

Add to `airShoppingChunked()`:
```javascript
console.log('Poll response:', result);
console.log('Search ID:', searchId);
console.log('Fetch more?', result.fetchMore);
```

## Performance Testing

### Measure Response Times

```javascript
// Add to frontend
const startTime = performance.now();

// ... make request ...

const endTime = performance.now();
console.log(`Request took ${endTime - startTime}ms`);
```

### Expected Timings
- Initial request: 2-5 seconds (depends on Sabre API)
- Subsequent polls: 1-3 seconds each
- Total search time: 5-15 seconds (3 providers)

## Rollback Testing

### Switch Back to Old Implementation

1. Edit `CheapestFareFlight.vue:681`:
   ```javascript
   // Comment out new implementation
   // this.airShoppingChunked();

   // Enable old implementation
   this.airShopping();
   ```

2. Refresh browser
3. Verify old behavior:
   - Should see 3 parallel API calls in Network tab
   - Each with different `action-type` header

## Common Issues

### Issue 1: "No providers available"
**Cause**: Providers not loaded from database
**Fix**: Check `PremiumAirline::airlines()` query
**Verify**:
```php
php artisan tinker
>>> \App\Models\PremiumAirline\PremiumAirline::airlines()
```

### Issue 2: Infinite polling
**Cause**: `fetchMore` always true
**Debug**: Check `$searchState['pendingProviders']` array
**Fix**: Ensure providers are removed from pending array after processing

### Issue 3: Duplicate results
**Cause**: Frontend not tracking lastResultCount
**Fix**: Verify `lastCount` parameter is sent in polls

### Issue 4: 500 Error on first request
**Cause**: Cache driver not configured
**Fix**:
```bash
php artisan config:cache
```
Or set `CACHE_DRIVER=file` in `.env`

## Success Criteria

✅ **Pass Criteria**:
- [ ] Only 1 initial API call visible in Network tab
- [ ] Progressive polling requests (3-4 total for 3 providers)
- [ ] Results appear one by one as providers respond
- [ ] Progress message updates: "1/3", "2/3", "3/3"
- [ ] Final message: "The lowest priced fares are displayed at the top"
- [ ] All provider results shown on page
- [ ] No console errors
- [ ] Cache cleans up after completion

❌ **Fail Criteria**:
- Multiple parallel calls to `/cheapest-fare-airshopping-request`
- Infinite polling loop
- Results not appearing
- Cache errors in logs
- Duplicate search results

## Next Steps After Testing

1. **If tests pass**: Deploy to staging environment
2. **If issues found**: Review logs, fix bugs, re-test
3. **Monitor production**: Watch for cache expiration issues
4. **Optimize**: Adjust polling interval based on real-world performance
5. **Consider enhancements**: WebSocket, queue-based processing

## Support

For issues, check:
- `/storage/logs/laravel.log`
- Browser console (F12)
- Network tab in DevTools
- Redis/Cache storage (if using Redis)
