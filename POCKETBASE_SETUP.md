# PocketBase Setup Guide for Baby Tracker App

This guide will help you set up PocketBase as a free, self-hosted backend for syncing baby tracking data between both parents.

## What is PocketBase?

PocketBase is a free, open-source backend that provides:
- User authentication
- Real-time database
- Data synchronization
- **100% FREE** - no monthly costs
- Self-hosted on your own server or cloud

## Prerequisites

- A server or computer that can run 24/7 (or use a free cloud service)
- Basic command line knowledge

## Option 1: Local Setup (For Testing)

### Step 1: Download PocketBase

1. Visit https://pocketbase.io/docs/
2. Download the appropriate version for your system:
   - **macOS**: `pocketbase_x.x.x_darwin_amd64.zip` (Intel) or `pocketbase_x.x.x_darwin_arm64.zip` (Apple Silicon)
   - **Windows**: `pocketbase_x.x.x_windows_amd64.zip`
   - **Linux**: `pocketbase_x.x.x_linux_amd64.zip`

### Step 2: Extract and Run

```bash
# Extract the downloaded file
unzip pocketbase_*.zip

# Run PocketBase
./pocketbase serve
```

PocketBase will start on `http://127.0.0.1:8090`

### Step 3: Create Admin Account

1. Open your browser and go to `http://127.0.0.1:8090/_/`
2. Create an admin account (email + password)
3. You'll be logged into the PocketBase Admin UI

### Step 4: Create Collections

#### A. Create `baby_profiles` collection

1. Click "New Collection" → "Base Collection"
2. Name: `baby_profiles`
3. Add fields:
   - `name` (Text, Required)
   - `birth_date` (Date, Required)
   - `parents` (Relation, Multiple, to `users` collection)

4. Set API Rules:
   - **List/Search**: `@request.auth.id != "" && parents.id ?= @request.auth.id`
   - **View**: `@request.auth.id != "" && parents.id ?= @request.auth.id`
   - **Create**: `@request.auth.id != ""`
   - **Update**: `@request.auth.id != "" && parents.id ?= @request.auth.id`
   - **Delete**: `@request.auth.id != "" && parents.id ?= @request.auth.id`

#### B. Create `activities` collection

1. Click "New Collection" → "Base Collection"
2. Name: `activities`
3. Add fields:
   - `baby_profile` (Relation, Single, to `baby_profiles` collection, Required)
   - `type` (Text, Required)
   - `timestamp` (Date, Required)
   - `duration_minutes` (Number)
   - `notes` (Text)
   - `feed_type` (Text)
   - `feed_amount` (Number)
   - `diaper_type` (Text)
   - `local_id` (Text)
   - `user` (Relation, Single, to `users` collection)

4. Set API Rules:
   - **List/Search**: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`
   - **View**: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`
   - **Create**: `@request.auth.id != ""`
   - **Update**: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`
   - **Delete**: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`

### Step 5: Update App Configuration

1. Open `lib/services/pocketbase_service.dart`
2. Update the `pocketBaseUrl`:
   - For **local testing on Android emulator**: `http://10.0.2.2:8090`
   - For **local testing on iOS simulator**: `http://127.0.0.1:8090`
   - For **real device on same network**: `http://YOUR_COMPUTER_IP:8090`

## Option 2: Free Cloud Hosting

### Using Fly.io (Free Tier)

Fly.io offers a free tier perfect for PocketBase:

1. **Install Fly CLI**
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **Sign Up**
   ```bash
   fly auth signup
   ```

3. **Create a directory for your PocketBase deployment**
   ```bash
   mkdir pocketbase-app
   cd pocketbase-app
   ```

4. **Create a `Dockerfile`**
   ```dockerfile
   FROM alpine:latest

   ARG PB_VERSION=0.22.0

   RUN apk add --no-cache \
       unzip \
       ca-certificates

   # Download and unzip PocketBase
   ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
   RUN unzip /tmp/pb.zip -d /pb/

   EXPOSE 8090

   # Start PocketBase
   CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]
   ```

5. **Create `fly.toml`**
   ```toml
   app = "your-baby-tracker-pb"

   [build]
     dockerfile = "Dockerfile"

   [[services]]
     http_checks = []
     internal_port = 8090
     protocol = "tcp"

     [[services.ports]]
       handlers = ["http"]
       port = 80

     [[services.ports]]
       handlers = ["tls", "http"]
       port = 443

   [[mounts]]
     source = "pb_data"
     destination = "/pb/pb_data"
   ```

6. **Deploy**
   ```bash
   fly launch
   fly volumes create pb_data --size 1
   fly deploy
   ```

7. **Get your URL**
   ```bash
   fly info
   ```
   Your URL will be: `https://your-baby-tracker-pb.fly.dev`

8. **Update the app**
   - Open `lib/services/pocketbase_service.dart`
   - Change `pocketBaseUrl` to your Fly.io URL

### Using Railway (Free Tier)

1. Visit https://railway.app
2. Sign up with GitHub
3. Click "New Project" → "Deploy from Template"
4. Search for "PocketBase" templates
5. Deploy and get your URL
6. Update `pocketBaseUrl` in the app

### Using PocketHost (Managed PocketBase Hosting)

1. Visit https://pockethost.io
2. Free tier includes:
   - 25MB storage
   - Perfect for personal use
3. Create an instance
4. Use the provided URL in your app

## How to Use the App

### First Parent Setup

1. **Open the app**
2. **Register**: Create a new account with email and password
3. **Create Baby Profile**: Enter your baby's name and birth date
4. **Note the Profile ID**: Go to Settings → Copy the Profile ID
5. **Share Profile ID** with your partner (via text, email, etc.)

### Second Parent Setup

1. **Open the app**
2. **Register**: Create a new account (different email)
3. **Join Existing Profile**:
   - Select "Join Existing" tab
   - Paste the Profile ID from your partner
4. **Start tracking!** All data will sync automatically

### Alternative: Add Partner by Email

1. First parent goes to **Settings**
2. Enter partner's email in "Add Partner" section
3. Click "Add Partner"
4. Partner can now see all baby data!

## Features

✅ **Real-time Sync**: Changes appear instantly on both devices
✅ **Offline Support**: Works offline, syncs when back online
✅ **Edit Time**: Tap any activity → Edit → Change date/time
✅ **Complete Privacy**: Your data, your server
✅ **100% Free**: No monthly costs

## Troubleshooting

### Can't connect to PocketBase

**For local setup:**
- Make sure PocketBase is running (`./pocketbase serve`)
- Check the URL in `pocketbase_service.dart`
- Android emulator: Use `http://10.0.2.2:8090`
- iOS simulator: Use `http://127.0.0.1:8090`
- Real device: Use your computer's IP address

**For cloud setup:**
- Make sure you're using HTTPS (not HTTP)
- Check that your deployment is running
- Verify the URL is correct

### Activities not syncing

- Pull down to refresh on the home screen
- Check Settings → Sync Status
- Make sure both parents are logged in
- Verify both parents have access to the same Baby Profile

### Login failed

- Double-check email and password
- Password must be at least 8 characters
- Make sure PocketBase is running and accessible

## Security Notes

1. **Use strong passwords**: At least 12 characters with mixed case, numbers, and symbols
2. **HTTPS in production**: Always use HTTPS for cloud deployments
3. **Regular backups**: Export your data regularly from PocketBase admin
4. **Keep PocketBase updated**: Check for updates monthly

## Data Backup

1. Access PocketBase Admin UI: `http://your-pocketbase-url/_/`
2. Go to Settings → Backups
3. Click "Create backup"
4. Download the backup file
5. Store safely!

## Cost Comparison

| Solution | Monthly Cost | Setup Difficulty |
|----------|--------------|------------------|
| PocketBase (Self-hosted) | $0 | Easy |
| Firebase | $0-25+ | Medium |
| AWS/Azure | $5-50+ | Hard |
| Custom Backend | $10-100+ | Very Hard |

## Support

For PocketBase issues:
- Documentation: https://pocketbase.io/docs/
- GitHub: https://github.com/pocketbase/pocketbase

For app issues:
- Check the README.md
- Review this setup guide

---

**Congratulations!** You now have a completely free, private backend for your baby tracking app that both parents can use! 🎉
