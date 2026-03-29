# Dual-Database Setup - Quick Start Commands

Run these commands in order to complete the implementation:

## 1. Install Dependencies
```bash
cd backen-alrehman
pip install -r requirements.txt
```

## 2. Generate Migrations
```bash
python manage.py makemigrations mobile
```

## 3. Apply Migrations

### PostgreSQL (new database):
```bash
python manage.py migrate --database=default
```

### MySQL (legacy database):
```bash
python manage.py migrate --database=legacy --fake
```

## 4. Create Superuser
```bash
python manage.py createsuperuser
```

Follow prompts to create admin account.

## 5. Start Docker
```bash
docker-compose up -d
```

## 6. Run Tests
```bash
python manage.py test apps.mobile
```

## 7. Access Admin Panel
- URL: http://localhost:8000/admin
- Login with superuser credentials

## 8. Test Registration API
```bash
curl -X POST http://localhost:8000/api/mobile/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "securepass123",
    "first_name": "Test",
    "last_name": "User"
  }'
```

## 9. Test Login API
```bash
curl -X POST http://localhost:8000/api/mobile/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "securepass123"
  }'
```

---

## Key Files Modified

| File | Change |
|------|--------|
| `docker-compose.yml` | Added PostgreSQL service |
| `.env` | Added dual database variables |
| `requirements.txt` | Added psycopg2-binary |
| `config/settings/base.py` | Dual database config + router |
| `config/urls.py` | Added mobile app routes |
| `config/db_router.py` | NEW: Database routing |
| `apps/core/base_models.py` | NEW: Base model classes |
| All `apps/*/models.py` | Updated to LegacyModel |
| `apps/mobile/*` | NEW: Complete mobile app |

---

## API Endpoints

```
POST   /api/mobile/auth/register/    - Register user
POST   /api/mobile/auth/login/       - Login (get tokens)
POST   /api/mobile/auth/refresh/     - Refresh token
GET    /api/mobile/auth/profile/     - Get profile
PUT    /api/mobile/auth/profile/     - Update profile
```

---

## Database Info

**PostgreSQL** (New Data)
- Host: postgres (in Docker)
- Port: 5432
- User: postgres
- Password: postgres
- Database: rehman_travels_django

**MySQL** (Legacy Data - Read-Only)
- Host: db (in Docker)
- Port: 3306
- User: root
- Password: click123
- Database: rehman_travels_laravel_new

---

## Troubleshooting

```bash
# Test database connections
python manage.py dbshell --database=default  # PostgreSQL
python manage.py dbshell --database=legacy   # MySQL

# Check migrations status
python manage.py showmigrations

# Run all tests
python manage.py test

# View Docker logs
docker-compose logs web
docker-compose logs postgres
docker-compose logs db
```

---

## For Detailed Information

See: `DUAL_DATABASE_IMPLEMENTATION.md`
