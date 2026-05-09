#!/bin/bash

# Rehman Travels - Deployment Script for EC2
# This script deploys both Django backend and React CMS

set -e  # Exit on error

echo "🚀 Starting deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root or with sudo"
    exit 1
fi

# Step 1: Update system packages
print_info "Updating system packages..."
apt-get update -qq
print_status "System packages updated"

# Step 2: Install Docker if not installed
if ! command -v docker &> /dev/null; then
    print_info "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
    print_status "Docker installed"
else
    print_status "Docker already installed"
fi

# Step 3: Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    print_info "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    print_status "Docker Compose installed"
else
    print_status "Docker Compose already installed"
fi

# Step 4: Stop existing containers
print_info "Stopping existing containers..."
docker-compose down || true
print_status "Containers stopped"

# Step 5: Build React CMS
print_info "Building React CMS..."
cd cms-frontend
npm install --legacy-peer-deps
cd ..
print_status "React CMS dependencies installed"

# Step 6: Build and start containers
print_info "Building Docker images..."
# Use CACHEBUST to ensure fresh builds, especially for CMS
CACHEBUST=$(date +%s)
docker-compose build --no-cache --build-arg CACHEBUST=$CACHEBUST
print_status "Docker images built (cache-bust: $CACHEBUST)"

print_info "Starting containers..."
docker-compose up -d
print_status "Containers started"

# Step 7: Wait for services to be healthy
print_info "Waiting for services to be ready..."
sleep 10

# Step 8: Run database migrations
print_info "Running database migrations..."
docker-compose exec -T web python manage.py migrate --database=default
print_status "Migrations completed"

# Step 9: Collect static files
print_info "Collecting static files..."
docker-compose exec -T web python manage.py collectstatic --noinput || true
print_status "Static files collected"

# Step 10: Check service health
print_info "Checking service health..."
sleep 5

# Check Django
if docker-compose ps | grep -q "web.*Up"; then
    print_status "Django backend is running"
else
    print_error "Django backend failed to start"
    docker-compose logs web
    exit 1
fi

# Check React CMS
if docker-compose ps | grep -q "cms.*Up"; then
    print_status "React CMS is running"
else
    print_error "React CMS failed to start"
    docker-compose logs cms
    exit 1
fi

# Check Nginx
if docker-compose ps | grep -q "nginx.*Up"; then
    print_status "Nginx reverse proxy is running"
else
    print_error "Nginx failed to start"
    docker-compose logs nginx
    exit 1
fi

# Step 11: Display access information
echo ""
echo "========================================="
echo "✅ Deployment Completed Successfully!"
echo "========================================="
echo ""
echo "📍 Access Points:"
echo "   Main Entry: http://$(curl -s ifconfig.me)"
echo "   Django Admin: http://$(curl -s ifconfig.me)/admin/"
echo "   Django API: http://$(curl -s ifconfig.me)/api/"
echo "   React CMS: http://$(curl -s ifconfig.me)/"
echo ""
echo "🔧 Direct Ports (for testing):"
echo "   Django: http://$(curl -s ifconfig.me):8000"
echo "   React CMS: http://$(curl -s ifconfig.me):3000"
echo ""
echo "📊 Container Status:"
docker-compose ps
echo ""
echo "💡 Useful Commands:"
echo "   View logs: docker-compose logs -f"
echo "   Stop all: docker-compose down"
echo "   Restart: docker-compose restart"
echo "   Update: git pull && ./deploy.sh"
echo ""
