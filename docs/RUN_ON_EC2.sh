#!/bin/bash

# ========================================
# Run these commands ON YOUR EC2 SERVER
# ========================================

echo "=== Step 1: Check current Docker status ==="
docker ps
echo ""

echo "=== Step 2: Check if project directory exists ==="
ls -la /home/ubuntu | grep -E "(rehman|backen)"
echo ""

echo "=== Step 3: Check current location ==="
pwd
echo ""

# Uncomment and run the appropriate section below:

# ========================================
# OPTION A: If project directory exists
# ========================================
# cd /home/ubuntu/rehman-travels/backen-alrehman  # or wherever your project is
# git status
# git pull origin feature/handle-mobile-visa-feature  # or your branch
# sudo ./deploy.sh

# ========================================
# OPTION B: If project doesn't exist yet
# ========================================
# cd /home/ubuntu
# git clone YOUR-REPO-URL rehman-travels
# cd rehman-travels/backen-alrehman
# sudo ./deploy.sh

# ========================================
# After deployment, verify:
# ========================================
# docker-compose ps
# docker-compose logs cms --tail=20
# docker-compose logs nginx --tail=20
# curl http://localhost:3000
# curl http://localhost:80

echo "=== Commands above need to be run manually ==="
echo "Please uncomment and run the appropriate section"
