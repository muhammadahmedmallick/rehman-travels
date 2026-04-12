import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/menu_models.dart';
import '../models/calculator_models.dart';
import '../models/price_models.dart';

class UmrahApiService {
  late Dio _dio;

  UmrahApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        contentType: 'application/json',
      ),
    );

    // Add error interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          print('API Error: $error');
          return handler.next(error);
        },
      ),
    );
  }

  /// Get Umrah dropdown menu
  Future<UmrahMenu> getMenu() async {
    try {
      final response = await _dio.get(ApiConfig.menuEndpoint);
      return UmrahMenu.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get calculator initialization data (hotels, transport, visas, currencies)
  Future<CalculatorInitData> getCalculatorInit() async {
    try {
      final response = await _dio.get(ApiConfig.calculatorInitEndpoint);
      return CalculatorInitData.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Calculate package price without creating booking
  Future<PriceBreakdown> calculatePrice(BookingRequest request) async {
    try {
      final response = await _dio.post(
        ApiConfig.calculatePriceEndpoint,
        data: request.toJson(),
      );
      return PriceBreakdown.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create booking with customer information
  Future<BookingResponse> createBooking(BookingRequest request) async {
    try {
      final response = await _dio.post(
        ApiConfig.createBookingEndpoint,
        data: request.toJson(),
      );
      return BookingResponse.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get package content by URL slug
  Future<PackageContent> getPackageContent(String slug) async {
    try {
      final response = await _dio.get(
        ApiConfig.packageDetailEndpoint,
        queryParameters: {'url': 'umrah-packages/$slug'},
      );
      return PackageContent.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle errors consistently
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Request timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Response timeout. Please try again.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 400) {
            return 'Invalid request. Please check your input.';
          } else if (statusCode == 404) {
            return 'Resource not found.';
          } else if (statusCode == 500) {
            return 'Server error. Please try again later.';
          }
          return 'Error: HTTP $statusCode';
        case DioExceptionType.unknown:
          return 'Network error. Please check your internet connection.';
        default:
          return 'An error occurred. Please try again.';
      }
    }
    return error.toString();
  }
}
