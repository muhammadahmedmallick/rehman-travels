#!/bin/bash

# Laravel Local Setup Script for Rehman Travels
# This script will set up and run the Laravel application locally

set -e  # Exit on error

echo "========================================="
echo "Rehman Travels - Local Setup"
echo "========================================="
echo ""

# Navigate to application directory
cd "$(dirname "$0")/legacy-app/rehman-travels"

echo "Step 1: Checking PHP installation..."
if ! command -v php &> /dev/null; then
    echo "❌ PHP is not installed"
    echo "Please run: brew install php@8.2 && brew link php@8.2 --force --overwrite"
    exit 1
else
    PHP_VERSION=$(php -v | head -n 1)
    echo "✅ PHP is installed: $PHP_VERSION"
fi

echo ""
echo "Step 2: Checking Composer installation..."
if ! command -v composer &> /dev/null; then
    echo "❌ Composer is not installed"
    echo "Please run: brew install composer"
    exit 1
else
    COMPOSER_VERSION=$(composer --version | head -n 1)
    echo "✅ Composer is installed: $COMPOSER_VERSION"
fi

echo ""
echo "Step 3: Installing/Updating PHP dependencies..."
composer install --no-interaction

echo ""
echo "Step 4: Checking .env file..."
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created"
else
    echo "✅ .env file exists"
fi

echo ""
echo "Step 5: Generating application key..."
if grep -q "APP_KEY=$" .env; then
    php artisan key:generate
    echo "✅ Application key generated"
else
    echo "✅ Application key already exists"
fi

echo ""
echo "Step 6: Installing/Updating Node dependencies..."
npm install

echo ""
echo "Step 7: Checking storage permissions..."
chmod -R 775 storage bootstrap/cache
echo "✅ Storage permissions set"

echo ""
echo "========================================="
echo "✅ Setup Complete!"
echo "========================================="
echo ""
echo "To start the application, run these commands in separate terminals:"
echo ""
echo "Terminal 1 (Laravel server):"
echo "  cd legacy-app/rehman-travels"
echo "  php artisan serve"
echo ""
echo "Terminal 2 (Vite dev server):"
echo "  cd legacy-app/rehman-travels"
echo "  npm run dev"
echo ""
echo "Then visit: http://localhost:8000"
echo ""
echo "========================================="
echo "Optional: Database Setup"
echo "========================================="
echo ""
echo "If you need to set up the database:"
echo "1. Update .env with your MySQL credentials"
echo "2. Run: php artisan migrate"
echo ""
