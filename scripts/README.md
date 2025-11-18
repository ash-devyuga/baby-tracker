# Data Population Scripts

This folder contains scripts to populate your baby tracker app with historical data.

## Files

- **historical_data.csv** - Your baby's tracking data from Nov 10-18, 2025
- **populate_data.dart** - Script to import CSV data into the app

## How to Populate Historical Data

### Option 1: Manual Entry (Recommended for now)

Since the app is now set up with improved sleep and feed tracking:

1. **Open the app**
2. **For each entry:**
   - Tap the appropriate button (Sleep/Feed)
   - Set the date and time
   - For sleep: Set start time and end time
   - For feed: Enter amount in ml
   - Add notes if any
   - Tap Save

### Option 2: Using the CSV (Future Enhancement)

The CSV file contains all your data in a structured format:
```
Date,Feed_Time,Feed_Amount,Sleep_Start,Sleep_End,Notes
10/11/2025,03:20,110,03:50,06:30,
```

You could build a CSV import feature or use this data with the PocketBase admin panel.

## Data Summary

Your historical data includes:

- **Date Range**: November 10-18, 2025
- **Total Days**: 8 days
- **Feed Entries**: ~70 feeds
- **Sleep Entries**: ~60 sleep sessions
- **Notes**: Important observations about baby's behavior

## Quick Stats from Your Data

- **Average feeds per day**: 8-10
- **Average sleep sessions**: 7-8
- **Typical feed amount**: 60-120 ml
- **Night sleep pattern**: Usually 2-3 hours, then feed, repeat

## Using with PocketBase

If you've deployed PocketBase, you can:

1. Access the admin panel: `https://your-app.fly.dev/_/`
2. Go to "Collections" → "activities"
3. Manually add records using the CSV data
4. Or bulk import if PocketBase supports CSV import

## Tips

- Start with the most recent data first (Nov 17-18)
- This gives you immediate value
- You can add older data as time permits
- Focus on complete days for better statistics

## Need Help?

The app now has these improvements:
- ✅ Sleep start/end time tracking
- ✅ Total feed volume on dashboard
- ✅ Blue theme for baby boy
- ✅ Easy time editing

Just start using it with today's data, and you can add historical data later!
