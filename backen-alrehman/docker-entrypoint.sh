#!/bin/bash

# Docker entrypoint script for Rehman Travels Django Backend

set -e

echo "==================================="
echo "Rehman Travels Django - Starting..."
echo "==================================="

# Wait for MySQL to be ready
echo "Waiting for MySQL database..."
while ! nc -z $DB_HOST $DB_PORT; do
  sleep 0.5
done
echo "MySQL is ready!"

# Wait for Redis to be ready
echo "Waiting for Redis..."
while ! nc -z redis 6379; do
  sleep 0.5
done
echo "Redis is ready!"

# Create necessary directories
mkdir -p /app/static /app/media /app/storage/AccessToken /app/logs

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear || echo "Static files collection failed (non-critical)"

# Run migrations
echo "Running database migrations..."
python manage.py migrate --noinput || echo "Migration failed - database may need manual setup"

# Create superuser if it doesn't exist (for initial setup)
echo "Checking for superuser..."
python manage.py shell << EOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='admin').exists():
    print("Creating superuser 'admin'...")
    # Note: Change this password in production!
    User.objects.create_superuser('admin', 'admin@rehmantravel.com', 'admin123')
    print("Superuser created!")
else:
    print("Superuser already exists")
EOF

echo "==================================="
echo "Django setup complete!"
echo "==================================="

# Execute the main command
exec "$@"
