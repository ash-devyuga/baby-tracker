# PocketBase Deployment Guide

This guide will help you deploy your PocketBase backend to Fly.io in under 5 minutes - **completely FREE**!

## Quick Deploy (Recommended)

Just run this one command from the `pocketbase-deploy` directory:

```bash
./deploy.sh
```

That's it! The script will handle everything automatically.

## Manual Deployment Steps

If you prefer to do it manually or the script doesn't work:

### Step 1: Install Fly.io CLI

**macOS/Linux:**
```bash
curl -L https://fly.io/install.sh | sh
```

**Windows (PowerShell):**
```powershell
pwsh -Command "iwr https://fly.io/install.ps1 -useb | iex"
```

### Step 2: Sign Up and Login

```bash
# Sign up for a free account (if you don't have one)
fly auth signup

# Or login if you already have an account
fly auth login
```

### Step 3: Deploy PocketBase

```bash
# Navigate to the deployment directory
cd pocketbase-deploy

# Create a volume for persistent data (FREE - 3GB included)
fly volumes create pb_data --size 1 --region iad

# Deploy the app (FREE tier)
fly launch --now --name baby-tracker-pb-$(whoami) --region iad

# Your PocketBase is now live! 🎉
```

### Step 4: Get Your PocketBase URL

```bash
fly status
```

Your URL will be: `https://baby-tracker-pb-YOURNAME.fly.dev`

### Step 5: Set Up Admin Account

1. Visit: `https://baby-tracker-pb-YOURNAME.fly.dev/_/`
2. Create your admin account (email + password)
3. Done! Collections are automatically created!

### Step 6: Update Flutter App

Open `lib/services/pocketbase_service.dart` and update:

```dart
static const String pocketBaseUrl = 'https://baby-tracker-pb-YOURNAME.fly.dev';
```

## What's Included (FREE)

✅ **PocketBase Server** - Latest version (v0.22.0)
✅ **Persistent Storage** - 3GB volume (more than enough)
✅ **Auto-configured Collections**:
  - `baby_profiles` - Store baby information
  - `activities` - Track sleep, feed, diaper changes
  - `users` - Built-in authentication

✅ **Security Rules** - Pre-configured for multi-parent access
✅ **Real-time Sync** - WebSocket support included
✅ **HTTPS** - Automatic SSL certificates
✅ **Custom Domain** - Can add your own domain (optional)

## Fly.io Free Tier

- **3 shared-cpu-1x VMs** with 256MB RAM
- **3GB persistent volume storage**
- **160GB outbound data transfer**
- **Perfect for personal projects!**

## Verify Deployment

After deployment, test your PocketBase:

```bash
# Check health
curl https://baby-tracker-pb-YOURNAME.fly.dev/api/health

# Should return: {"code":200,"message":"OK"}
```

## Managing Your Deployment

### View Logs
```bash
fly logs
```

### Check Status
```bash
fly status
```

### Scale (if needed in the future)
```bash
fly scale vm shared-cpu-1x --memory 512
```

### SSH into your instance
```bash
fly ssh console
```

### Backup Data
```bash
# Access PocketBase admin
# Go to Settings → Backups → Create Backup
# Download the backup file
```

### Update PocketBase Version

Edit `Dockerfile` and change the version:
```dockerfile
ARG PB_VERSION=0.23.0  # Update to latest version
```

Then redeploy:
```bash
fly deploy
```

## Troubleshooting

### Issue: "App name already taken"
**Solution:** Change the app name in `fly.toml`:
```toml
app = "baby-tracker-pb-YOUR-UNIQUE-NAME"
```

### Issue: "Volume not found"
**Solution:** Create the volume first:
```bash
fly volumes create pb_data --size 1 --region iad
```

### Issue: "Can't connect from app"
**Solution:** Make sure you:
1. Updated the URL in `pocketbase_service.dart`
2. Used `https://` (not `http://`)
3. Rebuilt the Flutter app: `flutter pub get && flutter run`

### Issue: "Collections not created"
**Solution:** The migrations should run automatically, but if not:
1. Go to PocketBase Admin: `https://YOUR-APP.fly.dev/_/`
2. Manually create collections using the instructions in `POCKETBASE_SETUP.md`

## Alternative Deployment Options

### Railway.app (Also FREE)

1. Visit https://railway.app
2. Sign in with GitHub
3. Click "New Project" → "Empty Project"
4. Click "Deploy from GitHub Repo"
5. Connect your repo and select `pocketbase-deploy` folder
6. Railway will auto-deploy!

### Render.com (FREE tier)

1. Visit https://render.com
2. Sign up
3. Click "New +" → "Web Service"
4. Connect your repo
5. Set:
   - Environment: Docker
   - Region: Oregon (free)
   - Instance Type: Free
6. Deploy!

### PocketHost (Managed - Easiest!)

1. Visit https://pockethost.io
2. Sign up (FREE tier: 25MB storage)
3. Click "Create Instance"
4. Instance is ready in 30 seconds!
5. Copy the URL
6. Update Flutter app

## Security Best Practices

1. **Strong Admin Password**: Use at least 16 characters
2. **Regular Backups**: Download backups weekly from admin panel
3. **Monitor Usage**: Check Fly.io dashboard monthly
4. **Update PocketBase**: Check for updates monthly
5. **Environment Variables**: Never commit sensitive data

## Cost Monitoring

Your deployment is **FREE** as long as you stay within:
- ✅ 1 VM with 256MB RAM
- ✅ 1GB - 3GB storage
- ✅ 160GB/month transfer

**Typical usage for 2 parents tracking 1 baby:**
- Storage: ~10MB/month
- Transfer: ~1GB/month
- **Cost: $0** 🎉

## Next Steps

After deployment:

1. ✅ Update Flutter app with your PocketBase URL
2. ✅ Run `flutter pub get`
3. ✅ Test the app on your device
4. ✅ Register both parents
5. ✅ Share the Profile ID
6. ✅ Start tracking!

## Support

- **Fly.io Docs**: https://fly.io/docs/
- **PocketBase Docs**: https://pocketbase.io/docs/
- **Community**: https://github.com/pocketbase/pocketbase/discussions

---

**Congratulations! Your free PocketBase backend is now deployed!** 🚀
