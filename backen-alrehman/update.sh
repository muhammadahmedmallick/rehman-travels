#!/bin/bash

# Rehman Travels - Quick Update Script
# Use this for deploying code changes (frontend or backend)

set -e  # Exit on error

echo "🚀 Starting update deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_step() {
    echo -e "${BLUE}➜${NC} $1"
}

# Step 1: Pull latest code
print_step "Pulling latest code from git..."
git pull origin main
print_status "Code updated"

# Step 2: Check what changed
print_info "Recent commits:"
git log --oneline -3

# Step 3: Determine what needs to be rebuilt
FRONTEND_CHANGED=false
BACKEND_CHANGED=false

# Check if frontend files changed in last commit
if git diff HEAD~1 HEAD --name-only | grep -q "cms-frontend/"; then
    FRONTEND_CHANGED=true
    print_info "Frontend changes detected"
fi

# Check if backend files changed in last commit
if git diff HEAD~1 HEAD --name-only | grep -E "(apps/|config/|requirements.txt)" | grep -v "cms-frontend"; then
    BACKEND_CHANGED=true
    print_info "Backend changes detected"
fi

# Step 4: Rebuild what changed (or rebuild all if unsure)
CACHEBUST=$(date +%s)

if [ "$FRONTEND_CHANGED" = true ] && [ "$BACKEND_CHANGED" = true ]; then
    print_step "Rebuilding both frontend and backend..."
    docker-compose build --no-cache --build-arg CACHEBUST=$CACHEBUST web cms
elif [ "$FRONTEND_CHANGED" = true ]; then
    print_step "Rebuilding frontend only..."
    docker-compose build --no-cache --build-arg CACHEBUST=$CACHEBUST cms
elif [ "$BACKEND_CHANGED" = true ]; then
    print_step "Rebuilding backend only..."
    docker-compose build --no-cache web
else
    print_info "No critical changes detected, rebuilding both to be safe..."
    docker-compose build --no-cache --build-arg CACHEBUST=$CACHEBUST web cms
fi

print_status "Build completed (cache-bust: $CACHEBUST)"

# Step 5: Restart containers
print_step "Restarting containers..."
docker-compose up -d
print_status "Containers restarted"

# Step 6: Wait for services to be ready
print_info "Waiting for services to start..."
sleep 10

# Step 7: Run migrations if backend changed
if [ "$BACKEND_CHANGED" = true ]; then
    print_step "Running database migrations..."
    docker-compose exec -T web python manage.py migrate --noinput || true
    print_status "Migrations completed"
fi

# Step 8: Collect static files
print_step "Collecting static files..."
docker-compose exec -T web python manage.py collectstatic --noinput || true
print_status "Static files collected"

# Step 9: Check service health
print_step "Checking service health..."
sleep 5

# Check if containers are running
SERVICES=("web" "cms" "nginx" "db" "postgres")
ALL_HEALTHY=true

for service in "${SERVICES[@]}"; do
    if docker-compose ps | grep -q "${service}.*Up"; then
        print_status "$service is running"
    else
        print_error "$service is not running"
        ALL_HEALTHY=false
    fi
done

# Step 10: Test API endpoint
print_step "Testing API endpoint..."
if curl -f http://localhost:8000/api/core/filter-config/flights/ > /dev/null 2>&1; then
    print_status "API is responding"
else
    print_error "API health check failed"
    ALL_HEALTHY=false
fi

# Step 11: Show summary
echo ""
echo "========================================="
if [ "$ALL_HEALTHY" = true ]; then
    echo -e "${GREEN}✅ Update Completed Successfully!${NC}"
else
    echo -e "${YELLOW}⚠️  Update completed with warnings${NC}"
fi
echo "========================================="
echo ""

if [ "$FRONTEND_CHANGED" = true ]; then
    echo -e "${BLUE}📱 Frontend Updated${NC}"
    echo "   - CMS rebuilt with latest code"
    echo "   - Clear browser cache to see changes"
fi

if [ "$BACKEND_CHANGED" = true ]; then
    echo -e "${BLUE}🔧 Backend Updated${NC}"
    echo "   - Django app restarted"
    echo "   - Migrations applied"
fi

echo ""
echo "📊 Container Status:"
docker-compose ps
echo ""
echo "💡 Useful Commands:"
echo "   View logs: docker-compose logs -f"
echo "   View specific logs: docker-compose logs -f web|cms|nginx"
echo "   Restart service: docker-compose restart web|cms"
echo "   Check migrations: docker-compose exec web python manage.py showmigrations"
echo ""

# Show recent logs if there were errors
if [ "$ALL_HEALTHY" = false ]; then
    echo -e "${YELLOW}📋 Recent logs:${NC}"
    docker-compose logs --tail=20
fi
