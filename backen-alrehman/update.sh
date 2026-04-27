#!/bin/bash

# Quick update script for Rehman Travels
# Use this for quick updates without full rebuild

set -e

echo "🔄 Updating Rehman Travels..."

# Pull latest code
git pull origin main

# Rebuild and restart only changed services
docker-compose up -d --build

# Run migrations
docker-compose exec -T web python manage.py migrate --database=default

echo "✅ Update completed!"
echo "View logs: docker-compose logs -f"
