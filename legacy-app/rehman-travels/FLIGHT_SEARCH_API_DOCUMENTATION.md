# Flight Search API Documentation

## Overview
This document explains the architecture and execution flow of the flight search API (`/ticketing/cheapest-fare-airshopping-request`) in the Rehman Travels application.

## API Endpoint
```
POST /ticketing/cheapest-fare-airshopping-request
Content-Type: application/json
action-type: {PROVIDER_NAME} (e.g., Sabre, AirSial, Airblue)
```

## Architecture Overview

### 1. Frontend Layer (Vue.js)
**File:** `resources/js/Pages/Website/Ticketing/CheapestFareFlight.vue`

The frontend initiates multiple parallel API calls when the user clicks the "Search" button.

**Key Code (Line 822-892):**
```javascript
async airShopping() {
    const concurrencyLimit = 3;
    const totalProviders = this.providers?.length ?? 0;

    this.providers.forEach((supplier) => {
        Service.doFetch("/ticketing/cheapest-fare-airshopping-request",
                       supplier,
                       this.cheapestFare.payload)
    });
}
```

**Provider List Source:**
- Providers come from `this.$page.props.providers` (passed from backend)
- Sourced from database table `premium_airlines` where `airlineType = 'supplier'` and `agentId = 1182`
- Typically includes: Sabre, AirSial, Airblue (comma-separated list)

### 2. Backend Layer (Laravel)
**Route:** `routes/web.php:29`
```php
Route::post('/cheapest-fare-airshopping-request',
            'Website\Ticketing\CheapestFareAirShoppingController@cheapestFareAirshoppingRequest')
```

**Controller:** `app/Http/Controllers/Website/Ticketing/CheapestFareAirShoppingController.php`

**Flow:**
1. Validates input parameters
2. Extracts provider name from `action-type` header
3. Delegates to `AirShoppingProvider::cheapestFareAirshoppingReponse()`

### 3. Service Provider Layer
**File:** `app/Libraries/rest_api/AirShoppingProvider.php`

**Responsibilities:**
- Constructs payload for external API
- Formats flight search parameters (departure, arrival, dates, passengers, cabin class)
- Handles multi-city and round-trip requests

**Key Code (Line 9-14):**
```php
public static function cheapestFareAirshoppingReponse($request) {
    if($request->cabin != 'Y' && ($request->header('action-type') == 'AirSial'
                                || $request->header('action-type') == 'Airblue')):
        return []; // Some providers only support Economy class
    endif;
    return ServiceProvider::doRequest("POST",
                                      $request->header('action-type'),
                                      self::__airShoppingPayload($request));
}
```

### 4. HTTP Client Layer
**File:** `app/Libraries/rest_api/ServiceProvider.php`

**External API Configuration:**
- **API URL:** `http://exaltedrestapiandrehmantravel.local/api/` (from .env)
- **Authentication:** Bearer token stored in `storage/app/AccessToken/1182owner.json`

**Key Code (Line 17):**
```php
$response = $client->request($method, env('API_URL').$actionType, [
    'headers' => [
        "Authorization" => "Bearer ".$accessToken->data->access_token,
        "secretId" => $loggedIn['secretId'],
        "clientId" => $loggedIn['email'],
        // ... other headers
    ],
    'body' => $payload,
]);
```

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ USER CLICKS "SEARCH FLIGHT"                                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ Frontend (CheapestFareFlight.vue)                               │
│ - Loops through providers array (e.g., ["Sabre", "AirSial"])   │
│ - Makes MULTIPLE parallel API calls (one per provider)          │
└─────┬───────────────┬───────────────┬───────────────────────────┘
      │               │               │
      ▼               ▼               ▼
  ┌───────┐      ┌───────┐      ┌────────┐
  │Request│      │Request│      │Request │
  │Sabre  │      │AirSial│      │Airblue │
  └───┬───┘      └───┬───┘      └────┬───┘
      │              │               │
      │              │               │
      ▼              ▼               ▼
┌─────────────────────────────────────────────────────────────────┐
│ Backend (Laravel)                                               │
│ Route: /ticketing/cheapest-fare-airshopping-request            │
│ Controller: CheapestFareAirShoppingController                  │
│ - Validates input                                               │
│ - Extracts provider from 'action-type' header                   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ AirShoppingProvider                                             │
│ - Constructs flight search payload                              │
│ - Formats dates, passengers, cabin class                         │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ ServiceProvider (HTTP Client)                                   │
│ - URL: http://exaltedrestapiandrehmantravel.local/api/{provider}│
│ - Adds Bearer token authentication                              │
│ - Sends POST request to middleware API                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ EXTERNAL MIDDLEWARE API                                         │
│ (exaltedrestapiandrehmantravel.local)                          │
│ - Aggregates requests to multiple GDS providers                 │
│ - Routes requests based on provider type                         │
└────────────┬────────────────┬────────────────┬──────────────────┘
             │                │                │
             ▼                ▼                ▼
        ┌────────┐      ┌─────────┐      ┌─────────┐
        │ Sabre  │      │ AirSial │      │ Airblue │
        │  GDS   │      │   API   │      │   API   │
        │  API   │      │         │      │         │
        └────┬───┘      └────┬────┘      └────┬────┘
             │               │                │
             │  Flight Data  │   Flight Data  │  Flight Data
             ▼               ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│ Response flows back through the same chain                      │
│ Frontend receives and merges results from all providers         │
│ Displays combined flight options to user                        │
└─────────────────────────────────────────────────────────────────┘
```

## Why Multiple API Calls Occur

### Reason 1: Multi-Provider Search
The application searches across multiple flight providers simultaneously to offer users:
- **Best prices** from different sources
- **More flight options** and availability
- **Competitive comparison** across airlines/GDSs

### Reason 2: Provider-Specific Capabilities
Different providers have different capabilities:
- **Sabre:** Full GDS with international and domestic flights, all cabin classes
- **AirSial:** Direct airline API, typically Economy class only (Line 10-12 in AirShoppingProvider)
- **Airblue:** Direct airline API, typically Economy class only

### Reason 3: Performance & User Experience
**Code Reference:** `CheapestFareFlight.vue:826`
```javascript
const concurrencyLimit = 3;
```

The frontend implements:
- **Parallel execution** with concurrency limits to prevent overwhelming the server
- **Progressive loading** - displays results as they arrive from each provider
- **Better UX** - users see partial results quickly rather than waiting for all providers

## Data Source: Internal vs External

### NOT Internally Managed by Database
The flight data is **NOT** stored in the application's database. Each search queries live APIs in real-time.

### External Service Architecture

**Primary Middleware:**
- URL: `http://exaltedrestapiandrehmantravel.local/api/`
- Acts as an aggregator/proxy between Rehman Travels app and actual flight data providers

**Actual Data Sources:**
1. **Sabre GDS (Global Distribution System)**
   - Major airline reservation system
   - Provides access to hundreds of airlines worldwide
   - Real-time pricing and availability

2. **AirSial Direct API**
   - Pakistan-based airline
   - Direct connection to airline's booking system

3. **Airblue Direct API**
   - Pakistan-based airline
   - Direct connection to airline's booking system

## Request/Response Example

### Request Payload (from cURL)
```json
{
  "departureCode": "ISB",
  "arrivalCode": "KHI",
  "outboundDate": "31-01-2026",
  "inboundDate": "05-02-2026",
  "cabin": "Y",
  "stop": "",
  "currencyCode": "PKR",
  "adultsCount": 1,
  "childrenCount": 0,
  "infantsCount": 0,
  "tripType": "round-trip",
  "locale": "ar"
}
```

### Request Headers
```
action-type: Sabre
x-csrf-token: NasQK7yqz4eD1lNnG7AsTe7nAB0YULYJBOLGURPb
Content-Type: application/json
```

### Response Processing
**File:** `CheapestFareFlight.vue:837-892`

The frontend:
1. Receives responses from each provider
2. Validates response structure
3. Merges flight availability data
4. Applies filters (stops, vendors, price)
5. Sorts by price (cheapest first)
6. Displays consolidated results

## Security & Authentication

### Access Token Management
**File:** `app/Libraries/AccessTokenProvider.php`

- Bearer tokens stored in: `storage/app/AccessToken/1182owner.json`
- Token refresh mechanism via `RefreshAccessToken` event
- Authenticated using agent credentials (agentId: 1182)

### Request Authentication Headers
```php
"Authorization" => "Bearer ".$accessToken->data->access_token,
"secretId" => $loggedIn['secretId'],
"clientId" => $loggedIn['email'],
"clientSecret" => $loggedIn['clientSecret'],
"grantType" => "exaltedsys_api",
"userType" => 'agent'
```

## Key Files Reference

| File | Purpose | Line Reference |
|------|---------|----------------|
| `routes/web.php` | API route definition | Line 29 |
| `CheapestFareAirShoppingController.php` | Request handler | Line 14-22 |
| `AirShoppingProvider.php` | Payload construction | Line 9-58 |
| `ServiceProvider.php` | HTTP client | Line 12-38 |
| `CheapestFareFlight.vue` | Frontend logic | Line 822-892 |
| `PremiumAirline.php` | Provider configuration | Line 15-22 |

## Summary

1. **API Execution:** The API routes requests through a Laravel backend to an external middleware API that aggregates multiple flight data sources

2. **External Services:** Data comes from Sabre GDS and direct airline APIs (AirSial, Airblue), NOT from internal database

3. **Multiple API Calls:** The frontend makes 1 API call per provider (typically 2-3 providers), explaining why you see multiple requests when clicking "Search"

4. **Purpose:** This multi-provider approach ensures users get the best prices and maximum flight options across different sources
