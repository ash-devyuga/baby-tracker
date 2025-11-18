# Baby Care Tracker App

A Flutter mobile application to track your baby's sleep, feeding, and diaper changes. Easily monitor and record daily activities with a clean, intuitive interface.

## Features

- **Quick Tracking**: Easy one-tap tracking for sleep, feed, and diaper changes
- **Time Since Last Activity**: See how long it's been since the last feed, diaper change, or sleep
- **Daily Summary**: View total sleep hours and number of feeds/diaper changes for the day
- **Activity History**: Browse and manage all recorded activities with edit/delete options
- **Local Storage**: All data is stored locally using SQLite for privacy and offline access

## Screenshots

### Dashboard
- Quick action buttons for sleep, feed, and diaper tracking
- Time since last activity for each type
- Daily summary showing total sleep hours and activity counts

### Activity Tracking
- **Sleep**: Record sleep duration and time
- **Feed**: Track feed type (bottle, breast left/right/both, solid) and amount
- **Diaper**: Log diaper type (wet, dirty, or both)
- Add optional notes to any activity

### History
- View all activities organized by type
- Edit or delete past entries
- See detailed information including timestamps and notes

## Installation

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development
- A physical device or emulator

### Setup Instructions

1. **Clone the repository** (if not already cloned)
   ```bash
   cd baby_tracker_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run

   # For iOS (macOS only)
   flutter run -d ios

   # For a specific device
   flutter devices  # List available devices
   flutter run -d <device-id>
   ```

4. **Build for release**
   ```bash
   # Android APK
   flutter build apk --release

   # iOS (requires macOS and Xcode)
   flutter build ios --release
   ```

## Project Structure

```
baby_tracker_app/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/
│   │   └── activity.dart              # Activity data model
│   ├── services/
│   │   ├── database_service.dart      # SQLite database operations
│   │   └── activity_provider.dart     # State management
│   └── screens/
│       ├── home_screen.dart           # Main dashboard
│       ├── add_activity_screen.dart   # Add/edit activity
│       └── history_screen.dart        # Activity history
├── pubspec.yaml                        # Dependencies
└── README.md
```

## Dependencies

- **sqflite**: Local SQLite database
- **path**: File path manipulation
- **intl**: Date and time formatting
- **provider**: State management

## Usage

### Adding an Activity

1. On the home screen, tap one of the quick action buttons (Sleep, Feed, or Diaper)
2. Select the date and time (defaults to current time)
3. Fill in type-specific details:
   - **Sleep**: Duration in minutes
   - **Feed**: Type and amount
   - **Diaper**: Type (wet, dirty, or both)
4. Optionally add notes
5. Tap "Save"

### Viewing History

1. Tap the history icon in the top-right corner
2. Switch between tabs to view different activity types
3. Tap the menu icon on any entry to edit or delete

### Dashboard Information

- **Today's Summary**: Shows total sleep hours, feeds, and diaper changes for the current day
- **Last Activity Cards**: Display time since the last occurrence of each activity type

## Data Storage

All data is stored locally on your device using SQLite. No data is sent to external servers, ensuring complete privacy.

## Future Enhancements

Potential features for future versions:
- Weekly/monthly statistics and charts
- Export data to CSV or PDF
- Multiple baby profiles
- Reminders and notifications
- Dark mode
- Data backup and restore

## Troubleshooting

### App won't build
- Ensure Flutter SDK is properly installed: `flutter doctor`
- Run `flutter clean` followed by `flutter pub get`

### Database errors
- Uninstall and reinstall the app to reset the database
- Check device storage space

## License

This project is open source and available for personal use.

## Support

For issues or questions, please create an issue in the GitHub repository.
