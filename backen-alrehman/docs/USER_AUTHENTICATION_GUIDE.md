# User Authentication Guide

## Understanding Two Different Login Systems

Your application has **TWO SEPARATE** authentication systems:

### 1. Django Admin (`/admin/`)
- **URL**: `http://3.222.113.143:8000/admin/`
- **Purpose**: Staff members manage data (users, visas, packages, etc.)
- **Login**: Through browser interface
- **Users**: Must have `is_staff=True` or `is_superuser=True`

### 2. Mobile API (`/api/mobile/auth/login/`)
- **URL**: `http://3.222.113.143:8000/api/mobile/auth/login/`
- **Purpose**: Mobile app users authenticate to use the API
- **Login**: Through API (JSON requests)
- **Users**: Any registered user (doesn't need staff privileges)

---

## Your CORS Issue (SOLVED)

### Problem
You were calling from `localhost:3000` to `3.222.113.143:8000`, but the server wasn't allowing it.

### Solution Applied
1. ✅ Updated `config/settings/base.py` to read CORS from environment variables
2. ✅ Updated `.env.ec2` to include:
   - `http://localhost:3000`
   - `http://3.222.113.143`
   - `http://3.222.113.143:8000`

### Deploy to Production
```bash
# SSH to your EC2 server
ssh your-ec2-server

# Navigate to project
cd /path/to/backen-alrehman

# Pull latest changes (if using git)
git pull

# Copy updated .env.ec2 to .env
cp .env.ec2 .env

# Restart the application
docker-compose restart web
# OR if using gunicorn directly:
sudo systemctl restart gunicorn
```

---

## Creating Users

### Option 1: Using the provided script

**Create a superuser for Django Admin:**
```bash
python scripts/create_test_user.py --superuser
# Creates: admin / admin123
```

**Create the "ahmed" user you were testing:**
```bash
python scripts/create_test_user.py --username ahmed --email ahmed@example.com --password click123
```

**List all users:**
```bash
python scripts/create_test_user.py --list
```

### Option 2: Using Django shell (on production server)

**SSH to EC2 and run:**
```bash
# Using docker-compose
docker-compose exec web python manage.py shell

# Inside the shell:
from django.contrib.auth.models import User

# Create superuser for Django admin
User.objects.create_superuser('admin', 'admin@example.com', 'admin123')

# Create regular mobile user
User.objects.create_user('ahmed', 'ahmed@example.com', 'click123', first_name='Ahmed', last_name='User')

# List all users
for user in User.objects.all():
    print(f"{user.username} - superuser:{user.is_superuser} staff:{user.is_staff}")
```

### Option 3: Using Registration API (for mobile users)

```bash
curl -X POST http://3.222.113.143:8000/api/mobile/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "ahmed",
    "email": "ahmed@example.com",
    "password": "click123",
    "first_name": "Ahmed",
    "last_name": "User"
  }'
```

---

## Testing Authentication

### Test 1: Django Admin Login (Browser)

1. Go to: `http://3.222.113.143:8000/admin/`
2. Login with superuser credentials:
   - Username: `admin`
   - Password: `admin123`

**Note**: Regular users (like "ahmed") CANNOT login to admin unless they have `is_staff=True`

---

### Test 2: Mobile API Login (curl)

**From localhost:3000 (your current setup):**
```bash
curl -X POST 'http://3.222.113.143:8000/api/mobile/auth/login/' \
  -H 'Content-Type: application/json' \
  -H 'Origin: http://localhost:3000' \
  -d '{"username":"ahmed","password":"click123"}'
```

**Expected Success Response:**
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "username": "ahmed",
    "email": "ahmed@example.com",
    "first_name": "Ahmed",
    "last_name": "User"
  }
}
```

**Login with email instead of username:**
```bash
curl -X POST 'http://3.222.113.143:8000/api/mobile/auth/login/' \
  -H 'Content-Type: application/json' \
  -d '{"email":"ahmed@example.com","password":"click123"}'
```

---

## Common Errors and Solutions

### Error: Invalid username or email
**Cause**: User doesn't exist in database
**Solution**: Create the user using one of the methods above

### Error: Invalid password
**Cause**: Wrong password
**Solution**: Double-check password or reset it:
```python
from django.contrib.auth.models import User
user = User.objects.get(username='ahmed')
user.set_password('click123')
user.save()
```

### Error: CORS policy blocked
**Cause**: Frontend origin not in CORS_ALLOWED_ORIGINS
**Solution**: Already fixed in `.env.ec2` - deploy changes to production

### Error: 403 Forbidden
**Cause**: CSRF token missing or invalid
**Solution**: Mobile API doesn't need CSRF for JSON requests, but if using session auth:
```bash
curl -X POST 'http://3.222.113.143:8000/api/mobile/auth/login/' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRFToken: your-csrf-token' \
  -b cookies.txt \
  -d '{"username":"ahmed","password":"click123"}'
```

---

## Quick Reference

### Django Admin vs Mobile API

| Feature | Django Admin | Mobile API |
|---------|-------------|------------|
| URL | `/admin/` | `/api/mobile/auth/login/` |
| Login Method | Browser form | JSON POST request |
| User Requirement | `is_staff=True` | Any user |
| Purpose | Data management | Mobile app access |
| Returns | Session cookie | JWT tokens |

### Useful Commands

```bash
# Check if server allows CORS
curl -I -X OPTIONS http://3.222.113.143:8000/api/mobile/auth/login/ \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: POST"

# Check Django version and settings
docker-compose exec web python manage.py version
docker-compose exec web python manage.py check

# View application logs
docker-compose logs -f web

# Restart application
docker-compose restart web
```

---

## Next Steps

1. **Deploy the updated configuration to EC2:**
   ```bash
   # On EC2 server
   cp .env.ec2 .env
   docker-compose restart web
   ```

2. **Create the "ahmed" user on production:**
   ```bash
   docker-compose exec web python scripts/create_test_user.py \
     --username ahmed --email ahmed@example.com --password click123
   ```

3. **Test your curl command again:**
   ```bash
   curl -X POST 'http://3.222.113.143:8000/api/mobile/auth/login/' \
     -H 'Content-Type: application/json' \
     -H 'Origin: http://localhost:3000' \
     -d '{"username":"ahmed","password":"click123"}'
   ```

4. **If using frontend app from localhost:3000:**
   ```javascript
   // Example fetch from your Vue/React app
   fetch('http://3.222.113.143:8000/api/mobile/auth/login/', {
     method: 'POST',
     headers: {
       'Content-Type': 'application/json',
     },
     credentials: 'include', // Important for CORS with credentials
     body: JSON.stringify({
       username: 'ahmed',
       password: 'click123'
     })
   })
   .then(res => res.json())
   .then(data => console.log('Login successful:', data))
   .catch(err => console.error('Login failed:', err));
   ```

---

## Production Security Recommendations

Once testing is complete, update `.env.ec2`:

1. **Change SECRET_KEY** to a strong random key
2. **Update CORS_ALLOWED_ORIGINS** to only include your production domain:
   ```
   CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
   ```
3. **Enable HTTPS** and update to use `https://` instead of `http://`
4. **Set strong passwords** for all users
5. **Enable SSL redirect**:
   ```
   SECURE_SSL_REDIRECT=True
   SESSION_COOKIE_SECURE=True
   CSRF_COOKIE_SECURE=True
   ```
