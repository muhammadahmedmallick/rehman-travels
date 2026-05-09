import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_endpoints.dart';
import '../services/secure_storage.dart';

class CoreApiClient {
  late final Dio _dio;
  String? _bearerToken;
  bool _isRefreshing = false;

  CoreApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.coreApiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          ...ApiHeaders.defaultHeaders(),
          'Authorization': 'Basic YWhtZWQ6Y2xpY2sxMjM=',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ensure all default headers + auth are on every request
          final defaults = ApiHeaders.defaultHeaders();
          defaults.forEach((key, value) {
            options.headers.putIfAbsent(key, () => value);
          });
          // Use Bearer token if set, otherwise fall back to Basic auth
          if (_bearerToken != null) {
            options.headers['Authorization'] = 'Bearer $_bearerToken';
          } else {
            options.headers['Authorization'] = 'Basic YWhtZWQ6Y2xpY2sxMjM=';
          }
          if (kDebugMode) {
            print('CORE_API[${options.method}] => ${options.uri}');
            print('CORE_API HEADERS => ${options.headers}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('CORE_API[${response.statusCode}] => ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print('CORE_API_ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}');
            print('MESSAGE: ${error.message}');
          }

          // Handle 401 Unauthorized — attempt token refresh
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            _isRefreshing = true;
            try {
              final refreshToken = await SecureStorage.getRefreshToken();
              if (refreshToken != null) {
                // Attempt to refresh the token
                final refreshResponse = await _dio.post<Map<String, dynamic>>(
                  ApiEndpoints.tokenRefresh,
                  data: {'refresh': refreshToken},
                  options: Options(
                    headers: {
                      'Authorization': 'Basic YWhtZWQ6Y2xpY2sxMjM=',
                    },
                  ),
                );

                if (refreshResponse.statusCode == 200 && refreshResponse.data != null) {
                  final newAccessToken = refreshResponse.data!['access'] as String;
                  final newRefreshToken = refreshResponse.data!['refresh'] as String? ?? refreshToken;

                  // Update stored tokens
                  setBearerToken(newAccessToken);
                  await SecureStorage.saveTokens(
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken,
                  );

                  if (kDebugMode) {
                    print('TOKEN_REFRESHED: New access token acquired');
                  }

                  // Retry original request with new token
                  _isRefreshing = false;
                  return handler.resolve(
                    await _dio.request(
                      error.requestOptions.path,
                      data: error.requestOptions.data,
                      queryParameters: error.requestOptions.queryParameters,
                      options: Options(
                        method: error.requestOptions.method,
                        headers: error.requestOptions.headers,
                      ),
                    ),
                  );
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('TOKEN_REFRESH_FAILED: $e');
              }
              // Refresh failed, clear session and proceed with error
              clearBearerToken();
              await SecureStorage.clearAll();
            } finally {
              _isRefreshing = false;
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  void setBearerToken(String token) {
    _bearerToken = token;
  }

  void clearBearerToken() {
    _bearerToken = null;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

final coreApiClientProvider = Provider<CoreApiClient>((ref) => CoreApiClient());
