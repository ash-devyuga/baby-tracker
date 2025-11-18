import '../models/activity.dart';
import '../services/database_service.dart';

/// Import historical baby tracking data
/// Run this once to populate database with existing data
Future<void> importHistoricalData() async {
  print('📊 Importing historical data...');

  final db = DatabaseService.instance;

  // Helper to create DateTime from date and time strings
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

  // Helper to parse end time that might cross midnight
  DateTime? endTime(String date, String? time) {
    if (time == null || time.isEmpty) return null;

    final parts = date.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // If time is 00:00, it's next day
    if (hour == 0 && minute == 0) {
      day += 1;
      if (day > 31) {
        day = 1;
        month += 1;
      }
    }

    return DateTime(year, month, day, hour, minute);
  }

  int totalActivities = 0;

  // November 10, 2025
  print('Importing Nov 10...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '00:00'),
    sleepEndTime: dt('10/11/2025', '03:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '03:20'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '03:50'),
    sleepEndTime: dt('10/11/2025', '06:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '06:30'),
    feedAmount: 90,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '08:40'),
    sleepEndTime: dt('10/11/2025', '09:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '09:30'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '10:30'),
    feedAmount: 50,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '11:30'),
    sleepEndTime: dt('10/11/2025', '12:10'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '13:10'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '14:00'),
    sleepEndTime: dt('10/11/2025', '16:00'),
    notes: 'grumpy by 13:45',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '16:10'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '17:45'),
    sleepEndTime: dt('10/11/2025', '18:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '18:50'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '19:30'),
    feedAmount: 20,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('10/11/2025', '20:30'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('10/11/2025', '20:45'),
    sleepEndTime: endTime('10/11/2025', '00:00'),
    notes: 'sleepy by 20:30',
  ));

  totalActivities += 16;

  // November 11, 2025
  print('Importing Nov 11...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '00:00'),
    sleepEndTime: dt('11/11/2025', '03:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '03:05'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '03:00'),
    sleepEndTime: dt('11/11/2025', '06:20'),
    notes: 'Stayed sleeping by 3',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '06:20'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '06:30'),
    sleepEndTime: dt('11/11/2025', '08:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '08:30'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '09:50'),
    sleepEndTime: dt('11/11/2025', '10:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '10:50'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '11:50'),
    sleepEndTime: dt('11/11/2025', '12:25'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '13:25'),
    feedAmount: 130,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '14:15'),
    sleepEndTime: dt('11/11/2025', '16:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '16:30'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '18:15'),
    sleepEndTime: dt('11/11/2025', '18:55'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '19:10'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '19:45'),
    feedAmount: 40,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('11/11/2025', '19:55'),
    feedAmount: 90,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('11/11/2025', '20:40'),
    sleepEndTime: endTime('11/11/2025', '00:00'),
  ));

  totalActivities += 17;

  // November 12, 2025
  print('Importing Nov 12...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '00:00'),
    sleepEndTime: dt('12/11/2025', '02:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '02:30'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '02:50'),
    sleepEndTime: dt('12/11/2025', '04:40'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '04:45'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '04:50'),
    sleepEndTime: dt('12/11/2025', '07:45'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '08:00'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '09:50'),
    sleepEndTime: dt('12/11/2025', '10:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '10:40'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '12:35'),
    sleepEndTime: dt('12/11/2025', '13:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '13:20'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '14:15'),
    sleepEndTime: dt('12/11/2025', '15:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '16:00'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '18:00'),
    sleepEndTime: dt('12/11/2025', '19:20'),
    notes: 'very cranky and frustrated before sleeping',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '19:20'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('12/11/2025', '20:25'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('12/11/2025', '20:30'),
    sleepEndTime: endTime('12/11/2025', '00:00'),
  ));

  totalActivities += 16;

  // November 13, 2025
  print('Importing Nov 13...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '00:00'),
    sleepEndTime: dt('13/11/2025', '01:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '01:20'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '01:40'),
    sleepEndTime: dt('13/11/2025', '07:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '05:00'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '08:40'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '09:50'),
    sleepEndTime: dt('13/11/2025', '10:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '11:00'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '12:10'),
    sleepEndTime: dt('13/11/2025', '13:10'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '13:30'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '14:30'),
    sleepEndTime: dt('13/11/2025', '16:10'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '16:15'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '17:30'),
    sleepEndTime: dt('13/11/2025', '18:50'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '19:05'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '20:30'),
    sleepEndTime: dt('13/11/2025', '21:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('13/11/2025', '21:30'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('13/11/2025', '21:50'),
    sleepEndTime: endTime('13/11/2025', '00:00'),
  ));

  totalActivities += 16;

  // November 14, 2025
  print('Importing Nov 14...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '00:00'),
    sleepEndTime: dt('14/11/2025', '00:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '00:30'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '00:40'),
    sleepEndTime: dt('14/11/2025', '04:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '04:00'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '05:00'),
    sleepEndTime: dt('14/11/2025', '07:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '07:00'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '08:50'),
    sleepEndTime: dt('14/11/2025', '09:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '10:00'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '11:00'),
    sleepEndTime: dt('14/11/2025', '11:50'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '12:30'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '13:20'),
    sleepEndTime: dt('14/11/2025', '14:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '15:05'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '16:05'),
    sleepEndTime: dt('14/11/2025', '16:45'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '17:20'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '19:00'),
    sleepEndTime: dt('14/11/2025', '19:10'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '19:20'),
    feedAmount: 40,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '20:00'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('14/11/2025', '20:40'),
    sleepEndTime: endTime('14/11/2025', '00:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('14/11/2025', '23:00'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  totalActivities += 19;

  // November 15, 2025
  print('Importing Nov 15...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '00:00'),
    sleepEndTime: dt('15/11/2025', '06:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '03:10'),
    feedAmount: 105,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '05:30'),
    feedAmount: 10,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '06:30'),
    feedAmount: 40,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '06:30'),
    sleepEndTime: dt('15/11/2025', '07:10'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '09:25'),
    sleepEndTime: dt('15/11/2025', '10:10'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '10:15'),
    feedAmount: 90,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '11:40'),
    feedAmount: 30,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '11:55'),
    sleepEndTime: dt('15/11/2025', '12:35'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '12:45'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '14:30'),
    sleepEndTime: dt('15/11/2025', '15:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '15:10'),
    feedAmount: 115,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '16:50'),
    sleepEndTime: dt('15/11/2025', '18:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '18:20'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '20:00'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('15/11/2025', '21:00'),
    sleepEndTime: endTime('15/11/2025', '00:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('15/11/2025', '22:40'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  totalActivities += 17;

  // November 16, 2025
  print('Importing Nov 16...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '00:00'),
    sleepEndTime: dt('16/11/2025', '02:40'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '02:40'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '04:00'),
    sleepEndTime: dt('16/11/2025', '07:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '07:00'),
    feedAmount: 95,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '09:00'),
    sleepEndTime: dt('16/11/2025', '10:40'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '10:45'),
    feedAmount: 110,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '12:45'),
    feedAmount: 75,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '13:00'),
    sleepEndTime: dt('16/11/2025', '13:40'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '14:40'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '15:10'),
    sleepEndTime: dt('16/11/2025', '15:40'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '16:20'),
    feedAmount: 60,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '16:50'),
    sleepEndTime: dt('16/11/2025', '19:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '18:10'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '20:45'),
    feedAmount: 90,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('16/11/2025', '21:00'),
    sleepEndTime: endTime('16/11/2025', '00:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('16/11/2025', '23:00'),
    feedAmount: 40,
    feedType: 'Bottle',
  ));

  totalActivities += 16;

  // November 17, 2025
  print('Importing Nov 17...');

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '00:00'),
    sleepEndTime: dt('17/11/2025', '01:20'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '01:20'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '01:20'),
    sleepEndTime: dt('17/11/2025', '03:40'),
    notes: 'was still sleeping',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '03:40'),
    feedAmount: 70,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '03:40'),
    sleepEndTime: dt('17/11/2025', '07:40'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '05:10'),
    feedAmount: 50,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '06:40'),
    feedAmount: 30,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '08:45'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '09:40'),
    sleepEndTime: dt('17/11/2025', '10:30'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '11:10'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '12:30'),
    sleepEndTime: dt('17/11/2025', '12:50'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '13:45'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '14:25'),
    sleepEndTime: dt('17/11/2025', '15:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '16:15'),
    feedAmount: 100,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '16:35'),
    sleepEndTime: dt('17/11/2025', '18:15'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '18:30'),
    feedAmount: 40,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '19:10'),
    feedAmount: 80,
    feedType: 'Bottle',
  ));

  await db.insertActivity(Activity(
    type: ActivityType.sleep,
    timestamp: dt('17/11/2025', '21:00'),
    sleepEndTime: endTime('17/11/2025', '00:00'),
  ));

  await db.insertActivity(Activity(
    type: ActivityType.feed,
    timestamp: dt('17/11/2025', '22:15'),
    feedAmount: 120,
    feedType: 'Bottle',
  ));

  totalActivities += 19;

  print('\n✅ Import complete!');
  print('Total activities imported: $totalActivities');
  print('\nData from Nov 10-17, 2025 has been added to your app!');
}
