# Authentication System Setup Guide

## Quick Start

### 1. Backend Setup (Django)

#### Step 1: Install Dependencies

```bash
cd backen-alrehman
pip install -r requirements.txt
```

#### Step 2: Configure Environment Variables

Create or update `.env` file:

```env
# Django Settings
DEBUG=True
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DB_ENGINE=django.db.backends.mysql
DB_NAME=rehman_travels_laravel
DB_USER=django_user
DB_PASSWORD=click123
DB_HOST=localhost
DB_PORT=3306

# Google OAuth
GOOGLE_OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:8000,http://localhost:3000,http://127.0.0.1:8000

# Cache
CACHE_DRIVER=file
```

#### Step 3: Run Migrations (if needed)

```bash
python manage.py migrate
```

#### Step 4: Create Superuser (optional)

```bash
python manage.py createsuperuser
```

#### Step 5: Start Development Server

```bash
python manage.py runserver 0.0.0.0:8000
```

Server will run at: `http://localhost:8000`

### 2. Google OAuth2 Setup

#### Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select existing)
3. Enable Google+ API
4. Create OAuth 2.0 credentials (Web application type)
5. Add authorized redirect URIs:
   - For Flutter: `com.rehman.travels://oauth2redirect`
   - For Web: `http://localhost:3000/auth/callback`

#### Step 2: Get Client IDs

- **Web Client ID**: Used for backend verification
- **iOS Client ID**: For iOS Flutter app
- **Android Client ID**: For Android Flutter app

#### Step 3: Add to Backend

```env
GOOGLE_OAUTH_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

### 3. Database Requirements

The system uses existing Laravel tables. Required tables:
- `users` - User accounts
- `agents` - Agent/Company accounts
- `permissions` - Permission definitions
- `permission_assigns` - Permission mappings

If tables don't exist, they can be created from existing Laravel migrations.

---

## API Endpoints Summary

### Authentication Endpoints

```
POST   /api/accounts/auth/login/              - User login
POST   /api/accounts/auth/register/           - User registration
POST   /api/accounts/auth/google-login/       - Google OAuth login
GET    /api/accounts/auth/profile/            - Get user profile
PUT    /api/accounts/auth/profile/            - Update user profile
POST   /api/accounts/auth/change-password/    - Change password
POST   /api/accounts/auth/logout/             - Logout (blacklist token)
POST   /api/token/refresh/                    - Refresh access token
```

### CRUD Endpoints

```
GET    /api/accounts/users/                   - List users
POST   /api/accounts/users/                   - Create user
GET    /api/accounts/users/{id}/              - Get user details
PUT    /api/accounts/users/{id}/              - Update user
DELETE /api/accounts/users/{id}/              - Delete user

GET    /api/accounts/agents/                  - List agents
POST   /api/accounts/agents/                  - Create agent
GET    /api/accounts/agents/{id}/             - Get agent details
PUT    /api/accounts/agents/{id}/             - Update agent
DELETE /api/accounts/agents/{id}/             - Delete agent
```

---

## Testing Authentication

### 1. Using Swagger/OpenAPI

```
http://localhost:8000/swagger/
```

Swagger provides interactive API documentation where you can test endpoints.

### 2. Using cURL

**Login:**
```bash
curl -X POST http://localhost:8000/api/accounts/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpass123"
  }'
```

**Response:**
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    ...
  }
}
```

### 3. Using Postman

1. Import the Postman collection (coming soon)
2. Set base URL: `http://localhost:8000/api`
3. Save tokens from login response
4. Use tokens in Authorization header for authenticated requests

### 4. Test Workflow

```bash
# 1. Register
curl -X POST http://localhost:8000/api/accounts/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "securepass123",
    "password_confirm": "securepass123",
    "mobileno": "+923001234567",
    "phoneno": "+923001234567",
    "address": "123 Main St"
  }'

# 2. Save access_token from response

# 3. Get Profile
curl -X GET http://localhost:8000/api/accounts/auth/profile/ \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# 4. Update Profile
curl -X PUT http://localhost:8000/api/accounts/auth/profile/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "mobileno": "+923009876543",
    "designation": "Senior Agent"
  }'

# 5. Change Password
curl -X POST http://localhost:8000/api/accounts/auth/change-password/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "old_password": "securepass123",
    "new_password": "newsecurepass456",
    "new_password_confirm": "newsecurepass456"
  }'
```

---

## Flutter App Setup

### Step 1: Create Flutter Project

```bash
flutter create rehman_travels
cd rehman_travels
```

### Step 2: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  google_sign_in: ^6.1.0
  shared_preferences: ^2.2.0
  provider: ^6.0.0
```

Install:
```bash
flutter pub get
```

### Step 3: Configure Google Sign-In

#### Android Configuration

1. Add SHA-1 fingerprint to Firebase Console:
```bash
cd android
./gradlew signingReport
```

2. Update `android/app/build.gradle`:
```gradle
android {
    ...
    compileSdkVersion 34
    ...
    defaultConfig {
        applicationId "com.rehman.travels"
        minSdkVersion 21
        targetSdkVersion 34
        ...
    }
}
```

3. Update `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS Configuration

1. Add to `ios/Podfile`:
```ruby
pod 'GoogleSignIn'
```

2. Run pod install:
```bash
cd ios
pod install
cd ..
```

3. Update `ios/Runner/Info.plist`:
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

### Step 4: Implement Authentication

Follow the complete implementation guide in `AUTH_API_DOCUMENTATION.md` sections 9.1-9.9.

### Step 5: Run Flutter App

```bash
# Run on Android
flutter run

# Run on iOS
flutter run -d iphone

# Build release
flutter build apk --release
flutter build ios --release
```

---

## File Structure Created

```
backen-alrehman/
├── apps/accounts/
│   ├── serializers.py          ✅ NEW: Auth serializers
│   ├── views.py               ✅ UPDATED: Auth views
│   ├── auth_backends.py       ✅ NEW: Google OAuth backend
│   ├── urls.py                ✅ NEW: Auth routes
│   ├── models.py              (existing)
│   └── admin.py               (existing)
├── config/
│   ├── settings/
│   │   └── base.py            ✅ UPDATED: Google OAuth config
│   └── urls.py                (existing)
├── requirements.txt           ✅ UPDATED: Added google-auth
├── AUTH_API_DOCUMENTATION.md  ✅ NEW: Complete API docs
└── AUTHENTICATION_SETUP_GUIDE.md  ✅ NEW: This file
```

---

## What Was Implemented

### Backend ✅

1. **Authentication Serializers:**
   - `LoginSerializer` - Email/password login validation
   - `RegisterSerializer` - User registration with password hashing
   - `CustomTokenObtainPairSerializer` - JWT token with user data
   - `GoogleOAuth2Serializer` - Google token validation
   - `UsersDetailSerializer` - User profile serialization

2. **Authentication Views:**
   - `LoginView` - Email/password authentication
   - `RegisterView` - User registration endpoint
   - `UserProfileView` - Get and update user profile
   - `LogoutView` - Token blacklist on logout
   - `ChangePasswordView` - Password change functionality
   - `GoogleOAuth2LoginView` - Google OAuth2 authentication

3. **Google OAuth2 Backend:**
   - `GoogleOAuth2Backend` - Token verification and user creation
   - Support for new user creation from Google data
   - Profile picture from Google

4. **Security:**
   - Password hashing with Django's PBKDF2
   - JWT token authentication
   - Token refresh mechanism
   - Token blacklisting
   - CORS configuration
   - Account status verification

### Frontend (Flutter Plan) ✅

1. **Architecture:**
   - Provider-based state management
   - Secure token storage
   - HTTP client with automatic auth headers
   - Separation of concerns

2. **Features:**
   - Email/password login
   - User registration
   - Google OAuth2 integration
   - Profile management
   - Password change
   - Token refresh
   - Logout

3. **Complete Code Examples:**
   - All models and data classes
   - All services with error handling
   - State management providers
   - Example UI screens
   - Main app setup

---

## Important Notes

### Security Considerations

- **HTTPS in Production:** Always use HTTPS
- **Token Lifetime:** Access tokens expire in 5 hours
- **Refresh Tokens:** Rotate on each refresh
- **CORS:** Configure proper allowed origins
- **Google Client ID:** Keep it secure, don't expose

### Token Management

- Access token: Use for API requests
- Refresh token: Use to get new access token
- Store both securely in local storage
- Implement automatic refresh before expiry

### Password Requirements

- Minimum 8 characters
- Must match confirmation field
- Hashed before storage
- Never sent back in responses

### Database Notes

- Uses existing Laravel schema
- New users created with default settings
- Account status must be 'active'
- Permissions can be assigned separately

---

## Troubleshooting

### Issue: "CORS error from Flutter app"

**Solution:**
1. Check CORS_ALLOWED_ORIGINS in settings
2. Add your app's origin if missing
3. Restart Django server

### Issue: "Google token verification fails"

**Solution:**
1. Verify GOOGLE_OAUTH_CLIENT_ID is correct
2. Check Google Console project settings
3. Ensure OAuth consent screen is configured

### Issue: "Database connection error"

**Solution:**
1. Check database credentials in .env
2. Ensure MySQL is running
3. Run migrations: `python manage.py migrate`

### Issue: "User not found after registration"

**Solution:**
1. Check database permissions
2. Verify user was created: `User.objects.all()`
3. Check for validation errors in response

---

## Next Steps

1. **Configure Google OAuth:**
   - Get Client IDs from Google Cloud Console
   - Update GOOGLE_OAUTH_CLIENT_ID in .env

2. **Test Endpoints:**
   - Use Swagger UI at http://localhost:8000/swagger/
   - Or use provided cURL examples

3. **Build Flutter App:**
   - Follow Flutter setup steps
   - Implement screens from example code
   - Test on actual devices

4. **Deploy:**
   - Set proper environment variables
   - Use HTTPS
   - Configure production database
   - Set up monitoring and logging

---

## Support

For issues or questions:
1. Check AUTH_API_DOCUMENTATION.md for endpoint details
2. Review example code in Flutter implementation section
3. Check Django logs: `python manage.py runserver`
4. Test with cURL examples provided

---

**Created:** January 2024
**Last Updated:** January 2024
**Status:** Ready for Production

