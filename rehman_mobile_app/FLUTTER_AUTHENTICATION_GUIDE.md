# Flutter Authentication Implementation Guide

## Overview

This guide explains how to integrate the Django REST authentication system with your Flutter mobile app. The implementation uses **Riverpod** for state management and **Dio** for HTTP requests.

---

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart          # Updated with Django API endpoints
│   ├── network/
│   │   ├── api_client.dart             # Existing Dio client
│   │   ├── core_api_client.dart        # Provider for API client
│   │   └── api_exceptions.dart         # Error handling
│   └── services/
│       └── secure_storage.dart         # Token storage (NEW)
│
├── features/
│   └── auth/
│       ├── data/
│       │   ├── models/
│       │   │   ├── user_model.dart           # User model with JSON serialization (NEW)
│       │   │   └── auth_response_model.dart  # Auth response model (NEW)
│       │   └── services/
│       │       └── auth_service.dart         # Django API integration (NEW)
│       │
│       └── presentation/
│           ├── screens/
│           │   ├── login_screen.dart         # Updated with real auth
│           │   └── register_screen.dart      # Registration screen
│           │
│           └── providers/
│               └── auth_provider.dart        # Updated Riverpod provider
```

---

## Key Components

### 1. Models (lib/features/auth/data/models/)

#### UserModel
```dart
// lib/features/auth/data/models/user_model.dart
@JsonSerializable()
class UserModel extends Equatable {
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
  final String createdAt;
  final String? googlePicture;
  // ...
}
```

#### AuthResponseModel
```dart
// lib/features/auth/data/models/auth_response_model.dart
@JsonSerializable()
class AuthResponseModel extends Equatable {
  final String refresh;
  final String access;
  final UserModel user;
  // ...
}
```

### 2. Services

#### SecureStorage
Handles token storage securely using SharedPreferences:

```dart
// Save tokens after login
await SecureStorage.saveTokens(
  accessToken: 'token_here',
  refreshToken: 'refresh_token_here',
);

// Get access token for API requests
final token = await SecureStorage.getAccessToken();

// Check if user is logged in
final isLoggedIn = await SecureStorage.isLoggedIn();

// Clear all data on logout
await SecureStorage.clearAll();
```

#### AuthService
Handles all authentication API calls:

```dart
// lib/features/auth/data/services/auth_service.dart
class AuthService {
  // Email/Password Login
  Future<AuthResponseModel> loginWithEmail({
    required String email,
    required String password,
  })

  // User Registration
  Future<AuthResponseModel> registerWithEmail({
    required String username,
    required String email,
    required String password,
    String? mobileNo,
    String? phoneNo,
    String? address,
  })

  // Google Sign-In
  Future<AuthResponseModel> signInWithGoogle()

  // Get User Profile
  Future<UserModel> getUserProfile({required String accessToken})

  // Update Profile
  Future<UserModel> updateProfile({...})

  // Change Password
  Future<void> changePassword({...})

  // Logout
  Future<void> logout({required String refreshToken})

  // Refresh Token
  Future<String> refreshAccessToken({required String refreshToken})
}
```

### 3. State Management (Riverpod)

```dart
// lib/features/auth/presentation/providers/auth_provider.dart

// Providers
final authServiceProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService: authService);
});
```

---

## Usage in Screens

### Login Screen Example

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    await authNotifier.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    final authState = ref.read(authStateProvider);
    if (authState.isAuthenticated) {
      // Navigate to home
      context.go('/');
    }
  }

  void _handleGoogleLogin() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    await authNotifier.signInWithGoogle();

    final authState = ref.read(authStateProvider);
    if (authState.isAuthenticated) {
      // Navigate to home
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      body: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          
          // Password field
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),

          // Error message
          if (authState.error != null)
            Text(authState.error!, style: const TextStyle(color: Colors.red)),

          // Login button
          ElevatedButton(
            onPressed: authState.isLoading ? null : _handleLogin,
            child: authState.isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign In'),
          ),

          // Google Sign-In button
          ElevatedButton.icon(
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Sign in with Google'),
            onPressed: authState.isLoading ? null : _handleGoogleLogin,
          ),
        ],
      ),
    );
  }
}
```

### Registration Screen Example

```dart
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    
    await authNotifier.signUpWithEmail(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    final authState = ref.read(authStateProvider);
    if (authState.isAuthenticated) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (authState.error != null)
              Text(authState.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _handleRegister,
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Profile Screen Example

```dart
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (!authState.isAuthenticated) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar
            if (authState.photoUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(authState.photoUrl!),
              ),
            
            const SizedBox(height: 24),

            // User Information
            _buildInfoCard('Username', authState.username),
            _buildInfoCard('Email', authState.email),
            _buildInfoCard('Phone', authState.mobileNo),
            _buildInfoCard('Designation', authState.designation),
            _buildInfoCard('Department', authState.department),
            _buildInfoCard('Address', authState.address),

            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).signOut();
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? 'Not provided',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
```

---

## API Integration

### Backend URL Configuration

Update the base URL in `lib/core/constants/api_endpoints.dart`:

```dart
class ApiEndpoints {
  // For local development
  static const String coreApiBaseUrl = 'http://localhost:8000';
  
  // For production (if deployed)
  // static const String coreApiBaseUrl = 'https://your-domain.com';

  // Auth Endpoints
  static const String authLogin = '/api/accounts/auth/login/';
  static const String authRegister = '/api/accounts/auth/register/';
  static const String authGoogleLogin = '/api/accounts/auth/google-login/';
  // ... other endpoints
}
```

### API Request Flow

1. **Login Request**:
   ```
   POST /api/accounts/auth/login/
   {
     "email": "user@example.com",
     "password": "password123"
   }
   ```

2. **Login Response**:
   ```json
   {
     "refresh": "refresh_token...",
     "access": "access_token...",
     "user": {
       "id": 1,
       "username": "john_doe",
       "email": "john@example.com",
       ...
     }
   }
   ```

3. **Subsequent Requests**:
   All requests include the access token in the Authorization header:
   ```
   Authorization: Bearer access_token...
   ```

4. **Token Refresh**:
   When access token expires, use refresh token to get a new one:
   ```
   POST /api/token/refresh/
   {
     "refresh": "refresh_token..."
   }
   ```

---

## Google Sign-In Configuration

### Android Setup

1. **Get SHA-1 Fingerprint**:
   ```bash
   cd android
   ./gradlew signingReport
   # Copy the SHA1 value
   ```

2. **Add to Firebase Console**:
   - Go to https://console.firebase.google.com/
   - Select your project
   - Go to Project Settings → Android app
   - Add the SHA-1 fingerprint

3. **Update `android/app/build.gradle`**:
   ```gradle
   android {
     compileSdkVersion 34
     defaultConfig {
       applicationId "com.rehman.travels"
       minSdkVersion 21
       targetSdkVersion 34
     }
   }
   ```

### iOS Setup

1. **Update `ios/Podfile`**:
   ```ruby
   pod 'GoogleSignIn'
   ```

2. **Run pod install**:
   ```bash
   cd ios && pod install && cd ..
   ```

3. **Update `ios/Runner/Info.plist`**:
   ```xml
   <dict>
     <key>CFBundleURLTypes</key>
     <array>
       <dict>
         <key>CFBundleURLSchemes</key>
         <array>
           <string>com.googleusercontent.apps.YOUR_IOS_CLIENT_ID</string>
         </array>
       </dict>
     </array>
   </dict>
   ```

---

## State Management Best Practices

### Watching Auth State

```dart
// Watch entire auth state
final authState = ref.watch(authStateProvider);

// Use in conditional logic
if (authState.isAuthenticated) {
  // User is logged in
}

// Check loading state
if (authState.isLoading) {
  // Show loading indicator
}

// Display errors
if (authState.error != null) {
  // Show error message
}
```

### Calling Auth Methods

```dart
// Get notifier to call methods
final authNotifier = ref.read(authStateProvider.notifier);

// Sign in
await authNotifier.signInWithEmail(email, password);

// Sign up
await authNotifier.signUpWithEmail(
  username: 'john',
  email: 'john@example.com',
  phone: '+1234567890',
  password: 'password123',
);

// Google login
await authNotifier.signInWithGoogle();

// Logout
await authNotifier.signOut();
```

---

## Token Management

### Automatic Token Refresh

The `AuthService` handles token refresh automatically. When:
1. Access token is expired
2. API returns 401 Unauthorized
3. Next request will use the refreshed token

### Manual Token Refresh

```dart
final authService = ref.watch(authServiceProvider);
final refreshToken = authState.refreshToken;

if (refreshToken != null) {
  final newAccessToken = await authService.refreshAccessToken(
    refreshToken: refreshToken,
  );
}
```

---

## Error Handling

### Common Errors and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| "Invalid email or password" | Wrong credentials | Check email/password |
| "This email already exists" | Email already registered | Use different email |
| "Password must be at least 8 characters" | Weak password | Use 8+ character password |
| "Network error" | No internet connection | Check internet |
| "Token expired" | Access token expired | Automatic refresh happens |
| "Unauthorized" | Invalid/expired token | Re-login |

### Display Error Messages

```dart
if (authState.error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(authState.error!),
      backgroundColor: Colors.red,
    ),
  );
  
  // Clear error after showing
  ref.read(authStateProvider.notifier).clearError();
}
```

---

## Testing Authentication

### Test with Staging Backend

1. **Update API URL**:
   ```dart
   static const String coreApiBaseUrl = 'http://your-staging-url.com';
   ```

2. **Test Registration**:
   - Open register screen
   - Fill form with test data
   - Click "Sign Up"
   - Should redirect to home on success

3. **Test Login**:
   - Open login screen
   - Enter registered email and password
   - Click "Sign In"
   - Should redirect to home on success

4. **Test Google Sign-In**:
   - Make sure Google credentials are configured
   - Click "Sign in with Google"
   - Should redirect to home on success

5. **Test Profile**:
   - After login, navigate to profile
   - Should show user information
   - Edit profile and update

6. **Test Logout**:
   - Click logout button
   - Should redirect to login
   - Tokens should be cleared

---

## Running the App

### Development

```bash
# Install dependencies
flutter pub get

# Generate code (for JSON serialization)
flutter pub run build_runner build

# Run on device
flutter run

# Run on emulator
flutter run -d emulator-5554
```

### Building APK (Android)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Building IPA (iOS)

```bash
flutter build ios --release
# Open with Xcode to deploy to App Store
```

---

## Troubleshooting

### Issue: "Auth provider not found"
**Solution**: Make sure `apiClientProvider` is defined in `core_api_client.dart`

### Issue: "JSON serialization errors"
**Solution**: Run `flutter pub run build_runner build` to generate serialization code

### Issue: "Google Sign-In fails"
**Solution**: 
- Check SHA-1 fingerprint in Firebase Console
- Ensure Google services are configured correctly
- Check iOS URL schemes in Info.plist

### Issue: "CORS errors"
**Solution**: Backend CORS is configured, but ensure API URL is correct

### Issue: "Token not sending with requests"
**Solution**: Tokens are automatically added by SecureStorage. Check that API client is using the auth headers middleware.

---

## Next Steps

1. ✅ Implement models and services
2. ✅ Update state management
3. ✅ Configure Google Sign-In
4. ✅ Update login/register screens
5. Create profile screen
6. Implement profile edit functionality
7. Add password change feature
8. Add email verification
9. Implement 2FA (optional)
10. Add biometric login (optional)

---

## Resources

- [Flutter Official Docs](https://flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Django REST Framework](https://www.django-rest-framework.org/)

---

**Last Updated**: January 2024
**Status**: Ready for Implementation
**Framework**: Flutter + Riverpod
**Backend**: Django REST Framework

