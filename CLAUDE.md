# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Rehman Travels**, a Laravel-based travel booking platform specializing in flight ticketing, hotel bookings, and Umrah packages. The application uses:

- **Backend**: Laravel 10.x (PHP 8.1+)
- **Frontend**: Vue 3 + Inertia.js (SPA-like architecture)
- **Styling**: Tailwind CSS + Bootstrap 5
- **Build Tool**: Vite
- **State Management**: Vuex with persisted state

The application is located in `legacy-app/rehman-travels/` directory.

## Common Development Commands

### Starting Development Environment

```bash
cd legacy-app/rehman-travels

# Start Laravel development server
php artisan serve

# Start Vite dev server (in separate terminal)
npm run dev
```

### Building for Production

```bash
# Build frontend assets
npm run build

# Clear Laravel caches
php artisan cache:clear
php artisan config:cache
php artisan route:cache
```

### Running Tests

```bash
# Run all PHPUnit tests
vendor/bin/phpunit

# Run specific test suite
vendor/bin/phpunit --testsuite=Feature
vendor/bin/phpunit --testsuite=Unit

# Run specific test file
vendor/bin/phpunit tests/Feature/ExampleTest.php
```

### Database Operations

```bash
# Run migrations
php artisan migrate

# Rollback migrations
php artisan migrate:rollback

# Seed database
php artisan db:seed

# Fresh migration with seeding
php artisan migrate:fresh --seed
```

### Code Quality

```bash
# Format code with Laravel Pint
vendor/bin/pint

# Fix specific files
vendor/bin/pint app/Http/Controllers
```

## Architecture

### Application Structure

The codebase follows Laravel's MVC pattern with Inertia.js bridging the frontend:

```
legacy-app/rehman-travels/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Auth/           # Authentication controllers
│   │   │   ├── Backend/        # Admin/backend controllers
│   │   │   └── Website/        # Public-facing controllers
│   │   ├── Middleware/         # HTTP middleware
│   │   └── Requests/           # Form request validation
│   ├── Models/                 # Eloquent models organized by domain
│   │   ├── Hotels/
│   │   ├── Umrah/
│   │   └── Payment/
│   ├── Libraries/              # Custom libraries and integrations
│   │   └── rest_api/           # External API integrations
│   ├── Services/               # Business logic services
│   ├── Events/                 # Event classes
│   └── Listeners/              # Event listeners
├── resources/
│   ├── js/
│   │   ├── Pages/              # Inertia page components (Vue)
│   │   │   └── Website/
│   │   │       └── Ticketing/  # Flight search/booking components
│   │   └── app.js              # Vue app entry point
│   └── views/                  # Blade templates (minimal, mostly for Inertia)
├── routes/
│   ├── web.php                 # Main web routes
│   └── api.php                 # API routes
└── tests/
    ├── Feature/                # Feature tests
    └── Unit/                   # Unit tests
```

### Flight Search System Architecture

The application implements a **chunked flight search** system that queries multiple flight providers (Sabre GDS, AirSial, Airblue) and progressively displays results.

#### Key Components:

1. **Frontend**: `resources/js/Pages/Website/Ticketing/CheapestFareFlight.vue`
   - Implements polling-based search using `airShoppingChunked()` method
   - Single API call with progressive polling (replaces old parallel request pattern)
   - Progress tracking: "Searching X/Y providers..."

2. **Backend Controller**: `app/Http/Controllers/Website/Ticketing/ChunkedFlightSearchController.php`
   - Route: `POST /ticketing/chunked-flight-search`
   - Manages provider queue in cache (5-minute TTL)
   - Returns: `{ searchId, fetchMore, data, processedCount, remainingCount }`

3. **Service Layer**: `app/Libraries/rest_api/AirShoppingProvider.php`
   - Constructs flight search payloads
   - Formats dates, passengers, cabin class
   - Delegates to external middleware API

4. **HTTP Client**: `app/Libraries/rest_api/ServiceProvider.php`
   - Communicates with external API: `http://exaltedrestapiandrehmantravel.local/api/`
   - Bearer token authentication from `storage/app/AccessToken/1182owner.json`

#### Important Implementation Notes:

- **Cache-based state management**: Each search gets a unique `searchId`, state stored in Laravel cache
- **Sequential provider processing**: Backend processes one provider at a time, frontend polls for results
- **Rollback capability**: Old parallel implementation (`airShopping()`) still available in code
- **Provider filtering**: AirSial and Airblue only support Economy class (cabin 'Y')

See `CHUNKED_FLIGHT_SEARCH_IMPLEMENTATION.md` and `TESTING_GUIDE.md` for detailed documentation.

### Data Flow

```
User Action → Vue Component → Inertia Request → Laravel Controller
                                                        ↓
                                                   Service Layer
                                                        ↓
                                                External API/Database
                                                        ↓
                                                Inertia Response
                                                        ↓
                                            Vue Component Updates
```

### External Dependencies

- **Flight Data**: NOT stored in database; real-time queries to external middleware API
- **Providers**: Database table `premium_airlines` (where `airlineType = 'supplier'` and `agentId = 1182`)
- **Authentication**: Bearer token-based authentication with token refresh mechanism

## Vite Configuration

Build output is customized to deploy to a shared hosting structure:

```javascript
// vite.config.js
buildDirectory: "../../public_html/build"
```

Assets are built to `../../public_html/build` relative to the application root. This is a shared hosting deployment pattern.

## Testing Flight Search

```bash
# Start servers
php artisan serve
npm run dev

# Clear cache (important before testing)
php artisan cache:clear

# Navigate to:
http://localhost:8000/ticketing/cheapest-fare-flight

# Test search:
# - Origin: ISB (Islamabad)
# - Destination: KHI (Karachi)
# - Select future date
# - Click "Search"

# Expected behavior:
# - Single POST to /ticketing/chunked-flight-search
# - Progressive polling (3-4 requests total)
# - Progress: "Searching 1/3 providers..." → "2/3" → "3/3"
# - Results appear as providers respond
```

See `TESTING_GUIDE.md` for comprehensive testing procedures, edge cases, and debugging.

## Key Conventions

### Model Organization

Models are organized by business domain in subdirectories:
- `app/Models/Hotels/` - Hotel booking models
- `app/Models/Umrah/` - Umrah package models
- `app/Models/Payment/` - Payment processing models

### Controller Organization

Controllers are grouped by application area:
- `Website/` - Public-facing user controllers
- `Backend/` - Admin/agent portal controllers
- `Auth/` - Authentication controllers
- `Common/` - Shared controllers

### Route Naming

Routes use descriptive names with middleware:

```php
Route::post('/chunked-flight-search',
    'Website\Ticketing\ChunkedFlightSearchController@chunkedFlightSearch')
    ->name('chunkedFlightSearch')
    ->middleware('block.ip');
```

### Inertia Page Components

Vue components in `resources/js/Pages/` map to Inertia responses:

```php
// Controller
return Inertia::render('Website/Ticketing/CheapestFareFlight', [
    'providers' => $providers
]);

// Renders: resources/js/Pages/Website/Ticketing/CheapestFareFlight.vue
```

## Important Files

- `routes/web.php` - Main application routes (25KB, contains all web routes)
- `CHUNKED_FLIGHT_SEARCH_IMPLEMENTATION.md` - Detailed flight search architecture
- `FLIGHT_SEARCH_API_DOCUMENTATION.md` - API flow and data source documentation
- `TESTING_GUIDE.md` - Comprehensive testing procedures
- `vite.config.js` - Frontend build configuration with custom output directory
- `composer.json` - PHP dependencies (includes Inertia, Stripe, DomPDF, Guzzle)
- `package.json` - NPM dependencies (Vue 3, Inertia, Vuex, Tailwind, Bootstrap)

## Cache and Session

The application uses Laravel's cache system extensively for:
- Flight search state management (`flight_search_{searchId}` keys, 5-minute TTL)
- Access token storage (`storage/app/AccessToken/1182owner.json`)

Default cache driver: `file` (can be configured to Redis in `.env`)

## Environment Configuration

Key environment variables to configure:

```env
API_URL=http://exaltedrestapiandrehmantravel.local/api/
CACHE_DRIVER=file
DB_CONNECTION=mysql
# ... standard Laravel env vars
```

## Package Management

### PHP Dependencies

```bash
# Install PHP dependencies
composer install

# Update dependencies
composer update

# Add new package
composer require vendor/package
```

### NPM Dependencies

```bash
# Install NPM dependencies
npm install

# Add new package
npm install package-name
```

## Working with Inertia.js

### Creating New Pages

1. Create Vue component in `resources/js/Pages/`
2. Return from controller using `Inertia::render()`
3. Pass data as second argument (available in component via `$page.props`)

### Accessing Props

```vue
<script>
export default {
    props: {
        providers: Array,
        flights: Object
    }
}
</script>

<!-- Or using Composition API -->
<script setup>
const props = defineProps({
    providers: Array
});

// Access page props
import { usePage } from '@inertiajs/vue3';
const page = usePage();
console.log(page.props.value.providers);
</script>
```

### Making Requests

```javascript
// Using Inertia
import { router } from '@inertiajs/vue3';

router.post('/ticketing/chunked-flight-search', {
    departureCode: 'ISB',
    arrivalCode: 'KHI'
});

// Using custom Service (as seen in CheapestFareFlight.vue)
Service.doFetch("/ticketing/chunked-flight-search", headers, payload);
```
