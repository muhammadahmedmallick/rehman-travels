#!/bin/bash

# Deployment Setup Verification Script
# This script verifies that your EC2 server and local environment are properly configured
# for GitHub Actions deployment

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
EC2_HOST="${EC2_HOST:-3.222.113.143}"
EC2_USERNAME="${EC2_USERNAME:-ubuntu}"
SSH_KEY_PATH="${SSH_KEY_PATH:-rehman-travels-key.pem}"
APP_DIR="/rehman-travels/backen-alrehman"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Deployment Setup Verification${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Function to run checks
run_check() {
    echo -e "${YELLOW}→${NC} $1"
}

# Track overall status
ERRORS=0

echo -e "${BLUE}1. Checking Local Environment${NC}"
echo "=================================="

# Check if SSH key exists
run_check "Checking SSH key file..."
if [ -f "$SSH_KEY_PATH" ]; then
    print_status 0 "SSH key found: $SSH_KEY_PATH"

    # Check SSH key permissions
    KEY_PERMS=$(stat -f "%A" "$SSH_KEY_PATH" 2>/dev/null || stat -c "%a" "$SSH_KEY_PATH" 2>/dev/null)
    if [ "$KEY_PERMS" = "400" ] || [ "$KEY_PERMS" = "600" ]; then
        print_status 0 "SSH key permissions are correct ($KEY_PERMS)"
    else
        print_status 1 "SSH key permissions are incorrect ($KEY_PERMS). Should be 400 or 600"
        echo -e "   ${YELLOW}Fix with: chmod 400 $SSH_KEY_PATH${NC}"
        ERRORS=$((ERRORS + 1))
    fi
else
    print_status 1 "SSH key not found: $SSH_KEY_PATH"
    echo -e "   ${YELLOW}Please provide the path to your .pem file${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${BLUE}2. Testing EC2 Connectivity${NC}"
echo "=================================="

# Test SSH connection
run_check "Testing SSH connection to EC2..."
if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "echo 'Connection successful'" &>/dev/null; then
    print_status 0 "SSH connection successful"
else
    print_status 1 "Cannot connect to EC2 via SSH"
    echo -e "   ${YELLOW}Check:${NC}"
    echo -e "   - EC2 instance is running"
    echo -e "   - Security Group allows SSH (port 22)"
    echo -e "   - Correct EC2_HOST: $EC2_HOST"
    echo -e "   - Correct EC2_USERNAME: $EC2_USERNAME"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${BLUE}3. Checking EC2 Server Setup${NC}"
echo "=================================="

# Check if application directory exists
run_check "Checking application directory..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "test -d $APP_DIR" 2>/dev/null; then
    print_status 0 "Application directory exists: $APP_DIR"
else
    print_status 1 "Application directory not found: $APP_DIR"
    echo -e "   ${YELLOW}Create it with:${NC}"
    echo -e "   ssh -i $SSH_KEY_PATH $EC2_USERNAME@$EC2_HOST"
    echo -e "   sudo mkdir -p /rehman-travels"
    echo -e "   cd /rehman-travels"
    echo -e "   git clone <your-repo-url> backen-alrehman"
    ERRORS=$((ERRORS + 1))
fi

# Check if Git is installed
run_check "Checking Git installation..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "command -v git" &>/dev/null; then
    GIT_VERSION=$(ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "git --version" 2>/dev/null)
    print_status 0 "Git is installed ($GIT_VERSION)"
else
    print_status 1 "Git is not installed"
    echo -e "   ${YELLOW}Install with: sudo apt install git -y${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Check if Docker is installed
run_check "Checking Docker installation..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "command -v docker" &>/dev/null; then
    DOCKER_VERSION=$(ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "docker --version" 2>/dev/null)
    print_status 0 "Docker is installed ($DOCKER_VERSION)"

    # Check if user has docker permissions
    run_check "Checking Docker permissions..."
    if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "docker ps" &>/dev/null; then
        print_status 0 "User can run Docker without sudo"
    else
        print_status 1 "User cannot run Docker (needs sudo or group membership)"
        echo -e "   ${YELLOW}Fix with:${NC}"
        echo -e "   sudo usermod -aG docker $EC2_USERNAME"
        echo -e "   Then logout and login again"
        ERRORS=$((ERRORS + 1))
    fi
else
    print_status 1 "Docker is not installed"
    echo -e "   ${YELLOW}Install with:${NC}"
    echo -e "   curl -fsSL https://get.docker.com -o get-docker.sh"
    echo -e "   sudo sh get-docker.sh"
    echo -e "   sudo usermod -aG docker $EC2_USERNAME"
    ERRORS=$((ERRORS + 1))
fi

# Check if Docker Compose is installed
run_check "Checking Docker Compose installation..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "command -v docker-compose" &>/dev/null; then
    COMPOSE_VERSION=$(ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "docker-compose --version" 2>/dev/null)
    print_status 0 "Docker Compose is installed ($COMPOSE_VERSION)"
else
    print_status 1 "Docker Compose is not installed"
    echo -e "   ${YELLOW}Install with:${NC}"
    echo -e "   sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose"
    echo -e "   sudo chmod +x /usr/local/bin/docker-compose"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${BLUE}4. Checking Application Files${NC}"
echo "=================================="

# Check if .env file exists
run_check "Checking .env file..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "test -f $APP_DIR/.env" 2>/dev/null; then
    print_status 0 ".env file exists"
else
    print_status 1 ".env file not found"
    echo -e "   ${YELLOW}Create it at: $APP_DIR/.env${NC}"
    echo -e "   See DEPLOYMENT_GUIDE.md for required variables"
    ERRORS=$((ERRORS + 1))
fi

# Check if docker-compose.yml exists
run_check "Checking docker-compose.yml..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "test -f $APP_DIR/docker-compose.yml" 2>/dev/null; then
    print_status 0 "docker-compose.yml exists"
else
    print_status 1 "docker-compose.yml not found"
    ERRORS=$((ERRORS + 1))
fi

# Check Git repository status
run_check "Checking Git repository..."
if ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "cd $APP_DIR && git status" &>/dev/null; then
    CURRENT_BRANCH=$(ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USERNAME@$EC2_HOST" "cd $APP_DIR && git branch --show-current" 2>/dev/null)
    print_status 0 "Git repository is valid (branch: $CURRENT_BRANCH)"

    # Check if on main branch
    if [ "$CURRENT_BRANCH" != "main" ]; then
        echo -e "   ${YELLOW}Warning: Not on main branch${NC}"
        echo -e "   ${YELLOW}Switch with: cd $APP_DIR && git checkout main${NC}"
    fi
else
    print_status 1 "Git repository invalid or not initialized"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${BLUE}5. Testing GitHub Actions Workflow${NC}"
echo "=================================="

# Check if workflow file exists locally
run_check "Checking workflow file..."
if [ -f ".github/workflows/deploy.yml" ]; then
    print_status 0 "GitHub Actions workflow file exists"
else
    print_status 1 "Workflow file not found: .github/workflows/deploy.yml"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo -e "${BLUE}6. GitHub Secrets Checklist${NC}"
echo "=================================="
echo ""
echo -e "Verify these secrets are configured in GitHub:"
echo -e "${YELLOW}Repository → Settings → Secrets and variables → Actions${NC}"
echo ""
echo "  [ ] EC2_HOST = $EC2_HOST"
echo "  [ ] EC2_USERNAME = $EC2_USERNAME"
echo "  [ ] EC2_SSH_KEY = (contents of $SSH_KEY_PATH)"
echo ""
echo "To get SSH key content:"
echo -e "${YELLOW}cat $SSH_KEY_PATH${NC}"
echo ""

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Verification Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Your deployment setup is ready. You can:"
    echo "1. Configure GitHub Secrets (see checklist above)"
    echo "2. Push to main branch to trigger automatic deployment"
    echo "3. Or manually trigger deployment from GitHub Actions"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Found $ERRORS issue(s)${NC}"
    echo ""
    echo "Please fix the issues above before deploying."
    echo "Refer to DEPLOYMENT_GUIDE.md for detailed setup instructions."
    echo ""
    exit 1
fi
