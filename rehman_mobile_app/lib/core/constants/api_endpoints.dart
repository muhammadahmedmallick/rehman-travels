class ApiEndpoints {
  static const String baseUrl = 'https://www.rehmantravel.com';
  static const String coreApiBaseUrl = 'http://3.222.113.143:8000';

  // Flight Endpoints
  static const String flightSearch = '/ticketing/cheapest-fare-airshopping-request';
  static const String airports = '/ticketing/cheapest-fare-airports';
  static const String fareRules = '/ticketing/cheapest-fare-flight-fare-rule-request';
  static const String orderCreate = '/ticketing/cheapest-fare-flight-order-create-request';
  static const String orderRetrieve = '/ticketing/cheapest-fare-flight-order-retrieve';

  // Page to get CSRF token
  static const String flightSearchPage = '/ticketing/cheapest-fare-flight';

  // Exalted System External API
  static const String exaltedBaseUrl = 'https://exaltedrestapi.exaltedsystem.com/api';
  static const String exaltedAuth = '/authenticate';
  static const String exaltedCurrency = '/currency';
  static const String exaltedSector = '/Sector';
  static const String exaltedFareRule = '/orderFareRule';
  static const String exaltedRevalidate = '/revalidate-flight';
  static const String exaltedAncillary = '/ancillary';
  static const String exaltedOrderCreate = '/orderCreate';
  static const String exaltedOrderRetrieve = '/orderRetrieve';

  // Auth Endpoints (Mobile API)
  static const String authLogin = '/api/mobile/auth/login/';
  static const String authRegister = '/api/mobile/auth/register/';
  static const String authProfile = '/api/mobile/auth/profile/';
  static const String tokenRefresh = '/api/mobile/auth/refresh/';

  // Payments API Endpoints
  static const String payments = '/api/payments/payments/';
  static const String markupAndMarkdowns = '/api/payments/markup-and-markdowns/';

  // APG (Alfa Payment Gateway) Endpoints — all on coreApiBaseUrl
  // 1. Call BEFORE launching payUrl to register a pending transaction in DB.
  static const String apgInitiate = '/api/payments/apg/initiate/';
  // 2. Poll AFTER user returns from browser to get paid / failed status.
  //    Usage: apgStatus('ABC123') → '/api/payments/apg/status/ABC123/'
  static String apgStatus(String transactionRef) =>
      '/api/payments/apg/status/$transactionRef/';
  // 3. Return URL configured in APG merchant portal (Django handles redirect)
  static const String apgReturn = '/api/payments/apg/return/';
  // 4. IPN Listener configured in APG merchant portal (Django handles webhook)
  static const String apgIpn = '/api/payments/apg/ipn/';

  // Validation Engine Endpoints — all on coreApiBaseUrl
  // POST  { data: { type: "process_payment", fields: { ... } } }
  //       → 200 { valid: true } | 422 { valid: false, errors: { field: [...] } }
  static const String validate = '/api/validation/validate/';
  // GET   schema metadata (rule list, descriptions) — useful for debug / hints
  static String validationSchema(String schemaType) =>
      '/api/validation/schema/$schemaType/';

  // Ticketing API Endpoints (Django)
  static const String flightProviders = '/api/ticketing/flight-providers/';

  // Core API Endpoints
  static const String bankDetails = '/api/core/bank-details/';
  static const String currencies = '/api/core/currencies/';
  static const String branches = '/api/core/branches/';
  static const String airportSearch = '/api/core/airports/search/';

  // App Config
  static const String appConfig = '/api/core/app-config/';

  // Mobile Visa API Endpoints (Django)
  // Types include nested variants + per-variant rules in the same
  // response, so the home + details screens only need this one call.
  static const String mobileVisaTypes = '/api/mobile/visas/types/';
  static String mobileVisaTypeDetail(int id) => '/api/mobile/visas/types/$id/';

  // CMS API Endpoints
  static const String homeDestinations = '/api/cms/home-destinations/';
  static const String pakTourList = '/api/cms/pak-tour/';
  static const String pakTourByUrl = '/api/cms/pak-tour/by-url/';

  // Umrah API Endpoints
  static const String umrahPackageList = '/api/umrah/packages/';
  static const String umrahPackageByUrl = '/api/umrah/packages/by-url/';

  // Umrah Calculator Endpoints
  static const String umrahCalculatorInit = '/api/umrah/calculator/init/';
  static const String umrahCalculatorCalculate = '/api/umrah/calculator/calculate/';

  // Mobile Packages API
  static const String mobilePackages = '/api/mobile/packages/';
  static String mobilePackageDetail(String slug) => '/api/mobile/packages/$slug/';
  static String mobilePackageWithSuggestions(String slug) => '/api/mobile/packages/$slug/?suggestions=true';

  // Query Parameters (for pagination)
  // Usage: visaList + '?limit=10&offset=0'
  // Or use buildUrl() helper
  static String withPagination(String endpoint, {int limit = 10, int offset = 0}) {
    return '$endpoint?limit=$limit&offset=$offset';
  }

  static String withSearch(String endpoint, String query) {
    return '$endpoint?search=$query';
  }

  static String withOrdering(String endpoint, String field) {
    return '$endpoint?ordering=$field';
  }
}

class ApiHeaders {
  // Default headers for public endpoints (no authentication required)
  static Map<String, String> defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Headers for authenticated endpoints (requires JWT token)
  static Map<String, String> authenticatedHeaders(String accessToken) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  // Headers for requests that need CSRF token (legacy)
  static Map<String, String> csrfHeaders({String? csrfToken}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (csrfToken != null) 'X-CSRFToken': csrfToken,
    };
  }
}
