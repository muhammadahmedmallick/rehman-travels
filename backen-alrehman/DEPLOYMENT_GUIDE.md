# Deployment Guide - Rehman Travels

**Status:** ✅ Ready for production deployment
**Last Updated:** March 29, 2026

---

## Quick Fix Summary

### Issue: Docker Build Fails with "Database connection failed"

**Root Cause:**
- Web container tried to connect to PostgreSQL before it was ready
- Entrypoint script didn't properly wait for databases

**Solution Applied:**
- ✅ Updated `docker-entrypoint.sh` to wait for PostgreSQL (60 second timeout)
- ✅ Updated `docker-entrypoint.sh` to wait for MySQL (60 second timeout)
- ✅ Added proper error handling and logging
- ✅ Added email login support to mobile API

**Files Modified:**
1. `docker-entrypoint.sh` - Better service health checks
2. `apps/mobile/views.py` - Added custom login serializer
3. `apps/mobile/urls.py` - Updated to use custom login view

---

## Deployment Steps

### Step 1: Commit Your Changes

```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels
git add .
git commit -m "Fix: Docker deployment issues and email login support"
git push origin main
```

### Step 2: Pull on EC2

```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
cd ~/rehman-travels/backen-alrehman
git pull origin main
```

### Step 3: Deploy with Docker

```bash
# Option A: Full rebuild (recommended)
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Option B: Quick rebuild
docker-compose build --no-cache web
docker-compose up -d

# Option C: Just restart
docker-compose restart
```

### Step 4: Wait and Verify

```bash
# Wait for services to start
sleep 30

# Check status
docker-compose ps

# Expected output: All containers should show "Up" and "healthy"

# Check logs
docker-compose logs web

# Expected output should show:
# ✅ Postgres is ready!
# ✅ MySQL is ready!
# ✅ Redis is ready!
# ✅ Django setup complete!
```

### Step 5: Test the API

```bash
# Test registration
curl -X POST http://3.222.113.143:8000/api/mobile/auth/register/ \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "test",
    "email": "test@example.com",
    "password": "password123",
    "phone_number": "+923001234567"
  }'

# Test login with username
curl -X POST http://3.222.113.143:8000/api/mobile/auth/login/ \
  -H 'Content-Type: application/json' \
  -d '{"username": "test", "password": "password123"}'

# Test login with email
curl -X POST http://3.222.113.143:8000/api/mobile/auth/login/ \
  -H 'Content-Type: application/json' \
  -d '{"email": "test@example.com", "password": "password123"}'
```

---

## Troubleshooting

### If deployment still fails:

```bash
# Check logs for specific errors
docker-compose logs web | grep -i error

# Check database connectivity
docker-compose exec -T postgres pg_isready -U postgres
docker-compose exec -T db mysql -u root -pclick123 -e "SELECT 1;"

# Force rebuild
docker-compose build --no-cache --force-rm
docker-compose up -d

# If that fails, reset everything
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

---

## What Changed

### docker-entrypoint.sh Improvements

**Before:**
- Waited only for MySQL
- No timeout handling
- Failed silently
- Didn't wait for PostgreSQL at all

**After:**
- Waits for PostgreSQL ✅
- Waits for MySQL ✅
- Waits for Redis ✅
- 60-second timeout per service
- Clear logging of what's happening
- Better error messages
- Graceful failure handling

---

## Deployment Checklist

Before pushing to git:
- [ ] Test locally: `docker-compose up -d`
- [ ] Test registration: Curl the register endpoint
- [ ] Test login: Try username and email login
- [ ] Wait 30 seconds for all services
- [ ] Check `docker-compose logs web`
- [ ] Verify no errors in logs

Before deploying to EC2:
- [ ] Run `git status` to check what's being pushed
- [ ] Run `git diff HEAD` to review changes
- [ ] Push to git
- [ ] SSH to EC2
- [ ] Pull changes
- [ ] Run `docker-compose up -d`
- [ ] Monitor `docker-compose logs -f web`

---

## Key Files

- **docker-entrypoint.sh** - Startup script with service health checks
- **docker-compose.yml** - Service definitions and dependencies
- **.env** - Environment configuration (PostgreSQL, MySQL, Redis credentials)
- **apps/mobile/views.py** - API views with email login support
- **apps/mobile/urls.py** - API routes

---

## Expected Startup Output

When deployment is successful, you should see:

```
Rehman Travels Django - Starting...
Waiting for PostgreSQL (postgres:5432)...
✅ PostgreSQL is ready!
Waiting for MySQL (db:3306)...
✅ MySQL is ready!
Waiting for Redis (redis:6379)...
✅ Redis is ready!
Creating necessary directories...
Collecting static files...
Running PostgreSQL migrations...
Checking MySQL legacy database...
Checking for superuser...
✅ Django setup complete!
Starting application...
```

---

## Quick Commands

```bash
# Deploy
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
cd ~/rehman-travels/backen-alrehman
git pull origin main
docker-compose down && docker-compose build --no-cache && docker-compose up -d

# Monitor
docker-compose logs -f web

# Test
curl -X POST http://localhost:8000/api/mobile/auth/register/ \
  -H 'Content-Type: application/json' \
  -d '{"username":"test","email":"t@test.com","password":"p","phone_number":"+1234567890"}'
```

---

**Your deployment is now ready! 🚀**

