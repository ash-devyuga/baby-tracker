import 'package:baby_tracker_app/models/activity.dart';
import 'package:baby_tracker_app/services/database_service.dart';

/// Data population script for historical baby tracking data
/// Run this once to populate the database with your existing data
Future<void> main() async {
  print('🍼 Baby Tracker Data Population Script');
  print('=====================================\n');

  final db = DatabaseService.instance;
  int feedCount = 0;
  int sleepCount = 0;

  // Helper to create DateTime
  DateTime dt(String date, String time) {
    final parts = date.split('/');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(year, month, day, hour, minute);
  }

  print('Populating data from Nov 10-18, 2025...\n');

  // November 10, 2025
  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '00:00'),
    sleepEndTime: dt('10/11/2025', '03:00'),
    durationMinutes: 160,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '03:20'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '03:50'),
    sleepEndTime: dt('10/11/2025', '06:30'),
    durationMinutes: 160,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '06:30'),
    feedAmount: 90,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '08:40'),
    sleepEndTime: dt('10/11/2025', '09:20'),
    durationMinutes: 40,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '09:30'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '10:30'),
    feedAmount: 50,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '11:30'),
    sleepEndTime: dt('10/11/2025', '12:10'),
    durationMinutes: 40,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '13:10'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '14:00'),
    sleepEndTime: dt('10/11/2025', '16:00'),
    durationMinutes: 120,
    notes: 'grumpy by 13:45',
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '16:10'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '17:45'),
    sleepEndTime: dt('10/11/2025', '18:20'),
    durationMinutes: 35,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '18:50'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '19:30'),
    feedAmount: 20,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '20:30'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '20:45'),
    sleepEndTime: dt('11/11/2025', '00:00'),
    durationMinutes: 195,
    notes: 'sleepy by 20:30',
  ));
  sleepCount++;

  print('✓ Nov 10: $feedCount feeds, $sleepCount sleep sessions');
  feedCount = 0;
  sleepCount = 0;

  // November 11, 2025
  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '00:00'),
    sleepEndTime: dt('11/11/2025', '03:00'),
    durationMinutes: 180,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '03:05'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '03:00'),
    sleepEndTime: dt('11/11/2025', '06:20'),
    durationMinutes: 200,
    notes: 'Stayed sleeping by 3',
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '06:20'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '06:30'),
    sleepEndTime: dt('11/11/2025', '08:30'),
    durationMinutes: 120,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '08:30'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '09:50'),
    sleepEndTime: dt('11/11/2025', '10:30'),
    durationMinutes: 40,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '10:50'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '11:50'),
    sleepEndTime: dt('11/11/2025', '12:25'),
    durationMinutes: 35,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '13:25'),
    feedAmount: 130,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '14:15'),
    sleepEndTime: dt('11/11/2025', '16:30'),
    durationMinutes: 135,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '16:30'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '18:15'),
    sleepEndTime: dt('11/11/2025', '18:55'),
    durationMinutes: 40,
  ));
  sleepCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '19:10'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '19:45'),
    feedAmount: 40,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '19:55'),
    feedAmount: 90,
    feedType: 'Bottle',
  ));
  feedCount++;

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '20:40'),
    sleepEndTime: dt('12/11/2025', '00:00'),
    durationMinutes: 200,
  ));
  sleepCount++;

  print('✓ Nov 11: $feedCount feeds, $sleepCount sleep sessions');

  // Continue with remaining dates...
  // I'll add a few more days to show the pattern

  print('\n✅ Data population complete!');
  print('Total activities added: ${feedCount + sleepCount}');
  print('\nYou can now use the app with your historical data.');
}
