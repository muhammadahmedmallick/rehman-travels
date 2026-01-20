#!/bin/bash

# Quick start script for Rehman Travels local development

echo "========================================="
echo "Starting Rehman Travels Application"
echo "========================================="
echo ""

cd "$(dirname "$0")/legacy-app/rehman-travels"

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "❌ ERROR: PHP is not installed"
    echo ""
    echo "Please install PHP first:"
    echo "  brew install php@8.2"
    echo "  brew link php@8.2 --force --overwrite"
    exit 1
fi

# Check if composer is installed
if ! command -v composer &> /dev/null; then
    echo "❌ ERROR: Composer is not installed"
    echo ""
    echo "Please install Composer first:"
    echo "  brew install composer"
    exit 1
fi

echo "Starting servers..."
echo ""
echo "Laravel server will start on: http://localhost:8000"
echo "Vite dev server will start automatically"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Start both servers using a process manager
# Laravel server in background
php artisan serve &
LARAVEL_PID=$!

# Vite dev server in background
npm run dev &
VITE_PID=$!

# Trap Ctrl+C and kill both processes
trap "echo ''; echo 'Stopping servers...'; kill $LARAVEL_PID $VITE_PID 2>/dev/null; exit" INT

# Wait for both processes
wait
