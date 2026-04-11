import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/core_api_client.dart';
import '../../../../core/services/secure_storage.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthService {
  final CoreApiClient _apiClient;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthService({required CoreApiClient apiClient}) : _apiClient = apiClient;

  // Email/Password Login
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseModel.fromJson(response.data!);

        // Set bearer token on the client for subsequent requests
        _apiClient.setBearerToken(authResponse.access);

        // Save tokens and user data
        await SecureStorage.saveTokens(
          accessToken: authResponse.access,
          refreshToken: authResponse.refresh,
        );
        await SecureStorage.saveUserData(
          userData: authResponse.user.toJson().toString(),
        );
        await SecureStorage.saveUserId(userId: authResponse.user.id);

        return authResponse;
      }
      throw Exception('Login failed: Invalid response');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // User Registration (mobile register doesn't return tokens, so login after)
  Future<AuthResponseModel> registerWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final registerResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.authRegister,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (registerResponse.statusCode == 200 || registerResponse.statusCode == 201) {
        // Mobile register doesn't return tokens, so login immediately
        return await loginWithEmail(email: email, password: password);
      }
      throw Exception('Registration failed: Invalid response');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Google Sign-In
  Future<AuthResponseModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final idToken = googleUser.authentication.idToken;

      if (idToken == null) throw Exception('No ID token from Google');

      // Try mobile login with Google token
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.authLogin,
        data: {'token': idToken, 'auth_type': 'google'},
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseModel.fromJson(response.data!);

        _apiClient.setBearerToken(authResponse.access);

        await SecureStorage.saveTokens(
          accessToken: authResponse.access,
          refreshToken: authResponse.refresh,
        );
        await SecureStorage.saveUserData(
          userData: authResponse.user.toJson().toString(),
        );
        await SecureStorage.saveUserId(userId: authResponse.user.id);

        return authResponse;
      }
      throw Exception('Google login failed on backend');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get User Profile
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.authProfile,
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data!);
      }
      throw Exception('Failed to fetch profile');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Update User Profile
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (firstName != null) body['first_name'] = firstName;
      if (lastName != null) body['last_name'] = lastName;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;

      final response = await _apiClient.put<Map<String, dynamic>>(
        ApiEndpoints.authProfile,
        data: body,
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data!);
      }
      throw Exception('Failed to update profile');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _apiClient.clearBearerToken();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      await SecureStorage.clearAll();
      await _googleSignIn.signOut();
    }
  }

  // Refresh Token
  Future<String> refreshAccessToken({required String refreshToken}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data!['access'] as String;
        final newRefreshToken = response.data!['refresh'] as String? ?? refreshToken;

        _apiClient.setBearerToken(newAccessToken);

        await SecureStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        return newAccessToken;
      }
      throw Exception('Token refresh failed');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Restore session from stored tokens
  Future<bool> restoreSession() async {
    final accessToken = await SecureStorage.getAccessToken();
    if (accessToken != null) {
      _apiClient.setBearerToken(accessToken);
      return true;
    }
    return false;
  }

  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }

    if (error is DioException) {
      final data = error.response?.data;
      String message = 'Unknown error occurred';
      if (data is Map) {
        message = data['detail'] ??
            data['error'] ??
            (data['non_field_errors'] is List
                ? (data['non_field_errors'] as List).first
                : null) ??
            error.message ??
            message;
      }
      return Exception(message);
    }

    return Exception(error.toString());
  }
}
