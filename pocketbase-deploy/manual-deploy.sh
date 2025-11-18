#!/bin/bash

# Manual Deployment Script for PocketBase
# Run this in your terminal where Fly CLI is available

set -e

echo "🚀 Manual PocketBase Deployment"
echo "================================"
echo ""

# App configuration
APP_NAME="baby-tracker-pb-$(whoami)-$(date +%s | tail -c 5)"
REGION="iad"

echo "App Name: $APP_NAME"
echo "Region: $REGION (US East)"
echo ""

# Step 1: Create the app
echo "Step 1/4: Creating Fly.io app..."
fly apps create "$APP_NAME" --org personal

echo ""
echo "✓ App created"
echo ""

# Step 2: Create persistent volume
echo "Step 2/4: Creating persistent volume (1GB)..."
fly volumes create pb_data --size 1 --region "$REGION" --app "$APP_NAME" --yes

echo ""
echo "✓ Volume created"
echo ""

# Step 3: Update fly.toml
echo "Step 3/4: Updating configuration..."
sed -i.bak "s/app = \"baby-tracker-pb\"/app = \"$APP_NAME\"/" fly.toml

echo "✓ Configuration updated"
echo ""

# Step 4: Deploy
echo "Step 4/4: Deploying PocketBase (this takes 2-3 minutes)..."
fly deploy --app "$APP_NAME"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Deployment Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Your PocketBase URL:"
echo "   https://${APP_NAME}.fly.dev"
echo ""
echo "🔧 Admin Panel:"
echo "   https://${APP_NAME}.fly.dev/_/"
echo ""
echo "📝 Next Steps:"
echo "   1. Visit the admin panel and create your account"
echo "   2. Collections are automatically created!"
echo "   3. Update lib/services/pocketbase_service.dart with:"
echo "      static const String pocketBaseUrl = 'https://${APP_NAME}.fly.dev';"
echo "   4. Run: flutter pub get && flutter run"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Save URL for reference
echo "https://${APP_NAME}.fly.dev" > pocketbase_url.txt
echo ""
echo "✓ URL saved to pocketbase_url.txt"
echo ""
