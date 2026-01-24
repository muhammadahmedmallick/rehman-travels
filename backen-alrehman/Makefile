.PHONY: help build up down restart logs shell migrate makemigrations createsuperuser test clean db-import db-backup

# Default target
help:
	@echo "==================================="
	@echo "Rehman Travels Django - Docker Commands"
	@echo "==================================="
	@echo "make build          - Build Docker images"
	@echo "make up             - Start all containers"
	@echo "make down           - Stop all containers"
	@echo "make restart        - Restart all containers"
	@echo "make logs           - View logs from all containers"
	@echo "make logs-web       - View Django web logs"
	@echo "make logs-db        - View MySQL logs"
	@echo "make shell          - Open Django shell"
	@echo "make bash           - Open bash in web container"
	@echo "make migrate        - Run database migrations"
	@echo "make makemigrations - Create new migrations"
	@echo "make createsuperuser- Create Django superuser"
	@echo "make collectstatic  - Collect static files"
	@echo "make test           - Run tests"
	@echo "make clean          - Remove containers and volumes"
	@echo "make db-import      - Import SQL backup to database"
	@echo "make db-backup      - Backup database to SQL file"
	@echo "make db-shell       - Open MySQL shell"
	@echo "make inspectdb      - Generate models from existing database"
	@echo "==================================="

# Build Docker images
build:
	docker-compose build

# Start containers
up:
	docker-compose up -d
	@echo "Containers started! Django is running at http://localhost:8000"
	@echo "Admin panel: http://localhost:8000/admin/"
	@echo "Use 'make logs' to view logs"

# Stop containers
down:
	docker-compose down

# Restart containers
restart:
	docker-compose restart

# View logs
logs:
	docker-compose logs -f

# View Django web logs
logs-web:
	docker-compose logs -f web

exec:
	docker-compose exec web bash

# View MySQL logs
logs-db:
	docker-compose logs -f db

# Open Django shell
shell:
	docker-compose exec web python manage.py shell

# Open bash in web container
bash:
	docker-compose exec web bash

# Run migrations
migrate:
	docker-compose exec web python manage.py migrate

# Create migrations
makemigrations:
	docker-compose exec web python manage.py makemigrations

# Create superuser
createsuperuser:
	docker-compose exec web python manage.py createsuperuser

# Collect static files
collectstatic:
	docker-compose exec web python manage.py collectstatic --noinput

# Run tests
test:
	docker-compose exec web python manage.py test

# Clean up containers and volumes
clean:
	docker-compose down -v
	@echo "Containers and volumes removed"

# Import SQL backup to database
db-import:
	@echo "Copying SQL backup to database container..."
	docker cp ../rgttravelsrve1_maindb.sql rehman_travels_db:/tmp/backup.sql
	@echo "Importing database..."
	docker-compose exec db mysql -u root -prootpassword rehman_travels_laravel < /tmp/backup.sql || \
	docker-compose exec db sh -c "mysql -u root -prootpassword rehman_travels_laravel < /tmp/backup.sql"
	@echo "Database imported successfully!"

# Backup database to SQL file
db-backup:
	@echo "Creating database backup..."
	docker-compose exec db mysqldump -u root -prootpassword rehman_travels_laravel > backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backup created!"

# Open MySQL shell
db-shell:
	docker-compose exec db mysql -u root -prootpassword rehman_travels_laravel

# Generate Django models from existing database
inspectdb:
	docker-compose exec web python manage.py inspectdb > inspected_models.py
	@echo "Models generated in inspected_models.py"

# Check Django configuration
check:
	docker-compose exec web python manage.py check

# View running containers
ps:
	docker-compose ps

# Rebuild and restart
rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d

# Install new Python packages
pip-install:
	docker-compose exec web pip install $(PACKAGE)
	docker-compose exec web pip freeze > requirements.txt
	@echo "Package installed and requirements.txt updated"
