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

  // Auth Endpoints (Django REST API)
  static const String authLogin = '/api/accounts/auth/login/';
  static const String authRegister = '/api/accounts/auth/register/';
  static const String authGoogleLogin = '/api/accounts/auth/google-login/';
  static const String authProfile = '/api/accounts/auth/profile/';
  static const String authChangePassword = '/api/accounts/auth/change-password/';
  static const String authLogout = '/api/accounts/auth/logout/';
  static const String tokenRefresh = '/api/token/refresh/';

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
}

class ApiHeaders {
  static Map<String, String> defaultHeaders({String? csrfToken}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': 'csrftoken=yEAtAJyHfNKLoRbq1rETDeGWCdEx0gTG; sessionid=270bvf9os2w7lprlaf3iayt66hpyi0gw',
    };
  }
}
