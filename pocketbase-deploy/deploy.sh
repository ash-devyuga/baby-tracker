#!/bin/bash

# Baby Tracker PocketBase Deployment Script
# This script automates the deployment of PocketBase to Fly.io

set -e

echo "🚀 Baby Tracker PocketBase Deployment"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect fly command location
FLY_CMD="fly"

# Check if fly CLI is installed
if ! command -v fly &> /dev/null; then
    # Check common installation locations
    if [ -f "$HOME/.fly/bin/flyctl" ]; then
        FLY_CMD="$HOME/.fly/bin/flyctl"
    elif [ -f "$HOME/.fly/bin/fly" ]; then
        FLY_CMD="$HOME/.fly/bin/fly"
    else
        echo -e "${RED}❌ Fly CLI not found!${NC}"
        echo ""
        echo "Installing Fly CLI..."

        if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
            curl -L https://fly.io/install.sh | sh

            # Set fly command to the newly installed location
            if [ -f "$HOME/.fly/bin/flyctl" ]; then
                FLY_CMD="$HOME/.fly/bin/flyctl"
            elif [ -f "$HOME/.fly/bin/fly" ]; then
                FLY_CMD="$HOME/.fly/bin/fly"
            fi

            echo ""
            echo -e "${GREEN}✓ Fly CLI installed successfully${NC}"
            echo -e "${YELLOW}Note: You may need to add ~/.fly/bin to your PATH${NC}"
            echo ""
        else
            echo -e "${RED}Please install Fly CLI manually:${NC}"
            echo "https://fly.io/docs/hands-on/install-flyctl/"
            exit 1
        fi
    fi
else
    # fly is in PATH
    FLY_CMD="fly"
fi

echo -e "${GREEN}✓ Fly CLI is available${NC}"
echo ""

# Check if user is logged in
if ! $FLY_CMD auth whoami &> /dev/null; then
    echo -e "${YELLOW}⚠ You need to login to Fly.io${NC}"
    echo ""
    echo "Choose an option:"
    echo "1. Sign up for a new account"
    echo "2. Login to existing account"
    read -p "Enter choice (1 or 2): " choice

    if [ "$choice" == "1" ]; then
        $FLY_CMD auth signup
    else
        $FLY_CMD auth login
    fi
fi

echo -e "${GREEN}✓ Logged in to Fly.io${NC}"
echo ""

# Generate unique app name
USERNAME=$(whoami)
TIMESTAMP=$(date +%s)
APP_NAME="baby-tracker-pb-${USERNAME}-${TIMESTAMP: -4}"

echo -e "${BLUE}📝 Configuration:${NC}"
echo "   App Name: $APP_NAME"
echo "   Region: iad (US East)"
echo ""

# Update fly.toml with generated app name
sed -i.bak "s/app = \"baby-tracker-pb\"/app = \"$APP_NAME\"/" fly.toml

echo -e "${YELLOW}⏳ Creating persistent volume...${NC}"
if $FLY_CMD volumes create pb_data --size 1 --region iad --yes; then
    echo -e "${GREEN}✓ Volume created successfully${NC}"
else
    echo -e "${YELLOW}⚠ Volume might already exist, continuing...${NC}"
fi
echo ""

echo -e "${YELLOW}⏳ Deploying PocketBase to Fly.io...${NC}"
echo "   This may take 2-3 minutes..."
echo ""

if $FLY_CMD deploy --now; then
    echo ""
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo ""

    # Get the app URL
    APP_URL="https://${APP_NAME}.fly.dev"

    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 Your PocketBase is now live!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}📍 PocketBase URL:${NC}"
    echo "   $APP_URL"
    echo ""
    echo -e "${BLUE}🔧 Admin Panel:${NC}"
    echo "   ${APP_URL}/_/"
    echo ""
    echo -e "${BLUE}📱 Next Steps:${NC}"
    echo "   1. Open admin panel and create your admin account"
    echo "   2. Collections are automatically created!"
    echo "   3. Update your Flutter app:"
    echo ""
    echo -e "${YELLOW}      Open: lib/services/pocketbase_service.dart${NC}"
    echo -e "${YELLOW}      Change: static const String pocketBaseUrl = '$APP_URL';${NC}"
    echo ""
    echo "   4. Run: flutter pub get && flutter run"
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Save URL to a file for easy reference
    echo "$APP_URL" > pocketbase_url.txt
    echo -e "${GREEN}✓ URL saved to pocketbase_url.txt${NC}"
    echo ""

    # Ask if user wants to open admin panel
    read -p "Open admin panel in browser? (y/n): " open_browser
    if [ "$open_browser" == "y" ]; then
        if command -v open &> /dev/null; then
            open "${APP_URL}/_/"
        elif command -v xdg-open &> /dev/null; then
            xdg-open "${APP_URL}/_/"
        else
            echo "Please open: ${APP_URL}/_/"
        fi
    fi

    # Ask if user wants to update the Flutter app automatically
    read -p "Update Flutter app with PocketBase URL automatically? (y/n): " update_app
    if [ "$update_app" == "y" ]; then
        POCKETBASE_SERVICE="../lib/services/pocketbase_service.dart"
        if [ -f "$POCKETBASE_SERVICE" ]; then
            # Create backup
            cp "$POCKETBASE_SERVICE" "${POCKETBASE_SERVICE}.bak"

            # Update the URL
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s|static const String pocketBaseUrl = .*|static const String pocketBaseUrl = '$APP_URL';|" "$POCKETBASE_SERVICE"
            else
                sed -i "s|static const String pocketBaseUrl = .*|static const String pocketBaseUrl = '$APP_URL';|" "$POCKETBASE_SERVICE"
            fi

            echo -e "${GREEN}✓ Flutter app updated with PocketBase URL${NC}"
            echo -e "${YELLOW}  (Backup saved to: ${POCKETBASE_SERVICE}.bak)${NC}"
            echo ""
            echo "Run these commands to use the updated app:"
            echo "  cd .."
            echo "  flutter pub get"
            echo "  flutter run"
        else
            echo -e "${RED}❌ Could not find pocketbase_service.dart${NC}"
        fi
    fi

else
    echo ""
    echo -e "${RED}❌ Deployment failed${NC}"
    echo "Please check the error messages above and try again."
    echo ""
    echo "Common issues:"
    echo "  - App name already taken (change app name in fly.toml)"
    echo "  - Network issues (check your internet connection)"
    echo "  - No credit card on file (Fly.io requires one, but won't charge)"
    exit 1
fi

# Restore backup
mv fly.toml.bak fly.toml.backup 2>/dev/null || true

echo ""
echo -e "${BLUE}📊 Useful Commands:${NC}"
echo "  $FLY_CMD status              - Check app status"
echo "  $FLY_CMD logs                - View app logs"
echo "  $FLY_CMD dashboard           - Open Fly.io dashboard"
echo "  $FLY_CMD ssh console         - SSH into your app"
echo ""
echo -e "${GREEN}Happy baby tracking! 👶❤️${NC}"
echo ""
