# Dual-Database Implementation - Complete Setup Guide

## Implementation Status: ✅ 80% Complete

All major code changes have been implemented. Follow these final steps to complete the setup.

---

## What's Been Done ✅

### Phase 1-5: Code Implementation (COMPLETE)
- ✅ PostgreSQL added to Docker setup
- ✅ Environment variables configured
- ✅ Django settings updated with dual database config
- ✅ Database router created at `config/db_router.py`
- ✅ Base model classes created
- ✅ ALL legacy models converted to `LegacyModel` and `managed = False`
- ✅ Mobile app created with JWT authentication
- ✅ User registration, login, and profile endpoints ready
- ✅ Tests file created

### Files Created (9 new files)
```
apps/mobile/
├── __init__.py
├── models.py           - MobileUserProfile model
├── serializers.py      - User registration & profile serializers
├── views.py            - Registration & profile views
├── urls.py             - Mobile app routing
├── admin.py            - Admin configuration
├── apps.py             - App configuration
├── tests.py            - Unit & integration tests
└── migrations/
    └── __init__.py
```

### Files Modified (9 files)
```
backen-alrehman/
├── docker-compose.yml  - Added PostgreSQL service
├── .env                - Added dual database vars
├── requirements.txt    - Added psycopg2-binary
├── config/
│   ├── settings/base.py    - Dual database config + JWT settings
│   ├── urls.py             - Mobile app routes
│   └── db_router.py        - NEW: Database routing logic
├── apps/
│   ├── core/base_models.py - NEW: Base model classes
│   ├── core/models.py      - Updated to LegacyModel
│   ├── accounts/models.py  - Updated to LegacyModel
│   ├── ticketing/models.py - Updated to LegacyModel
│   ├── umrah/models.py     - Updated to LegacyModel
│   ├── cms/models.py       - Updated to LegacyModel
│   ├── payments/models.py  - Updated to LegacyModel
│   └── hotels/models.py    - Updated to LegacyModel
```

---

## Next Steps: Complete Implementation (20% Remaining)

### Step 1: Install Dependencies
```bash
cd backen-alrehman
pip install -r requirements.txt
```

### Step 2: Generate Migrations
```bash
# Generate migrations for mobile app
python manage.py makemigrations mobile
```

You should see output like:
```
Migrations for 'mobile':
  apps/mobile/migrations/0001_initial.py
    - Create model MobileUserProfile
```

### Step 3: Apply Migrations

#### For PostgreSQL (new database - default):
```bash
# This will create auth and mobile app tables in PostgreSQL
python manage.py migrate --database=default
```

#### For MySQL (legacy database - don't migrate):
```bash
# Fake existing migrations so Django knows they're already applied
python manage.py migrate --database=legacy --fake
```

### Step 4: Create Superuser (for Django admin)
```bash
python manage.py createsuperuser
```

You'll be prompted for:
- Username
- Email
- Password

This superuser will be created in the PostgreSQL database.

### Step 5: Start Docker Containers

```bash
# Start all services
docker-compose up -d

# Verify all services are running
docker-compose ps
```

Expected output:
```
NAME                      STATUS
rehman_travels_db         Up (healthy)
rehman_travels_postgres   Up (healthy)
rehman_travels_redis      Up (healthy)
rehman_travels_web        Up
```

### Step 6: Test the Setup

#### Test 1: Database Connection
```bash
# Test PostgreSQL connection
python manage.py dbshell --database=default

# You should see a postgres prompt: "postgres=#"
# Type: \q to exit

# Test MySQL connection
python manage.py dbshell --database=legacy

# You should see a mysql prompt: "mysql>"
# Type: exit to quit
```

#### Test 2: Django Admin
Open browser: http://localhost:8000/admin
- Login with superuser credentials
- Verify you can see:
  - **Auth** section: Users, Groups (from PostgreSQL)
  - **Mobile** section: Mobile User Profiles (from PostgreSQL)
  - **Accounts** section: Agents, Users, Permissions (read-only, from MySQL)
  - **Core** section: Customers, Branches, etc. (read-only, from MySQL)

#### Test 3: Run Tests
```bash
python manage.py test apps.mobile
```

Expected output:
```
Ran 3 tests in X.XXXs
OK
```

#### Test 4: Test Registration Endpoint
```bash
curl -X POST http://localhost:8000/api/mobile/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "securepass123",
    "first_name": "Test",
    "last_name": "User",
    "phone_number": "+923001234567"
  }'
```

Expected response (201 Created):
```json
{
  "id": 1,
  "username": "testuser",
  "email": "test@example.com",
  "first_name": "Test",
  "last_name": "User"
}
```

#### Test 5: Test Login Endpoint
```bash
curl -X POST http://localhost:8000/api/mobile/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "securepass123"
  }'
```

Expected response (200 OK):
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

#### Test 6: Test Read-Only Enforcement
```bash
python manage.py shell

# Try to create an agent (should fail)
>>> from apps.accounts.models import Agents
>>> Agents.objects.create(username='test', email='test@example.com')
# Should raise an exception

# Try to create a user (should succeed)
>>> from django.contrib.auth.models import User
>>> user = User.objects.create_user('newuser', 'new@example.com', 'pass123')
>>> print(user)
newuser
```

---

## Optional: Create Read-Only MySQL User

For extra security, create a database user with read-only permissions:

```bash
# Connect to MySQL
mysql -h localhost -u root -pclick123

# Create read-only user
CREATE USER 'django_readonly'@'%' IDENTIFIED BY 'secure_password';
GRANT SELECT ON rehman_travels_laravel_new.* TO 'django_readonly'@'%';
FLUSH PRIVILEGES;
EXIT;
```

Then update `.env`:
```env
LEGACY_DB_USER=django_readonly
LEGACY_DB_PASSWORD=secure_password
```

---

## API Endpoints Summary

### Authentication Endpoints
```
POST   /api/mobile/auth/register/    - Register new user
POST   /api/mobile/auth/login/       - Login (get JWT tokens)
POST   /api/mobile/auth/refresh/     - Refresh access token
GET    /api/mobile/auth/profile/     - Get current user profile
PUT    /api/mobile/auth/profile/     - Update current user profile
```

### Example Workflow

1. **Register**:
   ```bash
   POST /api/mobile/auth/register/
   {
     "username": "john_doe",
     "email": "john@example.com",
     "password": "securepass123",
     "first_name": "John",
     "last_name": "Doe",
     "phone_number": "+923001234567"
   }
   ```

2. **Login**:
   ```bash
   POST /api/mobile/auth/login/
   {
     "username": "john_doe",
     "password": "securepass123"
   }
   ```
   Response contains `access` and `refresh` tokens.

3. **Use Token** (for authenticated endpoints):
   ```bash
   GET /api/mobile/auth/profile/
   Headers: Authorization: Bearer <access_token>
   ```

4. **Refresh Token** (when access expires):
   ```bash
   POST /api/mobile/auth/refresh/
   {
     "refresh": "<refresh_token>"
   }
   ```

---

## Database Architecture

### PostgreSQL (rehman_travels_django)
Contains all new Django features:
- `auth_user` - User accounts
- `auth_group` - User groups
- `mobile_user_profiles` - Extended mobile user info
- All Django system tables (sessions, admin logs, etc.)

### MySQL (rehman_travels_laravel_new)
Contains all legacy Laravel data (READ-ONLY):
- `agents` - Travel agents
- `users` - Legacy users
- `customers` - Customer records
- `flight_itinerary_infos` - Flight booking data
- `umrah_bookings` - Umrah package bookings
- All other Laravel tables

---

## Troubleshooting

### Issue: "relation does not exist" (PostgreSQL)
```
Solution: Run migrations
python manage.py migrate --database=default
```

### Issue: "Access denied for user 'django_readonly'"
```
Solution: Verify MySQL GRANT permissions
mysql -u root -p
SHOW GRANTS FOR 'django_readonly'@'%';
```

### Issue: Models try to write to legacy database
```
Solution: Verify db_router is in settings
Check: config/settings/base.py has
DATABASE_ROUTERS = ['config.db_router.DatabaseRouter']
```

### Issue: Cross-database query fails
```
Solution: Expected behavior. Use:
- API calls to join data
- Database views for complex queries
- Frontend logic to combine responses
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│                   Django Backend                     │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │         Database Router (db_router.py)       │  │
│  │  • Routes reads to correct database           │  │
│  │  • Blocks writes to legacy database           │  │
│  │  • Prevents cross-database relations          │  │
│  └──────────────────────────────────────────────┘  │
│    │                              │                 │
│    ▼                              ▼                 │
│  ┌──────────────────┐  ┌──────────────────────┐  │
│  │  Legacy Models   │  │    New Models        │  │
│  │  (managed=False) │  │    (managed=True)    │  │
│  │                  │  │                      │  │
│  │ • Agents         │  │ • User (Django auth) │  │
│  │ • Users          │  │ • MobileUserProfile  │  │
│  │ • Customers      │  │ • (Future features)  │  │
│  │ • Flights        │  │                      │  │
│  │ • Umrah bookings │  │                      │  │
│  └──────────────────┘  └──────────────────────┘  │
│    │                              │                 │
│    ▼                              ▼                 │
│  'legacy' database              'default' database  │
└─────────────────────────────────────────────────────┘
       │                              │
       ▼                              ▼
┌──────────────────┐    ┌──────────────────────┐
│  MySQL 8.0       │    │  PostgreSQL 15       │
│  (READ-ONLY)     │    │  (READ/WRITE)        │
│                  │    │                      │
│  Port: 3307      │    │  Port: 5432          │
│  User: root      │    │  User: postgres      │
│  DB: rehman_     │    │  DB: rehman_travels_ │
│     travels_     │    │      django          │
│     laravel_new  │    │                      │
└──────────────────┘    └──────────────────────┘
```

---

## Security Checklist

- [ ] Database user created with read-only MySQL permissions
- [ ] `LEGACY_DB_USER` set to read-only user
- [ ] JWT tokens configured with appropriate expiration
- [ ] `SECRET_KEY` changed in production
- [ ] `DEBUG` set to `False` in production
- [ ] `ALLOWED_HOSTS` configured properly
- [ ] HTTPS enabled in production
- [ ] CORS properly configured for your frontend
- [ ] Database passwords stored in `.env` (not in code)
- [ ] Regular backups of MySQL database configured

---

## Next Development Steps

1. **Add more mobile endpoints** in `apps/mobile/views.py`
2. **Create mobile serializers** for booking, flights, etc.
3. **Add mobile-specific models** in `apps/mobile/models.py`
4. **Implement push notifications** using device_token
5. **Add request logging** for audit trail
6. **Implement rate limiting** for API endpoints
7. **Add API versioning** for backward compatibility

---

## Support & Documentation

- **Django REST Framework**: https://www.django-rest-framework.org/
- **Django Simple JWT**: https://django-rest-framework-simplejwt.readthedocs.io/
- **PostgreSQL**: https://www.postgresql.org/docs/
- **Docker Docs**: https://docs.docker.com/

---

## Summary

You have successfully:
1. ✅ Set up dual-database configuration
2. ✅ Created database routing system
3. ✅ Migrated all legacy models to read-only
4. ✅ Built mobile authentication API
5. ✅ Created test suite

**Remaining**: Follow the "Next Steps" section above to complete setup and test the system.

**Total estimated time**: 1-2 hours for final setup and testing.
