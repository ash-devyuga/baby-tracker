import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import 'database_service.dart';
import 'pocketbase_service.dart';

class ActivityProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;
  final PocketBaseService _pb = PocketBaseService.instance;
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
    // Load last activities regardless of date (cross-day tracking)
    _lastSleep = await _db.getLastActivity(ActivityType.sleep);
    _lastFeed = await _db.getLastActivity(ActivityType.feed);
    _lastDiaper = await _db.getLastActivity(ActivityType.diaper);
  }

  // Get activities for a specific date
  Future<List<Activity>> getActivitiesForDate(DateTime date, {ActivityType? type}) async {
    return await _db.getActivities(date: date, type: type);
  }

  // Get last 7 days statistics
  Future<Map<String, dynamic>> getWeeklyStats() async {
    final now = DateTime.now();
    final weekStats = <String, Map<String, dynamic>>{};

    int totalSleep = 0;
    int totalFeeds = 0;
    double totalFeedVolume = 0;
    int totalDiapers = 0;
    int daysWithData = 0;

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final dayActivities = await _db.getActivities(date: date);

      final sleepActivities = dayActivities.where((a) => a.type == ActivityType.sleep).toList();
      final feedActivities = dayActivities.where((a) => a.type == ActivityType.feed).toList();
      final diaperActivities = dayActivities.where((a) => a.type == ActivityType.diaper).toList();

      final daySleepMinutes = sleepActivities.fold(0, (sum, a) => sum + (a.calculatedDuration ?? 0));
      final dayFeedCount = feedActivities.length;
      final dayFeedVolume = feedActivities.fold(0.0, (sum, a) => sum + (a.feedAmount ?? 0));
      final dayDiaperCount = diaperActivities.length;

      if (dayActivities.isNotEmpty) daysWithData++;

      totalSleep += daySleepMinutes;
      totalFeeds += dayFeedCount;
      totalFeedVolume += dayFeedVolume;
      totalDiapers += dayDiaperCount;

      weekStats[dateKey] = {
        'date': date,
        'sleepMinutes': daySleepMinutes,
        'feeds': dayFeedCount,
        'feedVolume': dayFeedVolume,
        'diapers': dayDiaperCount,
      };
    }

    return {
      'dailyStats': weekStats,
      'averages': {
        'sleepMinutes': daysWithData > 0 ? totalSleep ~/ daysWithData : 0,
        'feeds': daysWithData > 0 ? totalFeeds / daysWithData : 0,
        'feedVolume': daysWithData > 0 ? totalFeedVolume / daysWithData : 0,
        'diapers': daysWithData > 0 ? totalDiapers / daysWithData : 0,
      },
      'totals': {
        'sleepMinutes': totalSleep,
        'feeds': totalFeeds,
        'feedVolume': totalFeedVolume,
        'diapers': totalDiapers,
      }
    };
  }

  Future<void> addActivity(Activity activity) async {
    final localId = await _db.insertActivity(activity);

    // Sync to cloud if authenticated
    if (_pb.isAuthenticated) {
      final activityWithId = Activity(
        id: localId,
        type: activity.type,
        timestamp: activity.timestamp,
        durationMinutes: activity.durationMinutes,
        sleepEndTime: activity.sleepEndTime,
        notes: activity.notes,
        feedType: activity.feedType,
        feedAmount: activity.feedAmount,
        diaperType: activity.diaperType,
        cloudId: activity.cloudId,
      );
      await _pb.syncActivityToCloud(activityWithId);
    }

    await loadActivities();
  }

  Future<void> deleteActivity(int id) async {
    await _db.deleteActivity(id);

    // Sync deletion to cloud if authenticated
    if (_pb.isAuthenticated) {
      await _pb.deleteActivityFromCloud(id);
    }

    await loadActivities();
  }

  Future<void> updateActivity(Activity activity) async {
    await _db.updateActivity(activity);

    // Sync update to cloud if authenticated
    if (_pb.isAuthenticated) {
      await _pb.syncActivityToCloud(activity);
    }

    await loadActivities();
  }

  // Sync all activities from cloud
  Future<void> syncFromCloud() async {
    if (!_pb.isAuthenticated) return;

    final cloudActivities = await _pb.getActivitiesFromCloud();

    for (final cloudData in cloudActivities) {
      final activity = Activity.fromCloud(cloudData);

      // Check if activity already exists locally
      if (activity.id != null) {
        final existing = await _db.getActivities();
        final found = existing.any((a) => a.id == activity.id);

        if (found) {
          await _db.updateActivity(activity);
        } else {
          await _db.insertActivity(activity);
        }
      } else {
        await _db.insertActivity(activity);
      }
    }

    await loadActivities();
  }

  // Sync all local activities TO cloud
  Future<int> syncAllToCloud() async {
    if (!_pb.isAuthenticated) return 0;

    // Get all activities from local database (no date filter)
    final allLocalActivities = await _db.getActivities();
    int syncedCount = 0;

    for (final activity in allLocalActivities) {
      try {
        await _pb.syncActivityToCloud(activity);
        syncedCount++;
      } catch (e) {
        print('Error syncing activity ${activity.id}: $e');
      }
    }

    return syncedCount;
  }

  // Initialize real-time sync
  void initializeRealtimeSync() {
    if (!_pb.isAuthenticated) return;

    _pb.subscribeToActivities((cloudData) async {
      final activity = Activity.fromCloud(cloudData);
      await loadActivities();
    });
  }

  // Cleanup when provider is disposed
  @override
  void dispose() {
    _pb.unsubscribeFromActivities();
    super.dispose();
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
      (sum, activity) => sum + (activity.calculatedDuration ?? 0),
    );
  }

  int getTotalFeeds() {
    return getTodayActivities(ActivityType.feed).length;
  }

  double getTotalFeedVolume() {
    final feedActivities = getTodayActivities(ActivityType.feed);
    return feedActivities.fold(
      0.0,
      (sum, activity) => sum + (activity.feedAmount ?? 0),
    );
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
