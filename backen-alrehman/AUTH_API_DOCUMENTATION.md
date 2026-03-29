# Authentication API Documentation

## Overview

This document describes the complete authentication system for Rehman Travels Django backend, including traditional login/registration and Google OAuth2 integration for Flutter mobile apps.

## Base URL

```
http://localhost:8000/api
```

---

## 1. Authentication Endpoints

### 1.1 User Login

**Endpoint:** `POST /accounts/auth/login/`

**Description:** Authenticate user with email and password. Returns JWT tokens and user details.

**Request Body:**
```json
{
    "email": "user@example.com",
    "password": "securepassword123"
}
```

**Success Response (200):**
```json
{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "user": {
        "id": 1,
        "username": "john_doe",
        "email": "user@example.com",
        "designation": "Travel Agent",
        "department": "Sales",
        "user_type": "user",
        "account_status": "active",
        "mobile_no": "+923001234567",
        "phone_no": "+923001234567",
        "address": "123 Main St, City, Country",
        "created_at": "2024-01-15T10:30:00Z"
    }
}
```

**Error Response (401):**
```json
{
    "detail": "Invalid email or password."
}
```

**Error Response (401) - Account Inactive:**
```json
{
    "detail": "This account is not active."
}
```

---

### 1.2 User Registration

**Endpoint:** `POST /accounts/auth/register/`

**Description:** Create a new user account. Returns JWT tokens and user details.

**Request Body:**
```json
{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "securepassword123",
    "password_confirm": "securepassword123",
    "mobileno": "+923001234567",
    "phoneno": "+923001234567",
    "address": "123 Main St, City, Country",
    "agentid": 1
}
```

**Success Response (201):**
```json
{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "user": {
        "id": 1,
        "username": "john_doe",
        "email": "john@example.com",
        "mobile_no": "+923001234567",
        "phone_no": "+923001234567",
        "address": "123 Main St, City, Country",
        "created_at": "2024-01-15T10:30:00Z"
    }
}
```

**Error Response (400) - Validation:**
```json
{
    "username": ["This field is required."],
    "password": ["Passwords do not match."],
    "email": ["This email already exists."]
}
```

---

### 1.3 Google OAuth2 Login

**Endpoint:** `POST /accounts/auth/google-login/`

**Description:** Authenticate user with Google ID token from Flutter app. Creates account if new user.

**Request Body:**
```json
{
    "token": "google_id_token_from_flutter_app"
}
```

**Success Response (200):**
```json
{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "user": {
        "id": 1,
        "username": "john_doe",
        "email": "john@example.com",
        "designation": "",
        "department": "",
        "user_type": "user",
        "account_status": "active",
        "mobile_no": "",
        "phone_no": "",
        "address": "",
        "created_at": "2024-01-15T10:30:00Z",
        "google_picture": "https://lh3.googleusercontent.com/..."
    }
}
```

**Error Response (401):**
```json
{
    "detail": "Invalid Google token."
}
```

---

### 1.4 User Profile - Get

**Endpoint:** `GET /accounts/auth/profile/`

**Description:** Retrieve the current authenticated user's profile.

**Headers:**
```
Authorization: Bearer {access_token}
```

**Success Response (200):**
```json
{
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "designation": "Travel Agent",
    "department": "Sales",
    "agentid": 1,
    "branchid": 1,
    "accountid": 1,
    "usertype": "user",
    "accountstatus": "active",
    "mobileno": "+923001234567",
    "phoneno": "+923001234567",
    "address": "123 Main St, City, Country",
    "creditlimit": 50000,
    "currentcreditlimit": 35000,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-16T15:45:00Z"
}
```

**Error Response (401):**
```json
{
    "detail": "Authentication credentials were not provided."
}
```

---

### 1.5 User Profile - Update

**Endpoint:** `PUT /accounts/auth/profile/`

**Description:** Update the current authenticated user's profile. Only allowed fields: designation, department, mobileno, phoneno, address.

**Headers:**
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request Body:**
```json
{
    "designation": "Senior Travel Agent",
    "department": "Premium Sales",
    "mobileno": "+923001234567",
    "phoneno": "+923001234567",
    "address": "456 Oak Ave, New City, Country"
}
```

**Success Response (200):**
```json
{
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "designation": "Senior Travel Agent",
    "department": "Premium Sales",
    "agentid": 1,
    "branchid": 1,
    "accountid": 1,
    "usertype": "user",
    "accountstatus": "active",
    "mobileno": "+923001234567",
    "phoneno": "+923001234567",
    "address": "456 Oak Ave, New City, Country",
    "creditlimit": 50000,
    "currentcreditlimit": 35000,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-17T12:00:00Z"
}
```

---

### 1.6 Change Password

**Endpoint:** `POST /accounts/auth/change-password/`

**Description:** Change password for authenticated user.

**Headers:**
```
Authorization: Bearer {access_token}
```

**Request Body:**
```json
{
    "old_password": "current_password",
    "new_password": "new_secure_password123",
    "new_password_confirm": "new_secure_password123"
}
```

**Success Response (200):**
```json
{
    "detail": "Password changed successfully."
}
```

**Error Response (400) - Incorrect Old Password:**
```json
{
    "old_password": "Incorrect old password."
}
```

**Error Response (400) - Password Mismatch:**
```json
{
    "new_password": "Passwords do not match."
}
```

**Error Response (400) - Weak Password:**
```json
{
    "new_password": "Password must be at least 8 characters long."
}
```

---

### 1.7 Logout

**Endpoint:** `POST /accounts/auth/logout/`

**Description:** Blacklist the refresh token to logout user.

**Headers:**
```
Authorization: Bearer {access_token}
```

**Request Body:**
```json
{
    "refresh": "refresh_token_here"
}
```

**Success Response (200):**
```json
{
    "detail": "Successfully logged out."
}
```

**Error Response (400):**
```json
{
    "detail": "Refresh token is required."
}
```

---

## 2. Token Management

### 2.1 Token Refresh

**Endpoint:** `POST /token/refresh/`

**Description:** Refresh expired access token using refresh token.

**Request Body:**
```json
{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

**Success Response (200):**
```json
{
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

---

### 2.2 JWT Token Structure

Access tokens contain the following claims:
- `user_id`: User ID
- `email`: User email
- `username`: Username
- `user_type`: Type of user (user/agent)
- `exp`: Token expiration time
- `iat`: Token issued time

**Token Lifetimes:**
- Access Token: 5 hours
- Refresh Token: 24 hours

---

## 3. Authentication Header

All authenticated endpoints require the following header:

```
Authorization: Bearer {access_token}
```

Example:
```
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjcwODUyMDAwLCJpYXQiOjE2NzA4MjAwMDB9...
```

---

## 4. HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request / Validation Error |
| 401 | Unauthorized / Invalid Credentials |
| 403 | Forbidden |
| 404 | Not Found |
| 405 | Method Not Allowed |
| 500 | Server Error |

---

## 5. Error Handling

### Common Error Response Format:
```json
{
    "detail": "Error message here"
}
```

### Validation Error Response Format:
```json
{
    "field_name": ["Error message for this field"],
    "another_field": ["Multiple errors possible"]
}
```

---

## 6. Google OAuth2 Setup for Flutter

### Backend Configuration

1. **Set Google Client ID in Environment:**
   ```
   GOOGLE_OAUTH_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
   ```

2. **Get Your Google Client ID:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create or select a project
   - Enable Google+ API
   - Create OAuth2 credentials (Web application)
   - Copy the Client ID

### Flutter Implementation Steps

See Flutter Frontend Plan in section below.

---

## 7. Security Considerations

- **Password Storage:** Passwords are hashed using Django's PBKDF2 algorithm
- **CORS:** Only allowed origins can access the API
- **Token Rotation:** Refresh tokens are rotated on each refresh
- **Token Blacklist:** Tokens can be blacklisted on logout
- **HTTPS:** Always use HTTPS in production
- **Token Expiry:** Access tokens expire in 5 hours for security

---

## 8. API Testing

### Using cURL

**Login:**
```bash
curl -X POST http://localhost:8000/api/accounts/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword123"
  }'
```

**Register:**
```bash
curl -X POST http://localhost:8000/api/accounts/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "securepassword123",
    "password_confirm": "securepassword123",
    "mobileno": "+923001234567",
    "phoneno": "+923001234567",
    "address": "123 Main St"
  }'
```

**Get Profile (with token):**
```bash
curl -X GET http://localhost:8000/api/accounts/auth/profile/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Change Password:**
```bash
curl -X POST http://localhost:8000/api/accounts/auth/change-password/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "old_password": "current_password",
    "new_password": "new_password123",
    "new_password_confirm": "new_password123"
  }'
```

**Google Login:**
```bash
curl -X POST http://localhost:8000/api/accounts/auth/google-login/ \
  -H "Content-Type: application/json" \
  -d '{
    "token": "google_id_token_here"
  }'
```

### Using Postman

1. Import the endpoints listed above
2. Set up environment variables:
   - `base_url`: http://localhost:8000/api
   - `access_token`: Save from login response
   - `refresh_token`: Save from login response

---

## 9. Flutter Frontend Implementation Plan

### 9.1 Project Setup

```bash
flutter create rehman_travels
cd rehman_travels

# Add dependencies
flutter pub add http
flutter pub add google_sign_in
flutter pub add shared_preferences
flutter pub add provider
```

### 9.2 Dependencies in pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  google_sign_in: ^6.1.0
  shared_preferences: ^2.2.0
  provider: ^6.0.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
```

### 9.3 Architecture Overview

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── user.dart                      # User model
│   ├── auth_response.dart             # Auth API response model
│   └── exceptions.dart                # Custom exceptions
├── services/                          # API services
│   ├── auth_service.dart              # Auth API calls
│   ├── secure_storage.dart            # Token storage
│   └── http_client.dart               # HTTP wrapper with auth header
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart             # Auth state
│   └── user_provider.dart             # User state
├── screens/                           # UI screens
│   ├── login_screen.dart              # Login page
│   ├── register_screen.dart           # Registration page
│   ├── home_screen.dart               # Authenticated home
│   ├── profile_screen.dart            # User profile
│   └── splash_screen.dart             # App splash
└── widgets/                           # Reusable widgets
    ├── custom_button.dart
    ├── custom_textfield.dart
    └── loading_dialog.dart
```

### 9.4 Core Models

**User Model (lib/models/user.dart):**
```dart
class User {
  final int id;
  final String username;
  final String email;
  final String? designation;
  final String? department;
  final String userType;
  final String accountStatus;
  final String? mobileNo;
  final String? phoneNo;
  final String? address;
  final DateTime createdAt;
  final String? googlePicture;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.designation,
    this.department,
    required this.userType,
    required this.accountStatus,
    this.mobileNo,
    this.phoneNo,
    this.address,
    required this.createdAt,
    this.googlePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      designation: json['designation'],
      department: json['department'],
      userType: json['user_type'],
      accountStatus: json['account_status'],
      mobileNo: json['mobile_no'],
      phoneNo: json['phone_no'],
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
      googlePicture: json['google_picture'],
    );
  }
}
```

**Auth Response Model (lib/models/auth_response.dart):**
```dart
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access'],
      refreshToken: json['refresh'],
      user: User.fromJson(json['user']),
    );
  }
}
```

### 9.5 Services

**Secure Storage Service (lib/services/secure_storage.dart):**
```dart
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> saveUser(String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userJson);
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
```

**Auth Service (lib/services/auth_service.dart):**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const String baseUrl = 'http://YOUR_SERVER_IP:8000/api';
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Email/Password Login
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Registration
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String? mobileNo,
    String? phoneNo,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
          'mobileno': mobileNo,
          'phoneno': phoneNo,
          'address': address,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        final errors = jsonDecode(response.body);
        throw Exception('Registration failed: ${errors.toString()}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Google Sign-In
  Future<AuthResponse> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception('No ID token from Google');

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/google-login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        throw Exception('Google login failed on backend');
      }
    } catch (e) {
      throw Exception('Google login error: $e');
    }
  }

  // Logout
  Future<void> logout(String refreshToken) async {
    try {
      final accessToken = await SecureStorage.getAccessToken();
      await http.post(
        Uri.parse('$baseUrl/accounts/auth/logout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refresh': refreshToken}),
      );
      await SecureStorage.clearAll();
      await googleSignIn.signOut();
    } catch (e) {
      // Clear local data even if logout fails
      await SecureStorage.clearAll();
    }
  }

  // Get User Profile
  Future<User> getProfile(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/auth/profile/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }

  // Update Profile
  Future<User> updateProfile({
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

      final response = await http.put(
        Uri.parse('$baseUrl/accounts/auth/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Profile update error: $e');
    }
  }

  // Change Password
  Future<void> changePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/change-password/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirm': newPasswordConfirm,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error.toString());
      }
    } catch (e) {
      throw Exception('Password change error: $e');
    }
  }

  // Refresh Token
  Future<String> refreshAccessToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await SecureStorage.saveTokens(data['access'], refreshToken);
        return data['access'];
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh error: $e');
    }
  }
}
```

**HTTP Client Wrapper (lib/services/http_client.dart):**
```dart
import 'package:http/http.dart' as http;

class AuthenticatedHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final accessToken = await SecureStorage.getAccessToken();
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    return super.send(request);
  }
}
```

### 9.6 State Management (Provider)

**Auth Provider (lib/providers/auth_provider.dart):**
```dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null && _accessToken != null;

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _user = response.user;
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;

      await SecureStorage.saveTokens(response.accessToken, response.refreshToken);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? mobileNo,
    String? phoneNo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        username: username,
        email: email,
        password: password,
        passwordConfirm: password,
        mobileNo: mobileNo,
        phoneNo: phoneNo,
      );
      _user = response.user;
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;

      await SecureStorage.saveTokens(response.accessToken, response.refreshToken);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Google Login
  Future<bool> googleLogin() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.googleLogin();
      _user = response.user;
      _accessToken = response.accessToken;
      _refreshToken = response.refreshToken;

      await SecureStorage.saveTokens(response.accessToken, response.refreshToken);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    if (_refreshToken != null) {
      await _authService.logout(_refreshToken!);
    }
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  // Check if logged in on app start
  Future<bool> checkLoginStatus() async {
    final isLoggedIn = await SecureStorage.isLoggedIn();
    if (isLoggedIn) {
      _accessToken = await SecureStorage.getAccessToken();
      _refreshToken = await SecureStorage.getRefreshToken();
      notifyListeners();
      return true;
    }
    return false;
  }
}
```

### 9.7 Login Screen Example

**Login Screen (lib/screens/login_screen.dart):**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rehman Travels Login')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                if (authProvider.error != null)
                  Text(
                    authProvider.error!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            final success = await authProvider.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (success) {
                              Navigator.of(context).pushReplacementNamed('/home');
                            }
                          },
                    child: authProvider.isLoading
                        ? CircularProgressIndicator()
                        : Text('Login'),
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Image.network(
                      'https://www.gstatic.com/firebaseapp/images/logo-144.png',
                      height: 24,
                    ),
                    label: Text('Login with Google'),
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            final success = await authProvider.googleLogin();
                            if (success) {
                              Navigator.of(context).pushReplacementNamed('/home');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text('Don\'t have an account? Register here'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

### 9.8 Main App Setup

**Main (lib/main.dart):**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Rehman Travels',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
```

### 9.9 Important Implementation Notes

1. **Token Management:**
   - Always store tokens in SharedPreferences
   - Check token validity before making requests
   - Implement automatic token refresh when access token expires

2. **Error Handling:**
   - Handle network errors gracefully
   - Show meaningful error messages to users
   - Implement retry logic for failed requests

3. **Google Sign-In Configuration:**
   - For Android: Add SHA-1 fingerprint to Firebase Console
   - For iOS: Configure OAuth consent screen
   - Use Web Client ID for iOS Google Sign-In

4. **Security Best Practices:**
   - Never hardcode API URLs - use environment configuration
   - Always validate SSL certificates in production
   - Implement request timeouts
   - Use HTTPS only in production

5. **Testing:**
   - Test on real devices (not just emulator)
   - Test with slow network conditions
   - Test token expiry and refresh flow
   - Test logout and clearing local data

---

## 10. Next Steps

1. **Backend:**
   - Run `pip install -r requirements.txt` to install new dependencies
   - Test all endpoints using provided cURL examples
   - Set up environment variables (especially GOOGLE_OAUTH_CLIENT_ID)

2. **Frontend:**
   - Follow the Flutter implementation plan above
   - Test each authentication flow
   - Implement proper error handling and user feedback
   - Add token refresh interceptor to HTTP client

3. **Deployment:**
   - Use HTTPS in production
   - Set proper CORS origins
   - Configure environment variables securely
   - Monitor authentication logs

---

## 11. Support & Troubleshooting

### Common Issues

**Issue:** "CORS error when accessing API from Flutter"
- **Solution:** Ensure CORS_ALLOWED_ORIGINS includes your Flutter app origin

**Issue:** "Google token verification fails"
- **Solution:** Verify GOOGLE_OAUTH_CLIENT_ID is correct and matches Flutter config

**Issue:** "Token expired error on every request"
- **Solution:** Implement automatic token refresh in HTTP client

**Issue:** "Password validation errors"
- **Solution:** Ensure new password is at least 8 characters and matches confirmation

---

**Last Updated:** January 2024
**API Version:** v1
**Backend Framework:** Django REST Framework 3.14.0
**Frontend Framework:** Flutter

