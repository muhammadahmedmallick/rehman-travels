#!/bin/bash

# Quick start script for Docker environment

echo "==================================="
echo "Rehman Travels Django - Docker Setup"
echo "==================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"

# Check if docker-compose exists
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: docker-compose not found!"
    echo "Please install Docker Compose."
    exit 1
fi

echo "✅ Docker Compose is installed"

# Copy .env.docker to .env if .env doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.docker..."
    cp .env.docker .env
fi

echo "==================================="
echo "Building Docker images..."
echo "==================================="
docker-compose build

echo "==================================="
echo "Starting containers..."
echo "==================================="
docker-compose up -d

echo ""
echo "==================================="
echo "✅ Setup complete!"
echo "==================================="
echo ""
echo "🌐 Django is running at: http://localhost:8000"
echo "🔑 Admin panel: http://localhost:8000/admin/"
echo "   Username: admin"
echo "   Password: admin123 (change this!)"
echo ""
echo "📊 Useful commands:"
echo "   make logs        - View logs"
echo "   make db-import   - Import SQL backup"
echo "   make inspectdb   - Generate models from database"
echo "   make bash        - Access container shell"
echo "   make down        - Stop containers"
echo ""
echo "==================================="
