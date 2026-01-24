# Rehman Travels Django Backend - Docker Setup

This guide explains how to run the Rehman Travels Django backend using Docker and Docker Compose.

## 📋 Prerequisites

- **Docker Desktop** (includes Docker and Docker Compose)
  - macOS: [Download Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)
  - Windows: [Download Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
  - Linux: Install Docker Engine and Docker Compose separately

- Verify installation:
  ```bash
  docker --version
  docker-compose --version
  ```

## 🏗️ Architecture

The Docker Compose setup includes:

- **web** - Django application (port 8000)
- **db** - MySQL 8.0 database (port 3306)
- **redis** - Redis cache server (port 6379)
- **celery** - Celery worker for background tasks
- **celery-beat** - Celery beat for scheduled tasks

## 🚀 Quick Start

### 1. Build Docker Images

```bash
make build
# Or: docker-compose build
```

### 2. Start All Services

```bash
make up
# Or: docker-compose up -d
```

This will:
- Start MySQL database
- Start Redis cache
- Run Django migrations
- Create a default superuser (admin/admin123)
- Start Django web server at http://localhost:8000

### 3. Access the Application

- **Django Admin**: http://localhost:8000/admin/
  - Username: `admin`
  - Password: `admin123` (change this!)

- **API Root**: http://localhost:8000/api/

### 4. View Logs

```bash
make logs          # All containers
make logs-web      # Django only
make logs-db       # MySQL only
```

## 📊 Database Management

### Import Existing MySQL Backup

```bash
# The SQL backup should be at: ../rgttravelsrve1_maindb.sql
make db-import
```

This will:
1. Copy the SQL file to the database container
2. Import it into the `rehman_travels_laravel` database
3. Preserve all existing data and tables

### Access MySQL Shell

```bash
make db-shell
# Or: docker-compose exec db mysql -u root -prootpassword rehman_travels_laravel
```

### Backup Database

```bash
make db-backup
# Creates: backup_YYYYMMDD_HHMMSS.sql
```

### Generate Django Models from Database

After importing the SQL backup:

```bash
make inspectdb
# Creates: inspected_models.py
```

## 🛠️ Development Commands

### Django Management

```bash
# Run migrations
make migrate

# Create new migrations
make makemigrations

# Create superuser
make createsuperuser

# Collect static files
make collectstatic

# Django shell
make shell

# Check configuration
make check
```

### Container Management

```bash
# View running containers
make ps
# Or: docker-compose ps

# Restart services
make restart

# Stop services
make down

# Access web container bash
make bash
```

### Database Operations

```bash
# Run raw SQL query
docker-compose exec db mysql -u root -prootpassword rehman_travels_laravel -e "SHOW TABLES;"

# Check database size
docker-compose exec db mysql -u root -prootpassword rehman_travels_laravel -e "
  SELECT
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
  FROM information_schema.TABLES
  WHERE table_schema = 'rehman_travels_laravel'
  ORDER BY (data_length + index_length) DESC;"
```

## 🧪 Testing

```bash
# Run all tests
make test

# Run specific test
docker-compose exec web python manage.py test apps.accounts.tests
```

## 🔍 Debugging

### View Container Logs

```bash
# Real-time logs for all services
docker-compose logs -f

# Logs for specific service
docker-compose logs -f web
docker-compose logs -f db
docker-compose logs -f redis
```

### Inspect Container

```bash
# Enter web container
docker-compose exec web bash

# Check Python packages
docker-compose exec web pip list

# Check Django settings
docker-compose exec web python manage.py diffsettings
```

### Database Debugging

```bash
# Check if database is accepting connections
docker-compose exec db mysqladmin ping -h localhost -u root -prootpassword

# Show database users
docker-compose exec db mysql -u root -prootpassword -e "SELECT User, Host FROM mysql.user;"

# Show databases
docker-compose exec db mysql -u root -prootpassword -e "SHOW DATABASES;"
```

## 🔧 Common Issues & Solutions

### Issue: Port Already in Use

```bash
# Find process using port 3306 (MySQL)
lsof -i :3306

# Or port 8000 (Django)
lsof -i :8000

# Kill the process or change ports in docker-compose.yml
```

### Issue: Database Connection Refused

```bash
# Check if MySQL container is healthy
docker-compose ps

# View MySQL logs
docker-compose logs db

# Restart database
docker-compose restart db
```

### Issue: Migrations Fail

```bash
# Check database exists
make db-shell
SHOW DATABASES;
USE rehman_travels_laravel;
SHOW TABLES;

# Run migrations manually
docker-compose exec web python manage.py migrate --fake-initial
```

### Issue: Static Files Not Loading

```bash
# Collect static files
make collectstatic

# Check static file location
docker-compose exec web ls -la /app/staticfiles
```

## 🧹 Cleanup

### Remove Containers

```bash
make down
# Or: docker-compose down
```

### Remove Containers and Volumes (⚠️ This deletes database data!)

```bash
make clean
# Or: docker-compose down -v
```

### Rebuild from Scratch

```bash
make rebuild
# This stops containers, rebuilds images, and starts fresh
```

## 📦 Environment Variables

Configuration is managed through `.env` file:

```bash
# Copy example environment file
cp .env .env.docker

# Edit for Docker environment
# DB_HOST=db (not localhost!)
# REDIS_URL=redis://redis:6379/1
```

## 🔄 Updating Dependencies

### Add New Python Package

```bash
# Option 1: Using Makefile
make pip-install PACKAGE=package-name

# Option 2: Manual
docker-compose exec web pip install package-name
docker-compose exec web pip freeze > requirements.txt
docker-compose build web
docker-compose up -d
```

### Update Existing Packages

```bash
# Edit requirements.txt
# Then rebuild
make rebuild
```

## 📊 Production Deployment

For production deployment:

1. **Update environment variables**:
   ```bash
   DEBUG=False
   ALLOWED_HOSTS=yourdomain.com
   SECRET_KEY=generate-secure-key-here
   DB_PASSWORD=strong-password-here
   ```

2. **Use production Docker Compose**:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
   ```

3. **Add Nginx reverse proxy** (recommended)

4. **Set up SSL certificates**

5. **Configure proper backup strategy**

## 📚 Additional Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Hub](https://hub.docker.com/_/mysql)
- [Redis Docker Hub](https://hub.docker.com/_/redis)

## 🆘 Getting Help

If you encounter issues:

1. Check container logs: `make logs`
2. Verify services are running: `make ps`
3. Check database connectivity: `make db-shell`
4. Review Django configuration: `make check`

## 📝 Next Steps

After Docker setup:

1. ✅ Import SQL backup: `make db-import`
2. ✅ Generate Django models: `make inspectdb`
3. ✅ Configure Django admin
4. ✅ Set up REST API endpoints
5. ✅ Configure authentication
6. ✅ Test application functionality

---

**Project**: Rehman Travels Django Backend
**Version**: 1.0.0
**Last Updated**: January 2026
