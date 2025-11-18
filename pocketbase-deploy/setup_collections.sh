#!/bin/bash

# PocketBase Collections Setup Script
# This script creates the required collections via the PocketBase Admin API

POCKETBASE_URL="https://baby-tracker-pb-ashwanisingla-7054.fly.dev"

echo "PocketBase Collections Setup"
echo "============================"
echo ""
echo "This script will create the required collections in your PocketBase instance."
echo ""
read -p "Enter your admin email: " ADMIN_EMAIL
read -sp "Enter your admin password: " ADMIN_PASSWORD
echo ""
echo ""

# Login and get admin token
echo "Logging in..."
LOGIN_RESPONSE=$(curl -s -X POST "$POCKETBASE_URL/api/admins/auth-with-password" \
  -H "Content-Type: application/json" \
  -d "{\"identity\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}")

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed. Please check your credentials."
  exit 1
fi

echo "✓ Login successful"
echo ""

# Create baby_profiles collection
echo "Creating baby_profiles collection..."
curl -s -X POST "$POCKETBASE_URL/api/collections" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "baby_profiles",
    "type": "base",
    "schema": [
      {
        "name": "name",
        "type": "text",
        "required": true,
        "options": {
          "min": 1,
          "max": 100
        }
      },
      {
        "name": "birth_date",
        "type": "date",
        "required": true
      },
      {
        "name": "parents",
        "type": "relation",
        "required": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "maxSelect": null
        }
      }
    ],
    "listRule": "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    "viewRule": "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    "createRule": "@request.auth.id != \"\"",
    "updateRule": "@request.auth.id != \"\" && parents.id ?= @request.auth.id",
    "deleteRule": "@request.auth.id != \"\" && parents.id ?= @request.auth.id"
  }' > /dev/null

echo "✓ baby_profiles collection created"
echo ""

# Get baby_profiles collection ID
BABY_PROFILES_ID=$(curl -s "$POCKETBASE_URL/api/collections/baby_profiles" \
  -H "Authorization: $TOKEN" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)

# Create activities collection
echo "Creating activities collection..."
curl -s -X POST "$POCKETBASE_URL/api/collections" \
  -H "Authorization: $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"activities\",
    \"type\": \"base\",
    \"schema\": [
      {
        \"name\": \"baby_profile\",
        \"type\": \"relation\",
        \"required\": true,
        \"options\": {
          \"collectionId\": \"$BABY_PROFILES_ID\",
          \"cascadeDelete\": true,
          \"maxSelect\": 1
        }
      },
      {
        \"name\": \"type\",
        \"type\": \"text\",
        \"required\": true
      },
      {
        \"name\": \"timestamp\",
        \"type\": \"date\",
        \"required\": true
      },
      {
        \"name\": \"duration_minutes\",
        \"type\": \"number\",
        \"required\": false
      },
      {
        \"name\": \"sleep_end_time\",
        \"type\": \"date\",
        \"required\": false
      },
      {
        \"name\": \"notes\",
        \"type\": \"text\",
        \"required\": false,
        \"options\": {
          \"max\": 1000
        }
      },
      {
        \"name\": \"feed_type\",
        \"type\": \"text\",
        \"required\": false,
        \"options\": {
          \"max\": 50
        }
      },
      {
        \"name\": \"feed_amount\",
        \"type\": \"number\",
        \"required\": false
      },
      {
        \"name\": \"diaper_type\",
        \"type\": \"text\",
        \"required\": false,
        \"options\": {
          \"max\": 50
        }
      },
      {
        \"name\": \"local_id\",
        \"type\": \"text\",
        \"required\": false
      },
      {
        \"name\": \"user\",
        \"type\": \"relation\",
        \"required\": false,
        \"options\": {
          \"collectionId\": \"_pb_users_auth_\",
          \"cascadeDelete\": false,
          \"maxSelect\": 1
        }
      }
    ],
    \"listRule\": \"@request.auth.id != \\\"\\\" && baby_profile.parents.id ?= @request.auth.id\",
    \"viewRule\": \"@request.auth.id != \\\"\\\" && baby_profile.parents.id ?= @request.auth.id\",
    \"createRule\": \"@request.auth.id != \\\"\\\"\",
    \"updateRule\": \"@request.auth.id != \\\"\\\" && baby_profile.parents.id ?= @request.auth.id\",
    \"deleteRule\": \"@request.auth.id != \\\"\\\" && baby_profile.parents.id ?= @request.auth.id\"
  }" > /dev/null

echo "✓ activities collection created"
echo ""
echo "============================"
echo "✅ Setup complete!"
echo ""
echo "You can now use your app and it will sync to PocketBase."
echo "Visit $POCKETBASE_URL/_/ to manage your data."
