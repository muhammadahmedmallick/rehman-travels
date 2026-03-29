#!/bin/bash

# Script to copy fixed migration files to EC2 instance
# Usage: ./fix-migrations-ec2.sh your-key.pem ec2-user@your-ec2-ip

if [ $# -lt 2 ]; then
    echo "Usage: $0 <key.pem> <ec2-user@ec2-ip>"
    echo "Example: $0 ~/.ssh/my-key.pem ec2-user@3.222.113.143"
    exit 1
fi

KEY=$1
EC2=$2

echo "========================================"
echo "Copying Fixed Migration Files to EC2"
echo "========================================"
echo ""

# Define the apps with migrations
APPS=("accounts" "core" "ticketing" "umrah" "cms" "payments" "hotels" "mobile")

# Change to the backen-alrehman directory
cd backen-alrehman

for APP in "${APPS[@]}"; do
    MIGRATION_FILE="apps/${APP}/migrations/0001_initial.py"

    if [ -f "$MIGRATION_FILE" ]; then
        echo "Copying ${APP} migration..."
        scp -i "$KEY" "$MIGRATION_FILE" "${EC2}:backen-alrehman/apps/${APP}/migrations/0001_initial.py"
        if [ $? -eq 0 ]; then
            echo "✅ ${APP} - success"
        else
            echo "❌ ${APP} - failed"
        fi
    else
        echo "⚠️  ${APP} - file not found: $MIGRATION_FILE"
    fi
done

echo ""
echo "========================================"
echo "Files copied! Now run on EC2:"
echo "========================================"
echo ""
echo "ssh -i $KEY $EC2"
echo "cd backen-alrehman"
echo "docker-compose exec -T web python manage.py migrate --database=default"
echo "docker-compose exec -T web python manage.py migrate --database=legacy --fake"
echo ""
