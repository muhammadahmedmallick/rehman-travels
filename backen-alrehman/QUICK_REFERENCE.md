# Authentication System - Quick Reference

## 🎯 What Was Built

A complete authentication system for Rehman Travels with:
- ✅ Email/Password login & registration
- ✅ Google OAuth2 integration for Flutter apps
- ✅ JWT token management
- ✅ User profile management
- ✅ Password security and change
- ✅ Complete Flutter frontend implementation guide

---

## 🚀 Quick Start (5 minutes)

### Backend
```bash
cd backen-alrehman
pip install -r requirements.txt
python manage.py runserver
# Visit: http://localhost:8000/swagger/
```

### Test Login
```bash
curl -X POST http://localhost:8000/api/accounts/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

---

## 📌 Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/accounts/auth/login/` | Email/password login |
| POST | `/api/accounts/auth/register/` | New user registration |
| POST | `/api/accounts/auth/google-login/` | Google OAuth2 login |
| GET | `/api/accounts/auth/profile/` | Get user profile |
| PUT | `/api/accounts/auth/profile/` | Update user profile |
| POST | `/api/accounts/auth/change-password/` | Change password |
| POST | `/api/accounts/auth/logout/` | Logout |
| POST | `/api/token/refresh/` | Refresh access token |

---

## 🔐 Authentication Header

All authenticated requests need:
```
Authorization: Bearer {access_token}
```

---

## 📱 Flutter App Setup

```bash
flutter create rehman_travels
cd rehman_travels
flutter pub add http google_sign_in shared_preferences provider
```

Then copy code from **AUTH_API_DOCUMENTATION.md** sections 9.1-9.9

---

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| `AUTH_API_DOCUMENTATION.md` | Complete API reference + Flutter code |
| `AUTHENTICATION_SETUP_GUIDE.md` | Setup instructions & troubleshooting |
| `IMPLEMENTATION_SUMMARY.md` | What was built & next steps |
| `QUICK_REFERENCE.md` | This file |

---

## 🔧 Configuration

### Environment Variables (.env)
```env
GOOGLE_OAUTH_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

### Get Google Client ID
1. Go to https://console.cloud.google.com/
2. Create OAuth2 Web credentials
3. Copy Client ID and add to .env

---

## 📊 Response Examples

### Successful Login (200)
```json
{
  "refresh": "token...",
  "access": "token...",
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "user_type": "user",
    "account_status": "active"
  }
}
```

### Validation Error (400)
```json
{
  "email": ["This field is required."],
  "password": ["Passwords do not match."]
}
```

### Unauthorized (401)
```json
{
  "detail": "Invalid email or password."
}
```

---

## 🔄 Login Flow Diagram

```
User (Flutter)
     ↓
[Enter email & password]
     ↓
POST /api/accounts/auth/login/
     ↓
Backend validates & hashes password
     ↓
Checks account status
     ↓
Generates JWT tokens
     ↓
Returns tokens + user data
     ↓
Flutter stores tokens in SharedPreferences
     ↓
Subsequent requests include: Authorization: Bearer {token}
```

---

## 🔄 Google OAuth2 Flow Diagram

```
User (Flutter)
     ↓
[Tap "Login with Google"]
     ↓
Google Sign-In dialog
     ↓
User authenticates with Google
     ↓
Gets Google ID token
     ↓
POST /api/accounts/auth/google-login/
     ↓
Backend verifies Google token
     ↓
Creates user if new
     ↓
Returns JWT tokens + user data
     ↓
Flutter stores tokens
     ↓
Access API with tokens
```

---

## 🛡️ Security Checklist

- ✅ Passwords hashed with PBKDF2
- ✅ JWT tokens with HS256
- ✅ Token expiry (5 hours)
- ✅ Token refresh support
- ✅ Token blacklisting
- ✅ CORS configured
- ✅ Account status verification
- ✅ Google token verification

---

## ⚠️ Common Issues & Fixes

### "CORS error"
→ Check CORS_ALLOWED_ORIGINS in settings

### "Google token invalid"
→ Verify GOOGLE_OAUTH_CLIENT_ID in .env

### "Password too weak"
→ Use 8+ characters

### "Token expired"
→ Use refresh token to get new access token

---

## 🧪 Testing

### Using Swagger
```
http://localhost:8000/swagger/
```
Interactive API testing without code

### Using cURL
```bash
# Register
curl -X POST http://localhost:8000/api/accounts/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com",...}'

# Login
curl -X POST http://localhost:8000/api/accounts/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"pass"}'

# Use token
curl -X GET http://localhost:8000/api/accounts/auth/profile/ \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 📋 Required Database Tables

System uses existing Laravel tables:
- `users` - User accounts
- `agents` - Agent/company accounts
- `permissions` - Permission definitions
- `permission_assigns` - User permissions

No migrations needed - uses existing schema

---

## 🎯 Next Steps

1. **Set Google Client ID** → Add to .env
2. **Test Endpoints** → Use Swagger UI
3. **Build Flutter App** → Follow documentation
4. **Deploy** → Use HTTPS in production

---

## 📞 Support

See complete documentation:
- API Details → `AUTH_API_DOCUMENTATION.md`
- Setup Help → `AUTHENTICATION_SETUP_GUIDE.md`
- Implementation → `IMPLEMENTATION_SUMMARY.md`

---

**Status:** ✅ Ready for Production
**Last Updated:** January 2024

