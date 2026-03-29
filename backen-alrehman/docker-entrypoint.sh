#!/bin/bash

# Docker entrypoint script for Rehman Travels Django Backend

echo "==================================="
echo "Rehman Travels Django - Starting..."
echo "==================================="

# Function to wait for a service
wait_for_service() {
  local host=$1
  local port=$2
  local service=$3
  local max_attempts=60
  local attempt=1

  echo "Waiting for $service ($host:$port)..."
  while ! nc -z "$host" "$port" 2>/dev/null; do
    if [ $attempt -eq $max_attempts ]; then
      echo "❌ $service failed to start after $max_attempts attempts"
      return 1
    fi
    echo "  Attempt $attempt/$max_attempts - $service not ready yet..."
    sleep 1
    ((attempt++))
  done
  echo "✅ $service is ready!"
  return 0
}

# Wait for PostgreSQL (default database) to be ready
wait_for_service "${DJANGO_DB_HOST:-postgres}" "${DJANGO_DB_PORT:-5432}" "PostgreSQL" || {
  echo "❌ PostgreSQL connection failed!"
  exit 1
}

# Wait for MySQL (legacy database) to be ready
wait_for_service "${LEGACY_DB_HOST:-db}" "${LEGACY_DB_PORT:-3306}" "MySQL" || {
  echo "⚠️  MySQL connection failed (may not be critical)"
}

# Wait for Redis to be ready
wait_for_service "redis" "6379" "Redis" || {
  echo "⚠️  Redis connection failed (cache may not work)"
}

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p /app/static /app/media /app/storage/AccessToken /app/logs

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear 2>/dev/null || echo "⚠️  Static files collection had issues (non-critical)"

# Run migrations for PostgreSQL (default database)
echo "Running PostgreSQL migrations..."
python manage.py migrate --database=default --noinput 2>/dev/null || echo "⚠️  PostgreSQL migrations had issues"

# Run fake migrations for MySQL (legacy database - read-only)
echo "Checking MySQL legacy database..."
python manage.py migrate --database=legacy --fake --noinput 2>/dev/null || echo "⚠️  MySQL legacy migrations had issues"

# Create superuser if it doesn't exist (for initial setup)
echo "Checking for superuser..."
python manage.py shell << 'EOF' 2>/dev/null
from django.contrib.auth.models import User

try:
    if not User.objects.filter(username='admin').exists():
        print("Creating superuser 'admin'...")
        User.objects.create_superuser('admin', 'admin@rehmantravel.com', 'admin123')
        print("✅ Superuser 'admin' created!")
    else:
        print("✅ Superuser 'admin' already exists")
except Exception as e:
    print(f"⚠️  Could not create/check superuser: {e}")
EOF

echo "==================================="
echo "✅ Django setup complete!"
echo "==================================="
echo "Starting application..."

# Execute the main command
exec "$@"
