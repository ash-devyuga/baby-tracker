# Initial Setup Instructions

This Flutter app has been created with all the necessary source code. To complete the setup and generate platform-specific files (Android/iOS), follow these steps:

## Prerequisites

1. Install Flutter SDK from https://flutter.dev/docs/get-started/install
2. Verify installation with `flutter doctor`

## Complete Project Setup

Since the Android and iOS folders need to be generated, run the following command in the `baby_tracker_app` directory:

```bash
# Navigate to the app directory
cd baby_tracker_app

# Create the platform-specific files
flutter create .

# This will generate:
# - android/ folder with Android project files
# - ios/ folder with iOS project files
# - test/ folder for unit tests
# - Other platform files

# Install dependencies
flutter pub get

# Verify everything works
flutter doctor

# Run the app
flutter run
```

## Alternative: Create from Scratch

If you prefer to start fresh with a new Flutter project and copy the code:

```bash
# Create a new Flutter project
flutter create baby_tracker_app

# Copy the lib/ folder and pubspec.yaml from this directory
# Then run:
cd baby_tracker_app
flutter pub get
flutter run
```

## Platform-Specific Requirements

### Android
- Android Studio or Android SDK
- Java Development Kit (JDK)
- Accept Android licenses: `flutter doctor --android-licenses`

### iOS (macOS only)
- Xcode
- CocoaPods: `sudo gem install cocoapods`
- iOS Simulator or physical iOS device

## Running the App

```bash
# List available devices
flutter devices

# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Build APK for Android
flutter build apk --release

# Build for iOS (macOS only)
flutter build ios --release
```

## Troubleshooting

If you encounter any issues:

1. Run `flutter doctor` to check for missing dependencies
2. Run `flutter clean` and `flutter pub get`
3. Restart your IDE
4. Check Flutter installation path in environment variables

For more help, visit: https://flutter.dev/docs/get-started/install
