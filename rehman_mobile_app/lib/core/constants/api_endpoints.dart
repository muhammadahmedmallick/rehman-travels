class ApiEndpoints {
  static const String baseUrl = 'https://www.rehmantravel.com';
  static const String coreApiBaseUrl = 'http://3.222.113.143:8000';

  // Flight Endpoints
  static const String flightSearch = '/ticketing/cheapest-fare-airshopping-request';
  static const String airports = '/ticketing/cheapest-fare-airports';
  static const String fareRules = '/ticketing/cheapest-fare-flight-fare-rule-request';
  static const String orderCreate = '/ticketing/cheapest-fare-flight-order-create';
  static const String orderRetrieve = '/ticketing/cheapest-fare-flight-order-retrieve';

  // Page to get CSRF token
  static const String flightSearchPage = '/ticketing/cheapest-fare-flight';

  // Auth Endpoints (Mobile API - Django REST API)
  static const String authLogin = '/api/mobile/auth/login/';
  static const String authRegister = '/api/mobile/auth/register/';
  static const String authProfile = '/api/mobile/auth/profile/';
  static const String tokenRefresh = '/api/mobile/auth/refresh/';

  // Accounts Endpoints (Legacy - for backward compatibility)
  static const String accountsLogin = '/api/accounts/auth/login/';
  static const String accountsRegister = '/api/accounts/auth/register/';
  static const String accountsProfile = '/api/accounts/auth/profile/';
  static const String authChangePassword = '/api/accounts/auth/change-password/';
  static const String authGoogleLogin = '/api/accounts/auth/google-login/';
  static const String authLogout = '/api/accounts/auth/logout/';

  // Ticketing API Endpoints (Django)
  static const String flightProviders = '/api/ticketing/flight-providers/';

  // Core API Endpoints
  static const String bankDetails = '/api/core/bank-details/';
  static const String currencies = '/api/core/currencies/';
  static const String branches = '/api/core/branches/';
  static const String airportSearch = '/api/core/airports/search/';

  // CMS API Endpoints
  static const String visaList = '/api/cms/visa/';
  static const String visaByUrl = '/api/cms/visa/by-url/';
  static const String homeDestinations = '/api/cms/home-destinations/';
  static const String pakTourList = '/api/cms/pak-tour/';
  static const String pakTourByUrl = '/api/cms/pak-tour/by-url/';

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
