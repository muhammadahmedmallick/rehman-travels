# 🚀 Rehman Travels - EC2 Deployment Guide

Complete guide to deploy Django Backend + React CMS on AWS EC2.

## 🎯 What Gets Deployed

| Service | URL | Container |
|---------|-----|-----------|
| React CMS | http://YOUR-IP/ | rehman_travels_cms |
| Django Admin | http://YOUR-IP/admin/ | rehman_travels_web |
| Django API | http://YOUR-IP/api/ | rehman_travels_web |
| Nginx Proxy | http://YOUR-IP/ | rehman_travels_nginx |

## 🚀 One-Command Deployment

```bash
# On EC2 instance
cd /home/ubuntu
git clone YOUR-REPO rehman-travels
cd rehman-travels/backen-alrehman
sudo ./deploy.sh
```

Done! The script installs Docker, builds images, and starts all services.

## 📋 Prerequisites

- EC2 instance (Ubuntu 20.04+)
- Minimum: t2.medium (4GB RAM)
- Security Group: Allow ports 22, 80, 443, 8000, 3000

## 🔧 Manual Steps

### 1. Install Docker

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. Deploy

```bash
git clone YOUR-REPO
cd backen-alrehman
docker-compose up -d --build
docker-compose exec web python manage.py migrate --database=default
docker-compose exec web python manage.py createsuperuser
```

## 🔄 Updates

```bash
cd backen-alrehman
git pull
sudo ./update.sh
```

## 📊 Monitoring

```bash
# Status
docker-compose ps

# Logs
docker-compose logs -f

# Restart
docker-compose restart
```

## ✅ Verify

- [ ] http://YOUR-IP/ shows React CMS
- [ ] http://YOUR-IP/admin/ shows Django admin
- [ ] http://YOUR-IP/api/mobile/packages/ returns JSON
- [ ] Can login to CMS

## 🎉 Done!

Both Django and React CMS are running separately on your EC2 instance!

**Created:** April 19, 2026
