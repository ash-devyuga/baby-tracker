import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import 'database_service.dart';

class ActivityProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  List<Activity> _activities = [];
  Activity? _lastSleep;
  Activity? _lastFeed;
  Activity? _lastDiaper;

  List<Activity> get activities => _activities;
  Activity? get lastSleep => _lastSleep;
  Activity? get lastFeed => _lastFeed;
  Activity? get lastDiaper => _lastDiaper;

  Future<void> loadActivities({DateTime? date}) async {
    _activities = await _db.getActivities(date: date ?? DateTime.now());
    await _loadLastActivities();
    notifyListeners();
  }

  Future<void> _loadLastActivities() async {
    _lastSleep = await _db.getLastActivity(ActivityType.sleep);
    _lastFeed = await _db.getLastActivity(ActivityType.feed);
    _lastDiaper = await _db.getLastActivity(ActivityType.diaper);
  }

  Future<void> addActivity(Activity activity) async {
    await _db.insertActivity(activity);
    await loadActivities();
  }

  Future<void> deleteActivity(int id) async {
    await _db.deleteActivity(id);
    await loadActivities();
  }

  Future<void> updateActivity(Activity activity) async {
    await _db.updateActivity(activity);
    await loadActivities();
  }

  List<Activity> getTodayActivities(ActivityType type) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    return _activities
        .where((activity) =>
            activity.type == type &&
            activity.timestamp.isAfter(startOfDay))
        .toList();
  }

  int getTotalSleepMinutes() {
    final sleepActivities = getTodayActivities(ActivityType.sleep);
    return sleepActivities.fold(
      0,
      (sum, activity) => sum + (activity.durationMinutes ?? 0),
    );
  }

  int getTotalFeeds() {
    return getTodayActivities(ActivityType.feed).length;
  }

  int getTotalDiapers() {
    return getTodayActivities(ActivityType.diaper).length;
  }

  String getTimeSinceLastActivity(Activity? activity) {
    if (activity == null) return 'No data';

    final now = DateTime.now();
    final difference = now.difference(activity.timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return '${hours}h ${minutes}m ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
