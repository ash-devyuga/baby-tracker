# PocketBase Collections Setup Guide

Since the migrations didn't run automatically, you need to create the collections manually.

## Option 1: Manual Setup (Fastest - 5 minutes)

### Step 1: Access Admin Panel
1. Open: https://baby-tracker-pb-ashwanisingla-7054.fly.dev/_/
2. Login with your admin credentials

### Step 2: Create `baby_profiles` Collection

1. Click **Collections** in sidebar
2. Click **+ New collection**
3. Set **Type**: Base collection
4. Set **Name**: `baby_profiles`
5. Click **New field** and add these fields:

   - **Field 1:**
     - Type: Text
     - Name: `name`
     - Required: ✓

   - **Field 2:**
     - Type: Date
     - Name: `birth_date`
     - Required: ✓

   - **Field 3:**
     - Type: Relation
     - Name: `parents`
     - Collection: users
     - Max select: empty (multiple)

6. **API Rules** (click on "API rules" tab):
   - List/Search: `@request.auth.id != "" && parents.id ?= @request.auth.id`
   - View: `@request.auth.id != "" && parents.id ?= @request.auth.id`
   - Create: `@request.auth.id != ""`
   - Update: `@request.auth.id != "" && parents.id ?= @request.auth.id`
   - Delete: `@request.auth.id != "" && parents.id ?= @request.auth.id`

7. Click **Create**

### Step 3: Create `activities` Collection

1. Click **+ New collection**
2. Set **Type**: Base collection
3. Set **Name**: `activities`
4. Click **New field** and add these fields:

   - **Field 1:**
     - Type: Relation
     - Name: `baby_profile`
     - Collection: baby_profiles
     - Required: ✓
     - Max select: 1
     - Cascade delete: ✓

   - **Field 2:**
     - Type: Text
     - Name: `type`
     - Required: ✓

   - **Field 3:**
     - Type: Date
     - Name: `timestamp`
     - Required: ✓

   - **Field 4:**
     - Type: Number
     - Name: `duration_minutes`
     - Required: ✗

   - **Field 5:**
     - Type: Date
     - Name: `sleep_end_time`
     - Required: ✗

   - **Field 6:**
     - Type: Text
     - Name: `notes`
     - Required: ✗
     - Max: 1000

   - **Field 7:**
     - Type: Text
     - Name: `feed_type`
     - Required: ✗
     - Max: 50

   - **Field 8:**
     - Type: Number
     - Name: `feed_amount`
     - Required: ✗

   - **Field 9:**
     - Type: Text
     - Name: `diaper_type`
     - Required: ✗
     - Max: 50

   - **Field 10:**
     - Type: Text
     - Name: `local_id`
     - Required: ✗

   - **Field 11:**
     - Type: Relation
     - Name: `user`
     - Collection: users
     - Required: ✗
     - Max select: 1

5. **API Rules** (click on "API rules" tab):
   - List/Search: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`
   - View: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`
   - Create: `@request.auth.id != ""`
   - Update: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`
   - Delete: `@request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id`

6. Click **Create**

### Done!

Now you can use the app and it will sync properly to PocketBase.

---

## Option 2: Redeploy to Trigger Migrations

If you prefer to use migrations:

```bash
cd pocketbase-deploy
fly deploy
```

This will redeploy PocketBase and run the migrations automatically.
