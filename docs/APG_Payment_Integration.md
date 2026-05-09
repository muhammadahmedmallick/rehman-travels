# APG Payment Status Tracking
**Rehman Travels — Technical Integration Document**

| | |
|---|---|
| **Version** | 1.0 |
| **Date** | April 2026 |
| **Platform** | Django 4.x + Flutter |
| **Status** | Implemented |

---

## Table of Contents

1. [Overview](#1-overview)
2. [Payment Flow](#2-payment-flow)
3. [Django Backend Changes](#3-django-backend-changes)
4. [Flutter Mobile App Changes](#4-flutter-mobile-app-changes)
5. [APG Merchant Portal Configuration](#5-apg-merchant-portal-configuration)
6. [Deployment Checklist](#6-deployment-checklist)
7. [Files Changed](#7-files-changed)
8. [Notes & Limitations](#8-notes--limitations)

---

## 1. Overview

This document describes the end-to-end implementation of payment status tracking for the Alfa Payment Gateway (APG) — Bank Alfalah — within the Rehman Travels platform. It covers all changes made to the Django backend and the Flutter mobile application.

### 1.1 Problem Statement

The Alfa Payment Gateway (APG) uses a redirection model: the user is sent to an external browser to complete payment. Once the user pays, the app had no mechanism to know whether the payment succeeded or failed. There was no webhook handler, no status polling endpoint, and no database record of APG transactions.

### 1.2 Solution Summary

Two complementary APG mechanisms are now fully wired up:

- **IPN Listener (Webhook):** APG POSTs to our Django server immediately when a transaction concludes. Django fetches the status URL and updates the database.
- **Return URL Handler:** APG redirects the customer's browser back to a Django endpoint after payment. Django calls the APG inquiry API, updates the DB, and renders a "return to app" page.
- **Flutter Polling:** When the user returns to the app from the browser, Flutter polls a lightweight status endpoint every 3 seconds (up to 60 seconds) and displays a result dialog.

---

## 2. Payment Flow

| # | Actor | Action |
|---|---|---|
| 1 | Flutter App | User taps "Pay with Card" on the Payment screen. |
| 2 | Flutter → Django | `POST /api/payments/apg/initiate/` — creates a pending `APGTransaction` record keyed by the booking PNR. |
| 3 | Flutter → rehmantravel.com | Calls the existing AlfalahPay endpoint to get the APG payment URL (`payUrl`). |
| 4 | Flutter | Opens `payUrl` in the external browser via `launchUrl()`. Sets `_awaitingApgReturn = true`. |
| 5 | User / Browser | User completes (or abandons) payment on the Bank Alfalah hosted checkout page. |
| 6 | APG → Django | APG POSTs to the IPN Listener URL with a `?url=` param. Django fetches that URL, gets the transaction status, and updates the `APGTransaction` record to `paid` or `failed`. |
| 7 | APG → Browser | APG redirects the browser to the Return URL. Django's `APGReturnView` fetches status from APG, updates the DB as a safety net, and renders a "Return to App" HTML page. |
| 8 | Flutter | User returns to the app. `didChangeAppLifecycleState` fires (`AppLifecycleState.resumed`). |
| 9 | Flutter → Django | Flutter polls `GET /api/payments/apg/status/<pnr>/` every 3 seconds. |
| 10 | Django | Returns `{ "status": "paid" | "failed" | "pending" }`. If still pending and `order_id` is set, Django calls the APG inquiry API live and returns the fresh result. |
| 11 | Flutter | On receiving `paid` or `failed`, stops polling and shows a result dialog. User taps "View Booking" to navigate to the ticket screen. |

---

## 3. Django Backend Changes

### 3.1 New Database Model — `APGTransaction`

A new fully managed PostgreSQL table `apg_transactions` is created by migration `0002`. It lives in the `payments` app alongside the existing legacy models.

| Field | Type | Notes |
|---|---|---|
| `id` | BigAutoField | Auto-increment primary key. |
| `transaction_ref` | CharField(150) | Merchant-generated unique ref. Set to the booking PNR so APG's IPN response can match it. Indexed, unique. |
| `order_id` | CharField(150) | APG's Order ID returned in the Return URL `?O=` param. Populated after APG responds. |
| `apg_transaction_id` | CharField(150) | APG's internal `TransactionId` from the IPN JSON response. |
| `booking_pnr` | CharField(150) | Booking PNR / itinerary reference. |
| `booking_reference` | CharField(150) | Secondary booking reference. |
| `air_type` | CharField(50) | Provider type (e.g. IATA). |
| `amount` | DecimalField | Transaction amount (14 digits, 2 decimal places). |
| `currency` | CharField(10) | Currency code, defaults to `PKR`. |
| `transaction_status` | CharField(20) | `pending` / `paid` / `failed` / `cancelled`. Indexed. |
| `response_code` | CharField(10) | APG `ResponseCode` (`00` = success). |
| `account_number` | CharField(50) | Payer account/card number (masked) from APG. |
| `mobile_number` | CharField(20) | Payer mobile number from APG. |
| `order_datetime` | CharField(50) | Order creation timestamp as returned by APG. |
| `transaction_datetime` | CharField(50) | Payment execution timestamp from APG. |
| `apg_response` | JSONField | Full APG IPN JSON response stored for audit and debugging. |
| `created_at` | DateTimeField | Auto-set on record creation. |
| `updated_at` | DateTimeField | Auto-set on every save. |

### 3.2 Migration

**File:** `apps/payments/migrations/0002_apgtransaction.py`

```bash
python manage.py migrate payments
```

### 3.3 New API Endpoints

| Method | URL | Purpose |
|---|---|---|
| `POST` | `/api/payments/apg/initiate/` | Creates a pending `APGTransaction`. Called by Flutter before launching the browser. |
| `GET` | `/api/payments/apg/status/<ref>/` | Returns current transaction status. Flutter polls this after the user returns to the app. |
| `GET` | `/api/payments/apg/return/` | APG redirects the customer browser here after payment. Calls APG inquiry, updates DB, renders HTML return page. |
| `POST` | `/api/payments/apg/ipn/` | APG IPN webhook. APG sends a `?url=` param; Django GETs it and updates DB. Must be whitelisted by Bank Alfalah. |

---

#### `POST /api/payments/apg/initiate/`

**Request body:**
```json
{
  "transaction_ref":   "ABC123",
  "booking_pnr":       "ABC123",
  "booking_reference": "ABC123",
  "air_type":          "IATA",
  "amount":            15000.00,
  "currency":          "PKR"
}
```

**Response (201 Created):**
```json
{
  "transaction_ref": "ABC123",
  "status": "pending"
}
```

Uses `update_or_create` so retries reset the record rather than failing with a duplicate-key error.

---

#### `GET /api/payments/apg/status/<transaction_ref>/`

**Response (200 OK):**
```json
{
  "transaction_ref":    "ABC123",
  "order_id":           "A10",
  "status":             "paid",
  "response_code":      "00",
  "apg_transaction_id": "1263781929",
  "amount":             "15000.00",
  "currency":           "PKR",
  "booking_pnr":        "ABC123",
  "created_at":         "2026-04-24T12:00:00+05:00",
  "updated_at":         "2026-04-24T12:01:00+05:00"
}
```

If status is still `pending` but `order_id` is already populated, Django proactively calls the APG inquiry API and returns the fresh result.

---

#### `GET /api/payments/apg/return/`

APG appends query params: `?TS=P&RC=00&RD=&O=<OrderId>`. Append `?ref=<transaction_ref>` when building the `HS_ReturnURL` sent to APG so the endpoint can match the record immediately.

Renders a branded HTML page with a "Return to App" button and an automatic deep-link redirect using the scheme `rehmantravel://`.

---

#### `POST /api/payments/apg/ipn/`

APG sends a POST with `?url=https://payments.bankalfalah.com/HS/api/IPN/OrderStatus/{MerchantId}/{StoreId}/{OrderId}`. Django:

1. Validates the host is `payments.bankalfalah.com` or `sandbox.bankalfalah.com`.
2. GETs the URL and parses the JSON response.
3. Finds the matching `APGTransaction` by `transaction_ref` or `order_id` and updates it.
4. If no matching record exists, creates one for audit purposes.
5. Returns HTTP 200 `{ "received": true }` so APG considers the notification delivered.

---

### 3.4 New Settings

Added to `config/settings/base.py`:

| Variable | Description | Notes |
|---|---|---|
| `APG_MERCHANT_ID` | Your Merchant ID from the APG portal. | Required for the IPN inquiry URL. |
| `APG_STORE_ID` | Your Store ID from the APG portal. | Required for the IPN inquiry URL. |
| `APG_SANDBOX` | `True` (sandbox) or `False` (production). | Switches between sandbox and production APG IPN base URLs. |

---

## 4. Flutter Mobile App Changes

### 4.1 New API Endpoint Constants (`api_endpoints.dart`)

| Constant | URL | Purpose |
|---|---|---|
| `apgInitiate` | `POST /api/payments/apg/initiate/` | Register pending transaction before payment. |
| `apgStatus(ref)` | `GET /api/payments/apg/status/<ref>/` | Poll for `paid`/`failed` status after returning from browser. |
| `apgReturn` | `GET /api/payments/apg/return/` | Django return URL (for portal config reference). |
| `apgIpn` | `POST /api/payments/apg/ipn/` | Django IPN listener (for portal config reference). |

### 4.2 `payment_screen.dart` Changes

`PaymentScreen` now mixes in `WidgetsBindingObserver` to receive app lifecycle events and drives the entire APG status loop.

#### New state fields

| Field | Type | Purpose |
|---|---|---|
| `_apgTransactionRef` | `String?` | The ref registered with Django (= booking PNR). Set before launching the browser. |
| `_awaitingApgReturn` | `bool` | `true` while the user is in the APG browser. Triggers polling on resume. |
| `_pollTimer` | `Timer?` | Repeating 3-second timer. Cancelled on conclusive result or timeout. |
| `_pollCount` | `int` | Guards against infinite polling. Max 20 polls (~60 seconds). |

#### `_processPayment()` — Alfalah card path

1. Calls `POST /api/payments/apg/initiate/` to create a pending `APGTransaction`. Non-fatal: if the call fails, the ref is still stored locally and polling continues.
2. Calls the existing `rehmantravel.com` AlfalahPay endpoint to get the `payUrl`.
3. Opens `payUrl` via `launchUrl(mode: LaunchMode.externalApplication)` and sets `_awaitingApgReturn = true`.

#### `didChangeAppLifecycleState()`

When `AppLifecycleState.resumed` fires and `_awaitingApgReturn` is `true`, polling starts immediately.

#### `_startPollingStatus()` / `_checkPaymentStatus()`

1. Resets `_pollCount`, starts a 3-second repeating timer, fires the first poll immediately.
2. Each poll calls `GET /api/payments/apg/status/<ref>/`.
3. On `paid` or `failed`: cancels the timer, hides the loader, shows the result dialog.
4. After 20 polls (~60 s) with no conclusive result: shows a "payment pending" dialog and stops.

#### Result dialog

| Status | Icon | Title | Actions |
|---|---|---|---|
| `paid` | ✅ | Payment Successful! | "View Booking" → ticket screen |
| `failed` | ❌ | Payment Failed | "Try Again" (stay) / "Continue" (navigate away) |
| `pending` (timeout) | ⏳ | Payment Pending | "Continue" → ticket screen, advise checking booking history |

---

## 5. APG Merchant Portal Configuration

Log in at `https://payments.bankalfalah.com` → **Go Live → Generate Credentials**.

### 5.1 Listener URL (IPN Webhook)

Register this as the **Listener URL**:
```
https://<your-domain>/api/payments/apg/ipn/
```

- Must be publicly reachable by Bank Alfalah's servers.
- After registering, inform your Bank Alfalah business owner so the URL can be **whitelisted on their network**. The IPN will not fire until this whitelist is active.

### 5.2 Return URL

Register this as the **Return URL**:
```
https://<your-domain>/api/payments/apg/return/
```

- Append `?ref=<transaction_ref>` dynamically when building `HS_ReturnURL`.
- The rendered page shows a "Return to App" button and attempts a `rehmantravel://` deep-link redirect.

### 5.3 Environment URLs

| Environment | URL |
|---|---|
| Sandbox Handshake | `https://sandbox.bankalfalah.com/HS/HS/HS` |
| Production Handshake | `https://payments.bankalfalah.com/HS/HS/HS` |
| Sandbox SSO | `https://sandbox.bankalfalah.com/SSO/SSO/SSO` |
| Production SSO | `https://payments.bankalfalah.com/SSO/SSO/SSO` |
| Sandbox IPN Inquiry | `https://sandbox.bankalfalah.com/HS/api/IPN/OrderStatus/{mid}/{sid}/{oid}` |
| Production IPN Inquiry | `https://payments.bankalfalah.com/HS/api/IPN/OrderStatus/{mid}/{sid}/{oid}` |

---

## 6. Deployment Checklist

### 6.1 Environment Variables

```env
APG_MERCHANT_ID=<your-merchant-id-from-portal>
APG_STORE_ID=<your-store-id-from-portal>
APG_SANDBOX=False   # True for staging, False for production
```

### 6.2 Database Migration

```bash
python manage.py migrate payments
```

### 6.3 Step-by-step Go-Live

1. Deploy the updated Django backend and run the migration.
2. Log in to the APG merchant portal.
3. Go to **Go Live → Generate Credentials**. Enter your Return URL and Listener URL.
4. Inform your Bank Alfalah business contact of the Listener URL so it can be whitelisted.
5. Set `APG_SANDBOX=False` and update `APG_MERCHANT_ID` / `APG_STORE_ID` to production values.
6. Deploy the updated Flutter app.
7. Perform an end-to-end test payment.
8. Verify the `apg_transactions` table is updated and the app shows the correct result dialog.

### 6.4 Verification Queries

Check recent transactions:
```sql
SELECT transaction_ref, booking_pnr, amount, transaction_status,
       response_code, created_at, updated_at
FROM   apg_transactions
ORDER  BY created_at DESC
LIMIT  20;
```

Check for orphaned IPN records (created without a matching initiate call):
```sql
SELECT * FROM apg_transactions
WHERE  transaction_ref LIKE 'IPN-%'
ORDER  BY created_at DESC;
```

---

## 7. Files Changed

### 7.1 Django Backend

| File | Change |
|---|---|
| `apps/payments/models.py` | Added `APGTransaction` model with all fields and `update_from_apg_response()` helper. |
| `apps/payments/migrations/0002_apgtransaction.py` | New migration that creates the `apg_transactions` table. |
| `apps/payments/views.py` | Added `APGInitiateView`, `APGStatusView`, `APGReturnView`, `APGIPNView`. Existing viewsets unchanged. |
| `apps/payments/serializers.py` | Added `APGTransactionSerializer`. |
| `apps/payments/urls.py` | Wired four new APG URL patterns alongside existing router URLs. |
| `apps/payments/admin.py` | Registered `APGTransactionAdmin` with full fieldsets, search, and filter config. |
| `config/settings/base.py` | Added `APG_MERCHANT_ID`, `APG_STORE_ID`, `APG_SANDBOX` settings. |

### 7.2 Flutter Mobile App

| File | Change |
|---|---|
| `lib/core/constants/api_endpoints.dart` | Added `apgInitiate`, `apgStatus()`, `apgReturn`, `apgIpn` constants. |
| `lib/features/flights/presentation/screens/payment_screen.dart` | Full APG status loop: `WidgetsBindingObserver`, initiate call, lifecycle detection, polling timer, result dialog. |

---

## 8. Notes & Limitations

- **IPN whitelist required:** The APG IPN webhook will not fire in production until Bank Alfalah whitelists your server IP. Test with the Return URL path first while waiting for the whitelist.
- **Polling timeout:** Flutter polls for a maximum of 60 seconds. If the IPN is delayed beyond this, the user sees a "Payment Pending" dialog. The DB will still be updated when the IPN eventually arrives.
- **Transaction ref = PNR:** The implementation uses the booking PNR as the APG `TransactionReferenceNumber`. This assumes the `rehmantravel.com` AlfalahPay API also sends the PNR to APG as the reference. If not, the IPN matching logic in `APGIPNView` will need adjustment.
- **Deep-link:** The "Return to App" page attempts a `rehmantravel://` deep-link. This requires registering the URI scheme in `AndroidManifest.xml` and `Info.plist`. Without it, only the manual button works — the status polling still functions correctly regardless.
- **No authentication on APG endpoints:** The initiate and status endpoints are currently open (`AllowAny`), consistent with the rest of the project. Add JWT authentication if user-level payment history isolation is required.
