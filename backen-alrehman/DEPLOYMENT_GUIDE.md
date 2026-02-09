# Deployment Guide - Django to EC2 via GitHub Actions

This guide covers automatic deployment of the Django application to EC2 when code is pushed to the `main` branch.

## 📋 Prerequisites

- GitHub repository with access to Settings
- EC2 instance running Ubuntu
- SSH key pair for EC2 access (`rehman-travels-key.pem`)
- Docker and Docker Compose installed on EC2
- Git installed on EC2

---

## 🔧 1. EC2 Server Setup

### SSH into your EC2 server:
```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
```

### Install required software:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Git
sudo apt install git -y

# Verify installations
docker --version
docker-compose --version
git --version
```

### Clone repository (first time only):
```bash
cd /rehman-travels
git clone <your-repo-url> backen-alrehman
cd backen-alrehman
```

### Set up environment variables:
```bash
# Create .env file
nano .env
```

Add your environment variables:
```env
DEBUG=False
SECRET_KEY=your-production-secret-key
ALLOWED_HOSTS=3.222.113.143,your-domain.com

DB_ENGINE=django.db.backends.mysql
DB_NAME=rehman_travels_laravel
DB_USER=root
DB_PASSWORD=your-db-password
DB_HOST=db
DB_PORT=3306

REDIS_URL=redis://redis:6379/1
CELERY_BROKER_URL=redis://redis:6379/0

EXTERNAL_API_URL=http://exaltedrestapiandrehmantravel.local/api/
AGENT_ID=1182
```

### Initial Docker setup:
```bash
# Build and start containers
docker-compose up -d

# Run migrations
docker-compose exec web python manage.py migrate

# Create superuser
docker-compose exec web python manage.py createsuperuser

# Collect static files
docker-compose exec web python manage.py collectstatic --noinput
```

---

## 🔐 2. GitHub Repository Secrets Setup

Go to your GitHub repository:
1. Navigate to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**

Add the following secrets:

### Secret 1: `EC2_HOST`
- **Name**: `EC2_HOST`
- **Value**: `3.222.113.143`

### Secret 2: `EC2_USERNAME`
- **Name**: `EC2_USERNAME`
- **Value**: `ubuntu`

### Secret 3: `EC2_SSH_KEY`
- **Name**: `EC2_SSH_KEY`
- **Value**: Contents of `rehman-travels-key.pem`

To get the SSH key content:
```bash
# On your local machine
cat rehman-travels-key.pem
```

Copy the entire output (including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`) and paste it as the secret value.

---

## 📁 3. Project Structure on EC2

```
/rehman-travels/
└── backen-alrehman/
    ├── .git/
    ├── .github/
    │   └── workflows/
    │       └── deploy.yml
    ├── apps/
    ├── config/
    ├── docker-compose.yml
    ├── Dockerfile
    ├── requirements.txt
    ├── manage.py
    └── .env
```

---

## 🚀 4. How Deployment Works

### Automatic Deployment
When you push code to the `main` branch:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

GitHub Actions will automatically:
1. ✅ Connect to EC2 via SSH
2. ✅ Navigate to `/rehman-travels/backen-alrehman`
3. ✅ Pull latest code from `main` branch
4. ✅ Rebuild Docker containers
5. ✅ Run database migrations
6. ✅ Collect static files
7. ✅ Restart application
8. ✅ Check application health

### Manual Deployment
You can also trigger deployment manually:
1. Go to GitHub repository
2. Click **Actions** tab
3. Select **Deploy to EC2** workflow
4. Click **Run workflow**
5. Select `main` branch
6. Click **Run workflow**

---

## 📊 5. Monitoring Deployment

### View GitHub Actions logs:
1. Go to **Actions** tab in GitHub
2. Click on the latest workflow run
3. Click on **Deploy Django App to EC2**
4. View real-time logs

### View application logs on EC2:
```bash
# SSH into server
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143

# View Docker logs
cd /rehman-travels/backen-alrehman
docker-compose logs -f web

# View specific container logs
docker-compose logs --tail=100 web
docker-compose logs --tail=100 db
docker-compose logs --tail=100 redis

# Check running containers
docker-compose ps

# Check application health
curl http://localhost:8000/swagger/
```

---

## 🔍 6. Troubleshooting

### Deployment failed?

**Check GitHub Actions logs:**
- Go to Actions tab → Latest run → View logs
- Look for error messages in red

**Common issues:**

#### 1. SSH Connection Failed
```bash
# Verify SSH key is added to GitHub Secrets correctly
# Ensure EC2 security group allows SSH (port 22)
# Check EC2 instance is running
```

#### 2. Git Pull Failed
```bash
# SSH into EC2
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143

# Check git status
cd /rehman-travels/backen-alrehman
git status

# Reset if needed
git fetch origin main
git reset --hard origin/main
```

#### 3. Docker Build Failed
```bash
# Check Docker logs
docker-compose logs web

# Rebuild manually
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

#### 4. Application Not Responding
```bash
# Check if containers are running
docker-compose ps

# Check web container logs
docker-compose logs --tail=100 web

# Check database connection
docker-compose exec web python manage.py check --database default

# Restart containers
docker-compose restart
```

#### 5. Permission Denied Errors
```bash
# Ensure ubuntu user has docker permissions
sudo usermod -aG docker ubuntu

# Log out and log back in
exit
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143

# Verify docker works without sudo
docker ps
```

---

## 🛡️ 7. Security Best Practices

### EC2 Security Group
Open only necessary ports:
- **22** (SSH) - Restrict to your IP
- **80** (HTTP) - For web traffic
- **443** (HTTPS) - For secure web traffic
- **8000** (Django) - For development/testing (close in production)

### Environment Variables
- Never commit `.env` file to Git
- Keep `.env` in `.gitignore`
- Use different secrets for production

### SSH Key
- Keep `rehman-travels-key.pem` secure
- Never commit it to Git
- Use `chmod 400 rehman-travels-key.pem` for proper permissions

---

## 🔄 8. Rollback Strategy

If deployment fails and you need to rollback:

```bash
# SSH into server
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
cd /rehman-travels/backen-alrehman

# View commit history
git log --oneline -10

# Rollback to previous commit
git reset --hard <commit-hash>

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

---

## 📈 9. Performance Optimization

### Enable NGINX Reverse Proxy
```bash
# Install NGINX
sudo apt install nginx -y

# Create NGINX config
sudo nano /etc/nginx/sites-available/django
```

```nginx
server {
    listen 80;
    server_name 3.222.113.143 your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /rehman-travels/backen-alrehman/staticfiles/;
    }

    location /media/ {
        alias /rehman-travels/backen-alrehman/media/;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/django /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Enable SSL with Let's Encrypt
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your-domain.com
```

---

## 📝 10. Maintenance

### Regular Updates
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Docker images
docker-compose pull
docker-compose up -d
```

### Database Backup
```bash
# Create backup directory
mkdir -p /rehman-travels/backups

# Backup database
docker-compose exec -T db mysqldump -u root -p'your-password' rehman_travels_laravel > /rehman-travels/backups/backup_$(date +%Y%m%d_%H%M%S).sql

# Create automated backup script
cat > /rehman-travels/backup.sh << 'EOF'
#!/bin/bash
cd /rehman-travels/backen-alrehman
docker-compose exec -T db mysqldump -u root -p'your-password' rehman_travels_laravel > /rehman-travels/backups/backup_$(date +%Y%m%d_%H%M%S).sql
# Keep only last 7 days of backups
find /rehman-travels/backups -name "backup_*.sql" -mtime +7 -delete
EOF

chmod +x /rehman-travels/backup.sh

# Add to crontab (daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /rehman-travels/backup.sh") | crontab -
```

---

## 🎯 11. Quick Commands Reference

```bash
# Deploy manually
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && git pull && docker-compose up -d --build'

# Check status
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose ps'

# View logs
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose logs -f web'

# Restart application
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose restart web'

# Run migrations
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose exec -T web python manage.py migrate'

# Check application health
curl http://3.222.113.143:8000/swagger/
```

---

## 📞 Support

If you encounter issues:
1. Check GitHub Actions logs
2. Check Docker logs on EC2
3. Verify environment variables
4. Check EC2 security groups
5. Verify SSH key permissions

---

## ✅ Deployment Checklist

Before first deployment:
- [ ] EC2 instance running and accessible via SSH
- [ ] Docker and Docker Compose installed on EC2
- [ ] Repository cloned to `/rehman-travels/backen-alrehman`
- [ ] `.env` file created with production values
- [ ] GitHub Secrets configured (EC2_HOST, EC2_USERNAME, EC2_SSH_KEY)
- [ ] Security group configured (ports 22, 80, 443, 8000)
- [ ] Initial Docker containers running
- [ ] Database migrated
- [ ] Static files collected

Before each deployment:
- [ ] Test changes locally
- [ ] Update documentation if needed
- [ ] Commit changes with clear message
- [ ] Push to main branch
- [ ] Monitor GitHub Actions
- [ ] Verify application health after deployment

---

**Last Updated**: January 2025
