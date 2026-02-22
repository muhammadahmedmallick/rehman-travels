# Rehman Travels - Mobile App

A Flutter-based mobile application for **Rehman Travels**, providing flight search & booking, visa services, currency rates, bank details, and more.

## API Documentation

- **Swagger UI**: [http://3.222.113.143:8000/swagger/](http://3.222.113.143:8000/swagger/)
- **ReDoc**: [http://3.222.113.143:8000/redoc/](http://3.222.113.143:8000/redoc/)
- **Swagger JSON**: [http://3.222.113.143:8000/swagger.json](http://3.222.113.143:8000/swagger.json)

### API Base URLs

| API | Base URL | Auth |
|-----|----------|------|
| Core API (Django) | `http://3.222.113.143:8000` | Basic Auth |
| Web API (Laravel) | `https://www.rehmantravel.com` | CSRF Token |

### Core API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/core/bank-details/` | GET | Fetch bank account details |
| `/api/core/currencies/` | GET | Fetch currency exchange rates |
| `/api/core/branches/` | GET | Fetch branch locations |

### Web API Endpoints (Laravel)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/ticketing/cheapest-fare-flight` | GET | Flight search page (CSRF token) |
| `/ticketing/cheapest-fare-airshopping-request` | POST | Search flights |
| `/ticketing/cheapest-fare-airports` | POST | Airport autocomplete |
| `/ticketing/cheapest-fare-flight-fare-rule-request` | POST | Get fare rules |
| `/ticketing/cheapest-fare-flight-order-create` | POST | Create booking |
| `/ticketing/cheapest-fare-flight-order-retrieve` | POST | Retrieve booking |
| `/login` | POST | User login |
| `/register` | POST | User registration |
| `/logout` | POST | User logout |

## Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter (Dart SDK ^3.10.0) |
| State Management | Riverpod |
| Navigation | GoRouter |
| HTTP Client | Dio (with cookie management) |
| Local Storage | SharedPreferences, Hive |
| Authentication | Firebase Auth, Google Sign-In |
| Fonts | Google Fonts (Plus Jakarta Sans) |
| UI Components | Material 3, Shimmer, Cached Network Image, Flutter SVG |

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── app.dart                       # RehmanTravelsApp widget
│   ├── routes.dart                    # GoRouter route definitions
│   ├── theme.dart                     # App theme, colors, spacing
│   └── main_shell.dart                # Bottom navigation shell
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart         # API URLs & headers
│   └── network/
│       ├── api_client.dart            # Laravel API client (Dio + CSRF)
│       ├── core_api_client.dart       # Django Core API client (Dio + Basic Auth)
│       └── api_exceptions.dart        # Custom API exceptions
└── features/
    ├── home/                          # Home screen
    ├── flights/                       # Flight search, results, details, booking
    │   └── presentation/
    │       ├── screens/
    │       │   ├── flight_results_screen.dart
    │       │   ├── flight_details_screen.dart
    │       │   └── booking_screen.dart
    │       ├── widgets/
    │       │   ├── flight_card.dart
    │       │   └── flight_search_form.dart
    │       └── providers/
    │           └── flight_search_provider.dart
    ├── visa/                          # Visa services
    ├── auth/                          # Login & registration
    ├── profile/                       # User profile
    ├── bank/                          # Bank details
    ├── currency/                      # Currency rates
    ├── branches/                      # Branch locations
    └── about/                         # About us
```

## App Screens & Navigation

| Route | Screen | Auth Required |
|-------|--------|---------------|
| `/` | Home (with bottom nav) | No |
| `/flights/results` | Flight search results | No |
| `/flights/details/:flightId` | Flight details | No |
| `/booking` | Flight booking | Yes |
| `/visa/details` | Visa service details | No |
| `/bank-details` | Bank account details | No |
| `/about-us` | About us | No |
| `/login` | Login | No |
| `/register` | Register | No |

**Bottom Navigation Tabs**: Home, Visa, More (Profile)

## Getting Started

### Prerequisites

- Flutter SDK ^3.10.0
- Dart SDK ^3.10.0
- Android Studio / Xcode
- Firebase project configured (for Google Sign-In)

### Setup

```bash
# Clone and navigate
cd rehman_mobile_app

# Install dependencies
flutter pub get

# Generate code (Riverpod, JSON serializable, Hive adapters)
dart run build_runner build --delete-conflicting-outputs

# Generate app icon
dart run flutter_launcher_icons

# Generate splash screen
dart run flutter_native_splash:create

# Run on device/emulator
flutter run
```

### Firebase Setup (Google Sign-In)

1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`
3. Configure Firebase project in [Firebase Console](https://console.firebase.google.com/)

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Architecture

The app follows **Feature-First Clean Architecture**:

```
feature/
└── presentation/
    ├── screens/      # Full page widgets
    ├── widgets/      # Reusable UI components
    └── providers/    # Riverpod state providers
```

### Network Layer

- **ApiClient** (`api_client.dart`): Handles Laravel website communication with automatic CSRF token management and cookie-based sessions. Auto-retries on 419 (CSRF mismatch).
- **CoreApiClient** (`core_api_client.dart`): Handles Django Core API communication with Basic Auth. Used for bank details, currencies, and branches.

### State Management

Riverpod is used throughout for dependency injection and state management. Key providers:

- `authStateProvider` - Authentication state
- `flightSearchProvider` - Flight search state
- `visaProvider` - Visa services
- `bankProvider` - Bank details
- `currencyProvider` - Currency rates
- `branchProvider` - Branch locations

## Theme

- **Primary Color**: `#1E3A5F` (Deep Blue)
- **Accent Color**: `#00BCD4` (Teal/Cyan)
- **Secondary Color**: `#059669` (Emerald Green - CTAs)
- **Font**: Plus Jakarta Sans (Google Fonts)
- **Design System**: Material 3

## Environment

| Key | Value | Description |
|-----|-------|-------------|
| `baseUrl` | `https://www.rehmantravel.com` | Laravel web API |
| `coreApiBaseUrl` | `http://3.222.113.143:8000` | Django core API |
