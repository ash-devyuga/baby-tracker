# Manual Deployment Steps

Since the automated script had issues, here are the exact commands to run in your terminal:

## Prerequisites

Make sure you have Fly CLI installed and can run `fly` command.

```bash
# Test if fly is available
fly version
```

If not, install it:
- **Mac/Linux**: `curl -L https://fly.io/install.sh | sh`
- **Windows**: `pwsh -Command "iwr https://fly.io/install.ps1 -useb | iex"`

Then add to PATH:
```bash
export PATH="$HOME/.fly/bin:$PATH"
```

## Deployment Commands

Run these commands one by one in your terminal:

### 1. Navigate to deployment directory

```bash
cd pocketbase-deploy
```

### 2. Login to Fly.io

```bash
fly auth login
```

### 3. Create your app

```bash
fly apps create baby-tracker-pb-YOUR-NAME --org personal
```

Replace `YOUR-NAME` with your name or any unique identifier.

### 4. Create persistent storage

```bash
fly volumes create pb_data --size 1 --region iad --app baby-tracker-pb-YOUR-NAME --yes
```

### 5. Update fly.toml

Edit `fly.toml` and change the first line:
```toml
app = "baby-tracker-pb-YOUR-NAME"
```

### 6. Deploy PocketBase

```bash
fly deploy --app baby-tracker-pb-YOUR-NAME
```

This takes 2-3 minutes. Wait for it to complete.

### 7. Get your URL

Your PocketBase will be live at:
```
https://baby-tracker-pb-YOUR-NAME.fly.dev
```

### 8. Set up admin account

1. Visit: `https://baby-tracker-pb-YOUR-NAME.fly.dev/_/`
2. Create your admin account (email + password)
3. Collections are already configured!

### 9. Update Flutter app

Open `../lib/services/pocketbase_service.dart` and update line 13:

```dart
static const String pocketBaseUrl = 'https://baby-tracker-pb-YOUR-NAME.fly.dev';
```

### 10. Test the app

```bash
cd ..
flutter pub get
flutter run
```

## Quick Script Option

Or simply run the manual deployment script:

```bash
./manual-deploy.sh
```

This automates all the steps above.

## Troubleshooting

### "fly: command not found"

```bash
# Add to PATH
export PATH="$HOME/.fly/bin:$PATH"

# Or use full path
$HOME/.fly/bin/fly version
```

### "app name already taken"

Choose a different app name in step 3.

### "no credit card on file"

Fly.io requires a credit card for verification (but won't charge you for free tier usage).

Add one at: https://fly.io/dashboard

## Verify Deployment

```bash
# Check status
fly status --app baby-tracker-pb-YOUR-NAME

# View logs
fly logs --app baby-tracker-pb-YOUR-NAME

# Test health
curl https://baby-tracker-pb-YOUR-NAME.fly.dev/api/health
# Should return: {"code":200,"message":"OK"}
```

## Success!

Once deployed, you'll have:
- ✅ Free PocketBase server
- ✅ 1GB persistent storage
- ✅ HTTPS enabled
- ✅ Real-time sync
- ✅ Auto-configured collections

**Total cost: $0/month** 🎉
