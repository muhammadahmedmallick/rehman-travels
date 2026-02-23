import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_endpoints.dart';

class CoreApiClient {
  late final Dio _dio;

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
          options.headers['Authorization'] = 'Basic YWhtZWQ6Y2xpY2sxMjM=';
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
        onError: (error, handler) {
          if (kDebugMode) {
            print('CORE_API_ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}');
            print('MESSAGE: ${error.message}');
          }
          return handler.next(error);
        },
      ),
    );
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
