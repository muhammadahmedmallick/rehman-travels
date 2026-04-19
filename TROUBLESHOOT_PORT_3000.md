# 🔧 Troubleshooting Port 3000 Access Issue

## Current Status

✅ **Port 8000 (Django)** - Working
❌ **Port 3000 (React CMS)** - Not accessible
❌ **Port 80 (Nginx)** - Not accessible

## Root Cause

The React CMS and Nginx containers are not deployed yet, or EC2 ports are not open.

---

## Solution Steps

### Step 1: Open Ports in AWS Security Group

1. Go to **AWS Console** → **EC2** → **Instances**
2. Click on your instance: `3.222.113.143`
3. Go to **Security** tab → Click on the **Security Group** link
4. Click **Edit inbound rules**
5. Click **Add rule** twice and add:

```
Rule 1:
Type: HTTP
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
Description: Nginx reverse proxy

Rule 2:
Type: Custom TCP
Protocol: TCP
Port: 3000
Source: 0.0.0.0/0
Description: React CMS direct access
```

6. Click **Save rules**

### Step 2: SSH to EC2 and Check Current State

```bash
ssh ubuntu@3.222.113.143

# Check what's running
docker ps

# Check if project exists
ls -la | grep backen
```

### Step 3a: If Project Directory Exists

```bash
cd backen-alrehman

# Check current docker-compose services
docker-compose ps

# Pull latest changes (includes new CMS + nginx configs)
git pull origin main  # or your branch: feature/handle-mobile-visa-feature

# Deploy everything
sudo ./deploy.sh
```

### Step 3b: If Project Directory Does NOT Exist

```bash
cd /home/ubuntu

# Clone repository
git clone YOUR-REPO-URL rehman-travels
cd rehman-travels/backen-alrehman

# Deploy
sudo ./deploy.sh
```

### Step 4: Wait and Verify

Wait 5-10 minutes for deployment to complete, then check:

```bash
# Check all containers are running
docker-compose ps

# Should see 8 services:
# - rehman_travels_nginx (port 80)
# - rehman_travels_cms (port 3000)
# - rehman_travels_web (port 8000)
# - rehman_travels_postgres
# - rehman_travels_db
# - rehman_travels_redis
# - rehman_travels_celery
# - rehman_travels_celery_beat

# Test locally on EC2
curl http://localhost:3000
curl http://localhost:80
```

### Step 5: Test from Your Computer

```bash
# Test port 3000 (React CMS direct)
curl -I http://3.222.113.143:3000/

# Test port 80 (Nginx - should redirect to CMS)
curl -I http://3.222.113.143/

# Test Django API
curl http://3.222.113.143/api/mobile/packages/
```

---

## Quick Diagnosis Commands

Run these on EC2 to diagnose:

```bash
# Check if CMS container exists
docker ps -a | grep cms

# Check CMS logs
docker-compose logs cms

# Check nginx logs
docker-compose logs nginx

# Check if ports are listening
netstat -tuln | grep -E '(:80|:3000|:8000)'

# Or with ss
ss -tuln | grep -E '(:80|:3000|:8000)'
```

---

## Expected Output After Successful Deployment

```bash
docker-compose ps

# Should show:
NAME                          STATUS          PORTS
rehman_travels_nginx          Up             0.0.0.0:80->80/tcp
rehman_travels_cms            Up             0.0.0.0:3000->80/tcp
rehman_travels_web            Up             0.0.0.0:8000->8000/tcp
rehman_travels_postgres       Up             5432/tcp
rehman_travels_db             Up             0.0.0.0:3307->3306/tcp
rehman_travels_redis          Up             0.0.0.0:6380->6379/tcp
rehman_travels_celery         Up
rehman_travels_celery_beat    Up
```

---

## If CMS Container Fails to Build

```bash
# Check CMS build logs
docker-compose logs --tail=50 cms

# Common issues:
# 1. npm install failed - Check cms-frontend/package.json
# 2. npm run build failed - Check React code syntax
# 3. Out of memory - Need larger EC2 instance (t2.medium minimum)

# Rebuild CMS only
docker-compose up -d --build cms

# Or full rebuild
docker-compose down
docker-compose build --no-cache cms
docker-compose up -d
```

---

## Alternative: Use Nginx Only (Skip Port 3000)

If you don't need direct port 3000 access, you can:

1. Only open port 80 in Security Group
2. Access CMS via: `http://3.222.113.143/` (nginx will route to CMS)
3. Access API via: `http://3.222.113.143/api/`
4. Access Admin via: `http://3.222.113.143/admin/`

This is the **recommended production setup** - single entry point on port 80.

---

## Still Not Working?

### Check EC2 Instance Resources

```bash
# Check disk space
df -h

# Check memory
free -h

# Check if Docker is running
sudo systemctl status docker
```

### Check Docker Compose File

```bash
# Verify docker-compose.yml has cms and nginx services
grep -A 5 "cms:" docker-compose.yml
grep -A 5 "nginx:" docker-compose.yml
```

### Check Network

```bash
# Check if EC2 can reach internet (for pulling images)
ping -c 3 google.com

# Check Docker network
docker network ls
docker network inspect rehman_network
```

---

## Contact Info

If you've followed all steps and it's still not working, provide:

1. Output of: `docker-compose ps`
2. Output of: `docker-compose logs cms --tail=50`
3. Output of: `docker-compose logs nginx --tail=50`
4. Screenshot of AWS Security Group inbound rules

---

**Created**: April 19, 2026
**Status**: Port 8000 working, Port 3000/80 need deployment
