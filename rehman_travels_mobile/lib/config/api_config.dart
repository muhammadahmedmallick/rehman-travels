class ApiConfig {
  // API Base URL - Change this for production
  static const String baseUrl = 'http://localhost:8000/api/umrah';

  // Endpoints
  static const String menuEndpoint = '/calculator/menu/';
  static const String calculatorInitEndpoint = '/calculator/init/';
  static const String calculatePriceEndpoint = '/calculator/calculate/';
  static const String createBookingEndpoint = '/calculator/book/';
  static const String packageDetailEndpoint = '/packages/by-url/';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
