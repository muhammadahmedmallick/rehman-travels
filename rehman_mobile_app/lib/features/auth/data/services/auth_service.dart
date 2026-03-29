import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/secure_storage.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthService({required ApiClient apiClient}) : _apiClient = apiClient;

  // Email/Password Login
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/accounts/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseModel.fromJson(response.data!);
        
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

  // User Registration
  Future<AuthResponseModel> registerWithEmail({
    required String username,
    required String email,
    required String password,
    String? mobileNo,
    String? phoneNo,
    String? address,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/accounts/auth/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password_confirm': password,
          'mobileno': mobileNo,
          'phoneno': phoneNo,
          'address': address,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        final authResponse = AuthResponseModel.fromJson(response.data!);
        
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
      throw Exception('Registration failed: Invalid response');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Google Sign-In
  Future<AuthResponseModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled');

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) throw Exception('No ID token from Google');

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/accounts/auth/google-login/',
        data: {'token': idToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseModel.fromJson(response.data!);
        
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
  Future<UserModel> getUserProfile({required String accessToken}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/accounts/auth/profile/',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
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
    required String accessToken,
    String? designation,
    String? department,
    String? mobileNo,
    String? phoneNo,
    String? address,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (designation != null) body['designation'] = designation;
      if (department != null) body['department'] = department;
      if (mobileNo != null) body['mobileno'] = mobileNo;
      if (phoneNo != null) body['phoneno'] = phoneNo;
      if (address != null) body['address'] = address;

      final response = await _apiClient.put<Map<String, dynamic>>(
        '/accounts/auth/profile/',
        data: body,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data!);
      }
      throw Exception('Failed to update profile');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Change Password
  Future<void> changePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/accounts/auth/change-password/',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirm': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<void> logout({required String refreshToken}) async {
    try {
      final token = await SecureStorage.getAccessToken();
      await _apiClient.post(
        '/accounts/auth/logout/',
        data: {'refresh': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
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
        '/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccessToken = response.data!['access'] as String;
        
        final currentRefresh = await SecureStorage.getRefreshToken();
        await SecureStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: currentRefresh ?? refreshToken,
        );

        return newAccessToken;
      }
      throw Exception('Token refresh failed');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }

    if (error is DioException) {
      final message = error.response?.data['detail'] ?? 
                      error.response?.data['error'] ?? 
                      error.message ?? 
                      'Unknown error occurred';
      return Exception(message);
    }

    return Exception(error.toString());
  }
}
