import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final CookieJar _cookieJar = CookieJar();
  String? _csrfToken;
  bool _isInitialized = false;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );

    // Add cookie manager for session handling
    _dio.interceptors.add(CookieManager(_cookieJar));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_csrfToken != null) {
            options.headers['X-CSRF-TOKEN'] = _csrfToken;
          }
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
            print('HEADERS: ${options.headers}');
            print('DATA: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            print('MESSAGE: ${error.message}');
            print('RESPONSE: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Initialize session by fetching CSRF token from the website
  Future<void> initializeSession() async {
    if (_isInitialized) return;

    try {
      // First, hit the main page to get cookies
      final htmlResponse = await _dio.get(
        ApiEndpoints.flightSearchPage,
        options: Options(
          headers: {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15',
          },
        ),
      );

      // Extract CSRF token from HTML meta tag
      final html = htmlResponse.data.toString();
      final csrfMatch = RegExp(r'<meta name="csrf-token" content="([^"]+)"').firstMatch(html);

      if (csrfMatch != null) {
        _csrfToken = csrfMatch.group(1);
        _isInitialized = true;
        if (kDebugMode) {
          print('CSRF Token fetched: ${_csrfToken?.substring(0, 20)}...');
        }
      } else {
        if (kDebugMode) {
          print('CSRF token not found in HTML response');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize session: $e');
      }
      rethrow;
    }
  }

  /// Ensure session is initialized before making API calls
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initializeSession();
    }
  }

  void setCsrfToken(String token) {
    _csrfToken = token;
    _isInitialized = true;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresSession = false,
  }) async {
    try {
      if (requiresSession) {
        await _ensureInitialized();
      }
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      // Always ensure session is initialized for POST requests
      await _ensureInitialized();

      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // If we get 419 (CSRF token mismatch), try to refresh session
      if (e.response?.statusCode == 419) {
        _isInitialized = false;
        await _ensureInitialized();

        // Retry the request
        return await _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      }
      throw _handleError(e);
    }
  }

  /// POST request with additional headers (e.g., action-type for provider)
  Future<Response<T>> postWithHeader<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      // Always ensure session is initialized for POST requests
      await _ensureInitialized();

      // Merge extra headers with CSRF token
      final headers = <String, dynamic>{
        if (_csrfToken != null) 'X-CSRF-TOKEN': _csrfToken,
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15',
        ...?extraHeaders,
      };

      final options = Options(headers: headers);

      if (kDebugMode) {
        print('POST WITH HEADERS: $headers');
      }

      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // If we get 419 (CSRF token mismatch), try to refresh session
      if (e.response?.statusCode == 419) {
        _isInitialized = false;
        await _ensureInitialized();

        final headers = <String, dynamic>{
          if (_csrfToken != null) 'X-CSRF-TOKEN': _csrfToken,
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15',
          ...?extraHeaders,
        };

        final options = Options(headers: headers);

        // Retry the request
        return await _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      }
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _ensureInitialized();
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return ApiException(
          statusCode: 400,
          message: 'Bad Request',
        );
      case 401:
        return ApiException(
          statusCode: 401,
          message: 'Unauthorized',
        );
      case 404:
        return ApiException(
          statusCode: 404,
          message: 'Not Found',
        );
      case 419:
        return ApiException(
          statusCode: 419,
          message: 'Session Expired - CSRF Token Mismatch',
        );
      case 422:
        return ApiException(
          statusCode: 422,
          message: 'Validation Error',
        );
      case 429:
        return ApiException(
          statusCode: 429,
          message: 'Too Many Requests',
        );
      case 500:
        return ApiException(
          statusCode: 500,
          message: 'Server Error',
        );
      default:
        return ApiException(
          statusCode: error.response?.statusCode ?? 0,
          message: error.message ?? 'Unknown Error',
        );
    }
  }
}
