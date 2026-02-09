#!/bin/bash

# Initial EC2 Setup Script for First-Time Deployment
# This script prepares your EC2 server for GitHub Actions deployment

set -e

# Configuration
EC2_HOST="${EC2_HOST:-3.222.113.143}"
EC2_USERNAME="${EC2_USERNAME:-ubuntu}"
SSH_KEY_PATH="${SSH_KEY_PATH:-../rehman-travels-key.pem}"
REPO_URL="https://github.com/muhammadahmedmallick/rehman-travels.git"
APP_DIR="/rehman-travels/backen-alrehman"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Initial EC2 Server Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check SSH key exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo -e "${RED}Error: SSH key not found at $SSH_KEY_PATH${NC}"
    echo "Please provide the correct path: ./initial-ec2-setup.sh /path/to/key.pem"
    exit 1
fi

# Test SSH connection
echo -e "${YELLOW}→${NC} Testing SSH connection..."
if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "echo 'Connected'" >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} SSH connection successful"
else
    echo -e "${RED}✗${NC} Cannot connect to EC2. Check your SSH key and host."
    exit 1
fi

echo ""
echo -e "${BLUE}Step 1: Installing Required Software${NC}"
echo "======================================"

ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" << 'ENDSSH'
set -e

echo "Updating system packages..."
sudo apt update -y

echo "Installing Git..."
sudo apt install git -y

echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

echo "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✓ Docker Compose installed"
else
    echo "✓ Docker Compose already installed"
fi

# Verify installations
echo ""
echo "Installed versions:"
git --version
docker --version
docker-compose --version

ENDSSH

echo -e "${GREEN}✓${NC} Software installation complete"

echo ""
echo -e "${BLUE}Step 2: Setting Up Application Directory${NC}"
echo "======================================"

ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" << ENDSSH
set -e

# Create parent directory
echo "Creating directory structure..."
sudo mkdir -p /rehman-travels
sudo chown $USER:$USER /rehman-travels
cd /rehman-travels

# Clone repository
if [ -d "backen-alrehman" ]; then
    echo "Repository already exists, updating..."
    cd backen-alrehman
    git fetch origin main
    git checkout main
    git pull origin main
else
    echo "Cloning repository..."
    git clone $REPO_URL
    cd rehman-travels

    # The repo structure is nested, need to access the backend
    echo "Repository cloned to /rehman-travels/rehman-travels"
    echo "Note: Will need to adjust deployment script"
fi

echo "✓ Repository set up complete"

ENDSSH

echo -e "${GREEN}✓${NC} Application directory created"

echo ""
echo -e "${BLUE}Step 3: Creating Environment File${NC}"
echo "======================================"

echo ""
echo -e "${YELLOW}You need to create a .env file on the EC2 server.${NC}"
echo ""
echo "I'll open an SSH session for you. Please:"
echo "1. Create the .env file: nano /rehman-travels/backen-alrehman/.env"
echo "2. Copy the environment variables from your local .env"
echo "3. Save and exit (Ctrl+X, Y, Enter)"
echo ""
echo -e "${YELLOW}Press Enter to SSH into EC2...${NC}"
read

ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Verify .env file exists on EC2"
echo "2. Run initial Docker setup:"
echo "   ssh -i $SSH_KEY_PATH $EC2_USERNAME@$EC2_HOST"
echo "   cd /rehman-travels/backen-alrehman"
echo "   docker-compose up -d"
echo ""
echo "3. Then trigger GitHub Actions deployment!"
echo ""
