class ApiEndpoints {
  static const String baseUrl = 'https://www.rehmantravel.com';

  // Flight Endpoints
  static const String flightSearch = '/ticketing/cheapest-fare-airshopping-request';
  static const String airports = '/ticketing/cheapest-fare-airports';
  static const String fareRules = '/ticketing/cheapest-fare-flight-fare-rule-request';
  static const String orderCreate = '/ticketing/cheapest-fare-flight-order-create';
  static const String orderRetrieve = '/ticketing/cheapest-fare-flight-order-retrieve';

  // Page to get CSRF token
  static const String flightSearchPage = '/ticketing/cheapest-fare-flight';

  // Auth Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
}

class ApiHeaders {
  static Map<String, String> defaultHeaders({String? csrfToken}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      if (csrfToken != null) 'X-CSRF-TOKEN': csrfToken,
    };
  }
}
