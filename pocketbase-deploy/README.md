# PocketBase Deployment for Baby Tracker

This directory contains everything you need to deploy PocketBase to the cloud in minutes - **100% FREE**!

## 🚀 Quick Start (One Command!)

```bash
cd pocketbase-deploy
./deploy.sh
```

That's it! The script will:
- ✅ Install Fly CLI (if needed)
- ✅ Guide you through signup/login
- ✅ Create persistent storage
- ✅ Deploy PocketBase
- ✅ Configure collections automatically
- ✅ Update your Flutter app with the URL
- ✅ Open admin panel in browser

**Time: ~3-5 minutes** ⏱️

## 📁 What's Included

```
pocketbase-deploy/
├── Dockerfile                          # PocketBase container config
├── fly.toml                            # Fly.io deployment config
├── pb_migrations/
│   └── 1700000000_initial_schema.js   # Auto-setup collections
├── deploy.sh                           # One-click deployment script
├── DEPLOY.md                           # Detailed deployment guide
└── README.md                           # This file
```

## 🎯 What Gets Deployed

- **PocketBase v0.22.0** (latest stable)
- **Persistent 1GB Volume** (your data is safe)
- **Auto-configured Collections:**
  - `baby_profiles` - Baby information
  - `activities` - Sleep, feed, diaper tracking
  - `users` - Authentication (built-in)
- **Security Rules** - Pre-configured for multi-parent access
- **HTTPS** - Automatic SSL certificates
- **Real-time Sync** - WebSocket support

## 💰 Cost

**$0/month** - Completely free!

Fly.io free tier includes:
- 3 shared VMs (we use 1)
- 256MB RAM per VM
- 3GB persistent storage (we use 1GB)
- 160GB data transfer/month

**Perfect for personal projects!**

## 📖 Manual Deployment

If you prefer step-by-step instructions, see [DEPLOY.md](DEPLOY.md)

## 🔧 After Deployment

1. Visit your PocketBase admin panel: `https://YOUR-APP.fly.dev/_/`
2. Create admin account
3. Collections are already set up!
4. Update Flutter app:
   - Open `lib/services/pocketbase_service.dart`
   - Update `pocketBaseUrl` with your deployment URL
5. Run `flutter pub get && flutter run`

## 🛠️ Managing Your Deployment

```bash
# View logs
fly logs

# Check status
fly status

# Open dashboard
fly dashboard

# SSH into instance
fly ssh console

# Scale if needed (still free)
fly scale vm shared-cpu-1x --memory 512
```

## 🔄 Update PocketBase

```bash
# Edit Dockerfile, change version
ARG PB_VERSION=0.23.0

# Redeploy
fly deploy
```

## 🆘 Troubleshooting

### Can't deploy?
- Make sure you're logged in: `fly auth login`
- Check app name is unique in `fly.toml`

### Can't connect from app?
- Use `https://` (not `http://`)
- Rebuild Flutter app after updating URL

### Collections not created?
- Check admin panel: `https://YOUR-APP.fly.dev/_/`
- Manually create if needed (see `../POCKETBASE_SETUP.md`)

## 🌟 Alternative Hosting

Don't want to use Fly.io? No problem!

- **Railway.app** - https://railway.app (also free)
- **Render.com** - https://render.com (free tier)
- **PocketHost** - https://pockethost.io (managed, super easy)

See [DEPLOY.md](DEPLOY.md) for instructions.

## 📚 Documentation

- [Detailed Deployment Guide](DEPLOY.md)
- [PocketBase Setup Guide](../POCKETBASE_SETUP.md)
- [Main README](../README.md)

## 🔐 Security

- Use strong admin password (16+ characters)
- Backup data regularly from admin panel
- Update PocketBase monthly
- Monitor usage in Fly.io dashboard

## 🎉 Success Looks Like

After successful deployment:
```
🎉 Your PocketBase is now live!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 PocketBase URL:
   https://baby-tracker-pb-yourname-1234.fly.dev

🔧 Admin Panel:
   https://baby-tracker-pb-yourname-1234.fly.dev/_/
```

## ❤️ Support

Need help?
- Check [DEPLOY.md](DEPLOY.md) for detailed troubleshooting
- Read [POCKETBASE_SETUP.md](../POCKETBASE_SETUP.md) for usage guide
- Visit PocketBase docs: https://pocketbase.io/docs/

---

**Ready to deploy? Run `./deploy.sh` and you're live in 3 minutes!** 🚀
