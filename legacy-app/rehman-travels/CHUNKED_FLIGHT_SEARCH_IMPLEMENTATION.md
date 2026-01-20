# Chunked Flight Search Implementation Guide

## Overview
This document explains the new chunked flight search implementation that replaces multiple parallel API calls from the frontend with a single API call and backend-managed provider polling.

## What Changed?

### Previous Implementation
- **Frontend**: Made multiple parallel API calls (one per provider: Sabre, AirSial, Airblue)
- **Backend**: Each request processed independently
- **Network**: 2-3 HTTP requests per search

### New Implementation
- **Frontend**: Makes a single API call with polling for results
- **Backend**: Manages all provider calls internally, returns results as they arrive
- **Network**: Initial request + polling requests (fewer total requests)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│ FRONTEND (Vue.js)                                               │
│ CheapestFareFlight.vue                                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
                   ┌─────────────────┐
                   │  Single API Call │
                   │  POST /ticketing/chunked-flight-search       │
                   │  { providers: "Sabre,AirSial,Airblue" }      │
                   └─────────┬───────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ BACKEND (Laravel)                                               │
│ ChunkedFlightSearchController                                   │
│                                                                  │
│ First Request (searchId = null):                                │
│  1. Generate unique searchId                                    │
│  2. Initialize cache with provider queue                        │
│  3. Process FIRST provider (e.g., Sabre)                        │
│  4. Return: { searchId, fetchMore: true, data: [sabre_result] } │
│                                                                  │
│ Subsequent Polls (with searchId):                               │
│  1. Load search state from cache                                │
│  2. Process NEXT provider from queue                            │
│  3. Add result to cache                                         │
│  4. Return: { searchId, fetchMore: boolean, data: [new_result] }│
│                                                                  │
│ Final Poll:                                                      │
│  1. Process last provider                                       │
│  2. Return: { fetchMore: false, data: [last_result] }           │
│  3. Clean up cache                                              │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ▼
              ┌──────────────────────────────┐
              │  Cache/Session Storage       │
              │  Key: flight_search_{id}     │
              │  TTL: 5 minutes              │
              │                              │
              │  {                           │
              │    searchId: "search_123",   │
              │    providers: [...],         │
              │    pendingProviders: [...],  │
              │    processedProviders: [...],│
              │    results: [...],           │
              │    errors: [...]             │
              │  }                           │
              └──────────────────────────────┘
```

## Key Benefits

### 1. Reduced Frontend Complexity
- No need to manage multiple concurrent requests
- Single polling loop instead of Promise.allSettled coordination
- Cleaner, more maintainable code

### 2. Better Server Control
- Backend controls request rate to external APIs
- Easier to implement rate limiting
- Can prioritize certain providers
- Centralized error handling

### 3. Progressive Results
- Users see results as they arrive (same UX as before)
- Backend can optimize provider order (fast providers first)
- Failed providers don't block others

### 4. Easier Monitoring
- Single endpoint to monitor
- Centralized logging
- Better debugging with searchId tracking

## Files Modified

### 1. New Controller
**File**: `app/Http/Controllers/Website/Ticketing/ChunkedFlightSearchController.php`

**Methods**:
- `chunkedFlightSearch(Request $request)` - Main endpoint for sequential provider processing
- `chunkedFlightSearchParallel(Request $request)` - Alternative async implementation (future enhancement)

### 2. Updated Service Provider
**File**: `app/Libraries/rest_api/AirShoppingProvider.php`

**Changes**:
```php
// Before:
public static function cheapestFareAirshoppingReponse($request)

// After:
public static function cheapestFareAirshoppingReponse($request, $actionType = null)
```
Now accepts provider name as parameter instead of only from header.

### 3. New Route
**File**: `routes/web.php`

**Added**:
```php
Route::post('/chunked-flight-search',
            'Website\Ticketing\ChunkedFlightSearchController@chunkedFlightSearch')
    ->name('chunkedFlightSearch')
    ->middleware('block.ip');
```

### 4. Updated Frontend
**File**: `resources/js/Pages/Website/Ticketing/CheapestFareFlight.vue`

**New Method**: `airShoppingChunked()`
**Modified**: `mounted()` - now calls `airShoppingChunked()` instead of `airShopping()`

## API Request/Response Flow

### Initial Request
```javascript
POST /ticketing/chunked-flight-search

Request:
{
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
  "searchId": null  // null for first request
}

Response:
{
  "searchId": "search_67a1b2c3d4e5f",
  "fetchMore": true,
  "data": [
    {
      "provider": "Sabre",
      "data": { /* flight availability data */ }
    }
  ],
  "totalProviders": 3,
  "processedCount": 1,
  "remainingCount": 2,
  "latestProvider": "Sabre",
  "latestResult": { /* latest result object */ }
}
```

### Polling Request (2nd call)
```javascript
POST /ticketing/chunked-flight-search

Request:
{
  // ... same payload as before ...
  "searchId": "search_67a1b2c3d4e5f",  // from previous response
  "lastCount": 1
}

Response:
{
  "searchId": "search_67a1b2c3d4e5f",
  "fetchMore": true,
  "data": [
    {
      "provider": "Sabre",
      "data": { /* ... */ }
    },
    {
      "provider": "AirSial",
      "data": { /* flight availability data */ }
    }
  ],
  "totalProviders": 3,
  "processedCount": 2,
  "remainingCount": 1,
  "latestProvider": "AirSial",
  "latestResult": { /* AirSial result */ }
}
```

### Final Response
```javascript
Response:
{
  "searchId": "search_67a1b2c3d4e5f",
  "fetchMore": false,  // No more providers to query
  "data": [
    { "provider": "Sabre", "data": {...} },
    { "provider": "AirSial", "data": {...} },
    { "provider": "Airblue", "data": {...} }
  ],
  "totalProviders": 3,
  "processedCount": 3,
  "remainingCount": 0,
  "latestProvider": "Airblue",
  "latestResult": { /* Airblue result */ }
}
```

## Frontend Implementation Details

### Polling Logic
```javascript
async airShoppingChunked() {
    let searchId = null;
    let lastResultCount = 0;

    const pollForResults = async () => {
        const response = await fetch("/ticketing/chunked-flight-search", {
            method: "POST",
            body: JSON.stringify({
                ...this.cheapestFare.payload,
                providers: this.providers.join(','),
                searchId: searchId,
                lastCount: lastResultCount
            })
        });

        const result = await response.json();

        // Store searchId for subsequent polls
        if (!searchId) searchId = result.searchId;

        // Process new results
        if (result.latestResult) {
            this.cheapestFare.flightAvailabilities.push(result.latestResult.data);
        }

        // Continue polling if more data available
        if (result.fetchMore) {
            await new Promise(resolve => setTimeout(resolve, 500));
            await pollForResults();
        }
    };

    await pollForResults();
}
```

### Progress Tracking
The frontend updates progress based on `processedCount` and `totalProviders`:
```javascript
this.progress = Math.round((result.processedCount / result.totalProviders) * 100);
this.loadingMsg = `Searching ${result.processedCount}/${result.totalProviders} providers...`;
```

## Cache/State Management

### Cache Structure
```php
Cache::put("flight_search_{$searchId}", [
    'searchId' => 'search_67a1b2c3d4e5f',
    'providers' => ['Sabre', 'AirSial', 'Airblue'],
    'pendingProviders' => ['AirSial', 'Airblue'],  // Remaining
    'processedProviders' => ['Sabre'],              // Completed
    'results' => [
        ['provider' => 'Sabre', 'data' => [...]]
    ],
    'errors' => [],
    'startedAt' => 1705843200
], now()->addMinutes(5));
```

### Cache Cleanup
- TTL: 5 minutes
- Automatically deleted when `fetchMore: false`
- Prevents stale data accumulation

## Configuration

### Polling Settings
**File**: `CheapestFareFlight.vue:835`

```javascript
const maxPollingAttempts = 50;  // Maximum poll cycles
const pollInterval = 500;        // Milliseconds between polls
```

### Cache TTL
**File**: `ChunkedFlightSearchController.php:96`

```php
Cache::put($cacheKey, $searchState, now()->addMinutes(5));
```

## Switching Between Implementations

To revert to the old implementation:

**File**: `resources/js/Pages/Website/Ticketing/CheapestFareFlight.vue:681`

```javascript
// New chunked implementation (current)
this.airShoppingChunked();

// Old parallel implementation (previous)
// this.airShopping();
```

Simply comment/uncomment the desired method call.

## Error Handling

### Backend Errors
```php
'errors' => [
    [
        'provider' => 'AirSial',
        'error' => 'Connection timeout'
    ]
]
```

### Frontend Error Handling
```javascript
if (response.status !== 200) {
    this.responseError = result.error || "Failed to fetch flight data";
    this.finish(false);
    return;
}
```

## Performance Comparison

| Metric | Old Implementation | New Implementation |
|--------|-------------------|-------------------|
| Initial API Calls | 3 (parallel) | 1 |
| Total HTTP Requests | 3 | 4 (1 initial + 3 polls) |
| Frontend Complexity | High (manage 3 concurrent requests) | Low (single polling loop) |
| Backend Control | Low | High |
| First Result Shown | ~2-3 seconds | ~2-3 seconds (same) |
| Error Isolation | Per-request | Centralized |
| Monitoring | 3 endpoints | 1 endpoint |

## Testing Checklist

- [ ] Test with all providers active (Sabre, AirSial, Airblue)
- [ ] Test with single provider
- [ ] Test with provider that returns no results
- [ ] Test with provider timeout/error
- [ ] Test cache expiration scenario
- [ ] Test concurrent searches (multiple users)
- [ ] Test progress bar updates correctly
- [ ] Test final message when search completes
- [ ] Test "no flights available" scenario
- [ ] Verify old implementation still works (for rollback)

## Future Enhancements

### 1. WebSocket Implementation
Replace polling with WebSocket for real-time push:
```javascript
const ws = new WebSocket('wss://rehmantravel.com/flight-search');
ws.send(JSON.stringify(searchPayload));
ws.onmessage = (event) => {
    const result = JSON.parse(event.data);
    // Process result...
};
```

### 2. Queue-Based Processing
Use Laravel Queues for truly async provider processing:
```php
foreach ($providers as $provider) {
    ProcessFlightSearchJob::dispatch($searchId, $provider, $requestData);
}
```

### 3. Provider Prioritization
Query fast providers first:
```php
$providers = ['Sabre', 'AirSial', 'Airblue'];
usort($providers, function($a, $b) {
    return $providerSpeed[$a] <=> $providerSpeed[$b];
});
```

## Troubleshooting

### Issue: Frontend keeps polling forever
**Cause**: Backend not setting `fetchMore: false`
**Fix**: Check `ChunkedFlightSearchController.php:90` - ensure pending providers array is empty

### Issue: Cache expires during search
**Cause**: TTL too short for slow searches
**Fix**: Increase cache TTL in `ChunkedFlightSearchController.php:96`

### Issue: Duplicate results shown
**Cause**: Frontend not tracking `lastResultCount`
**Fix**: Ensure `lastCount` parameter is sent in polling requests

## Summary

The new chunked flight search implementation provides:
- ✅ Single API call from frontend
- ✅ Backend-managed provider processing
- ✅ Progressive result display
- ✅ Better error handling and monitoring
- ✅ Easier maintenance and debugging
- ✅ Same user experience with better architecture

The old implementation remains available for easy rollback if needed.
