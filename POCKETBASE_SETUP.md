# PocketBase Manual Setup Guide

## Quick Steps to Enable Sync

### 1. Access PocketBase Admin
Open: https://baby-tracker-pb-ashwanisingla-7054.fly.dev/_/

### 2. Login or Create Admin
- First time? Create admin account
- Email: ash.singla@devyuga.com
- Password: Hello@12345 (or your choice)

### 3. Create Collections

You need TWO collections:

#### Collection 1: baby_profiles
- Click "New collection" → Base collection
- Name: `baby_profiles`
- Fields:
  - `name` (Text, required)
  - `birth_date` (Date, required)
  - `parents` (Relation → users, multiple)
- API Rules (all 5 rules):
  ```
  @request.auth.id != "" && parents.id ?= @request.auth.id
  ```
  (except Create rule: `@request.auth.id != ""`)

#### Collection 2: activities
- Click "New collection" → Base collection
- Name: `activities`
- Fields:
  - `baby_profile` (Relation → baby_profiles, required, max 1, cascade delete)
  - `type` (Text, required)
  - `timestamp` (Date, required)
  - `duration_minutes` (Number)
  - `sleep_end_time` (Date)
  - `notes` (Text, max 1000)
  - `feed_type` (Text, max 50)
  - `feed_amount` (Number)
  - `diaper_type` (Text, max 50)
  - `local_id` (Text)
  - `user` (Relation → users, max 1)
- API Rules (all 5 rules):
  ```
  @request.auth.id != "" && baby_profile.parents.id ?= @request.auth.id
  ```
  (except Create rule: `@request.auth.id != ""`)

### 4. Done!
After creating collections, sync will work automatically in the app.
