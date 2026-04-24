# Environment Variables Quick Reference Card

## 🎯 At a Glance

| Component | Variable | Required | Example |
|-----------|----------|----------|---------|
| Backend | `GOOGLE_OAUTH_CLIENT_ID` | ✅ YES | `123456.apps.googleusercontent.com` |
| Backend | `DEBUG` | ✅ YES | `True` (dev) / `False` (prod) |
| Backend | `SECRET_KEY` | ✅ YES | Long random string (50+ chars) |
| Backend | `DB_NAME` | ✅ YES | `rehman_travels_laravel` |
| Backend | `DB_USER` | ✅ YES | `django_user` |
| Backend | `DB_PASSWORD` | ✅ YES | Strong password |
| Backend | `DB_HOST` | ✅ YES | `localhost` / `db-host.com` |
| Frontend | `API_BASE_URL` | ✅ YES | `http://localhost:8000` |
| Frontend | `GOOGLE_CLIENT_ID` | ⚠️ RECOMMENDED | Google Client ID |

---

## 📋 Backend Environment Variables

### Minimal Setup (.env)
```env
# REQUIRED
DEBUG=True
SECRET_KEY=your-secret-key-here
DB_NAME=rehman_travels_laravel
DB_USER=django_user
DB_PASSWORD=click123
DB_HOST=localhost
GOOGLE_OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com

# OPTIONAL (but good to have)
ALLOWED_HOSTS=localhost,127.0.0.1
CACHE_DRIVER=file
CORS_ALLOWED_ORIGINS=http://localhost:8000,http://localhost:3000
```

### Production Setup (.env)
```env
# Security - CRITICAL
DEBUG=False
SECRET_KEY=generate-with-python-secrets-module
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com,api.yourdomain.com

# Database - CRITICAL
DB_ENGINE=django.db.backends.mysql
DB_NAME=rehman_prod_db
DB_USER=prod_user
DB_PASSWORD=very-strong-password
DB_HOST=your-db-host.com
DB_PORT=3306

# Google OAuth - CRITICAL (different from dev!)
GOOGLE_OAUTH_CLIENT_ID=YOUR_PROD_GOOGLE_CLIENT_ID.apps.googleusercontent.com

# Cache - RECOMMENDED
CACHE_DRIVER=redis
REDIS_HOST=your-redis-host.com
REDIS_PORT=6379
REDIS_PASSWORD=redis-password

# SSL/TLS - CRITICAL for production
SECURE_SSL_REDIRECT=True
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True
SECURE_HSTS_SECONDS=31536000

# CORS - CRITICAL (update with your domain)
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
CSRF_TRUSTED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Email - RECOMMENDED (for future password reset)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=app-specific-password
```

---

## 📱 Frontend Environment Variables

### Configuration File Location
`lib/core/constants/api_endpoints.dart`

### Development
```dart
static const String coreApiBaseUrl = 'http://localhost:8000';
```

### Staging
```dart
static const String coreApiBaseUrl = 'https://staging-api.example.com';
```

### Production
```dart
static const String coreApiBaseUrl = 'https://api.example.com';
```

### Optional: Runtime Configuration
```dart
// lib/core/config/environment.dart
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}
```

Use: `flutter run --dart-define=API_BASE_URL=http://api.com`

---

## 🔧 Setting Up Environment Variables

### Backend - Quick Setup

```bash
# 1. Navigate to project
cd backen-alrehman

# 2. Create .env file
touch .env

# 3. Add required variables
cat >> .env << 'ENVFILE'
DEBUG=True
SECRET_KEY=your-secret-key-here
DB_NAME=rehman_travels_laravel
DB_USER=django_user
DB_PASSWORD=click123
DB_HOST=localhost
GOOGLE_OAUTH_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com
ENVFILE

# 4. Verify
cat .env
```

### Frontend - Quick Setup

```bash
# 1. Navigate to project
cd rehman_mobile_app

# 2. Update API endpoint
# Edit: lib/core/constants/api_endpoints.dart
# Change: static const String coreApiBaseUrl = 'YOUR_BACKEND_URL';

# 3. Build
flutter pub run build_runner build
```

---

## 🔐 Generating Secure Values

### Generate Django SECRET_KEY
```bash
python -c 'import secrets; print(secrets.token_urlsafe(50))'
```

### Generate Strong Password
```bash
python -c 'import secrets; print(secrets.token_hex(32))'
```

### Generate Secure Random String
```bash
openssl rand -base64 32
```

---

## 🚨 Critical Variables Checklist

### Backend - MUST SET
- [ ] `GOOGLE_OAUTH_CLIENT_ID` - Without this, Google OAuth won't work
- [ ] `SECRET_KEY` - Must be strong and unique (50+ characters)
- [ ] `DB_PASSWORD` - Must be secure
- [ ] `DEBUG=False` - CRITICAL for production
- [ ] `ALLOWED_HOSTS` - Updated with actual domain

### Frontend - MUST SET
- [ ] `API_BASE_URL` (in api_endpoints.dart) - Must point to working backend
- [ ] Google Sign-In configured (SHA-1 for Android, URL scheme for iOS)

### Production - EXTRA CRITICAL
- [ ] New Google OAuth2 credentials (different from dev)
- [ ] `SECURE_SSL_REDIRECT=True`
- [ ] `SESSION_COOKIE_SECURE=True`
- [ ] `CSRF_COOKIE_SECURE=True`
- [ ] Strong database password
- [ ] Redis/Cache configured
- [ ] Email service configured

---

## 🧪 Verification Commands

### Backend Verification
```bash
# Check .env file exists
cat backen-alrehman/.env

# Check GOOGLE_OAUTH_CLIENT_ID is set
grep GOOGLE_OAUTH_CLIENT_ID backen-alrehman/.env

# Test API
curl http://localhost:8000/swagger/

# Test with token
curl -X POST http://localhost:8000/api/accounts/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

### Frontend Verification
```bash
# Check API endpoint
grep coreApiBaseUrl rehman_mobile_app/lib/core/constants/api_endpoints.dart

# Verify build
flutter pub run build_runner build

# Test app
flutter run
```

---

## 📊 Environment by Stage

### Development
```
Backend API URL: http://localhost:8000
Frontend API URL: http://localhost:8000
Google Client ID: Development credentials
SSL: Not required
```

### Staging
```
Backend API URL: https://staging-api.example.com
Frontend API URL: https://staging-api.example.com
Google Client ID: Staging credentials
SSL: Required
DEBUG: False
```

### Production
```
Backend API URL: https://api.example.com
Frontend API URL: https://api.example.com
Google Client ID: Production credentials (NEW!)
SSL: Required with HSTS
DEBUG: False
SECURE_SSL_REDIRECT: True
```

---

## 🐛 Common Issues & Solutions

### Backend Won't Start
```
Issue: ModuleNotFoundError
Solution: pip install -r requirements.txt

Issue: GOOGLE_OAUTH_CLIENT_ID not found
Solution: Add to .env and restart

Issue: Database connection error
Solution: Check DB credentials in .env
```

### Frontend Can't Connect
```
Issue: Connection refused
Solution: Check backend is running
Solution: Check API URL in api_endpoints.dart

Issue: Google Sign-In fails
Solution: Verify SHA-1 (Android) or URL scheme (iOS)
Solution: Check Google OAuth2 credentials
```

---

## 📋 Template .env Files

### Development Template (backen-alrehman/.env)
```env
# Django
DEBUG=True
SECRET_KEY=django-insecure-change-this-in-production
ALLOWED_HOSTS=localhost,127.0.0.1,192.168.1.100

# Database
DB_ENGINE=django.db.backends.mysql
DB_NAME=rehman_travels_laravel
DB_USER=django_user
DB_PASSWORD=click123
DB_HOST=localhost
DB_PORT=3306

# Google OAuth2
GOOGLE_OAUTH_CLIENT_ID=YOUR_DEV_CLIENT_ID.apps.googleusercontent.com

# Cache
CACHE_DRIVER=file

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:8000,http://localhost:3000,http://127.0.0.1:8000
CSRF_TRUSTED_ORIGINS=http://localhost:8000
```

### Production Template (backen-alrehman/.env)
```env
# Django
DEBUG=False
SECRET_KEY=YOUR-GENERATED-SECRET-KEY-HERE-50-CHARS-MIN
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com,api.yourdomain.com

# Database
DB_ENGINE=django.db.backends.mysql
DB_NAME=rehman_prod_db
DB_USER=prod_db_user
DB_PASSWORD=YOUR-STRONG-DB-PASSWORD-HERE
DB_HOST=your-db-host.com
DB_PORT=3306

# Google OAuth2
GOOGLE_OAUTH_CLIENT_ID=YOUR_PROD_CLIENT_ID.apps.googleusercontent.com

# Cache
CACHE_DRIVER=redis
REDIS_HOST=your-redis-host.com
REDIS_PORT=6379
REDIS_PASSWORD=YOUR-REDIS-PASSWORD

# SSL/Security
SECURE_SSL_REDIRECT=True
SESSION_COOKIE_SECURE=True
CSRF_COOKIE_SECURE=True
SECURE_HSTS_SECONDS=31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS=True

# CORS
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
CSRF_TRUSTED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Email
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=noreply@yourdomain.com
EMAIL_HOST_PASSWORD=YOUR-APP-SPECIFIC-PASSWORD
DEFAULT_FROM_EMAIL=noreply@yourdomain.com
```

---

## ✅ Pre-Deployment Environment Checklist

### Backend
- [ ] `.env` file created in `backen-alrehman/`
- [ ] All required variables set
- [ ] `GOOGLE_OAUTH_CLIENT_ID` is correct
- [ ] `SECRET_KEY` is strong (50+ characters)
- [ ] Database credentials are correct
- [ ] `DEBUG=False` for production
- [ ] `CORS_ALLOWED_ORIGINS` updated
- [ ] SSL certificates configured
- [ ] Email service configured
- [ ] `.env` is in `.gitignore`

### Frontend
- [ ] `API_BASE_URL` points to correct backend
- [ ] Google Sign-In credentials configured
- [ ] Android: SHA-1 fingerprint added
- [ ] iOS: URL scheme configured
- [ ] `build_runner build` executed
- [ ] `flutter pub get` executed
- [ ] App builds without errors
- [ ] Login tested
- [ ] Google Sign-In tested

---

## 📞 Need Help?

**Backend issues?** → Check `backen-alrehman/README_AUTHENTICATION.md`
**Frontend issues?** → Check `rehman_mobile_app/FLUTTER_AUTHENTICATION_GUIDE.md`
**API issues?** → Check `backen-alrehman/QUICK_REFERENCE.md`
**Setup issues?** → Check `backen-alrehman/AUTHENTICATION_SETUP_GUIDE.md`

---

**Last Updated**: January 2024
**Status**: Ready for use

