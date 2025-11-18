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
    // Cloud-first: Load from PocketBase if authenticated
    if (_pb.isAuthenticated) {
      try {
        final cloudActivities = await _pb.getActivitiesFromCloud();
        _activities = cloudActivities.map((data) => Activity.fromCloud(data)).toList();

        // Filter by date if specified
        if (date != null) {
          final startOfDay = DateTime(date.year, date.month, date.day);
          final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
          _activities = _activities.where((activity) =>
            activity.timestamp.isAfter(startOfDay) &&
            activity.timestamp.isBefore(endOfDay)
          ).toList();
        }

        // Clear and sync local DB cache with cloud data
        // (This ensures local DB stays in sync with cloud)
      } catch (e) {
        print('Error loading from cloud, falling back to local: $e');
        // Fallback to local DB if cloud fails
        _activities = await _db.getActivities(date: date);
      }
    } else {
      // Not authenticated, use local DB
      _activities = await _db.getActivities(date: date);
    }

    await _loadLastActivities();
    notifyListeners();
  }

  Future<void> _loadLastActivities() async {
    // Load last activities from current activities list (already from cloud)
    _lastSleep = _activities
        .where((a) => a.type == ActivityType.sleep)
        .fold<Activity?>(null, (prev, curr) =>
            prev == null || curr.timestamp.isAfter(prev.timestamp) ? curr : prev);

    _lastFeed = _activities
        .where((a) => a.type == ActivityType.feed)
        .fold<Activity?>(null, (prev, curr) =>
            prev == null || curr.timestamp.isAfter(prev.timestamp) ? curr : prev);

    _lastDiaper = _activities
        .where((a) => a.type == ActivityType.diaper)
        .fold<Activity?>(null, (prev, curr) =>
            prev == null || curr.timestamp.isAfter(prev.timestamp) ? curr : prev);
  }

  // Get activities for a specific date (from cloud)
  Future<List<Activity>> getActivitiesForDate(DateTime date, {ActivityType? type}) async {
    if (_pb.isAuthenticated) {
      try {
        final cloudActivities = await _pb.getActivitiesFromCloud();
        var activities = cloudActivities.map((data) => Activity.fromCloud(data)).toList();

        // Filter by date
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
        activities = activities.where((activity) =>
          activity.timestamp.isAfter(startOfDay) &&
          activity.timestamp.isBefore(endOfDay)
        ).toList();

        // Filter by type if specified
        if (type != null) {
          activities = activities.where((a) => a.type == type).toList();
        }

        return activities;
      } catch (e) {
        print('Error loading from cloud, falling back to local: $e');
        return await _db.getActivities(date: date, type: type);
      }
    } else {
      return await _db.getActivities(date: date, type: type);
    }
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

      final dayActivities = await getActivitiesForDate(date);

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
    // Cloud-first: Save to PocketBase first
    if (_pb.isAuthenticated) {
      try {
        // Save to cloud
        final cloudId = await _pb.syncActivityToCloud(activity);

        // Then cache locally with cloud ID
        final activityWithCloudId = Activity(
          id: activity.id,
          type: activity.type,
          timestamp: activity.timestamp,
          durationMinutes: activity.durationMinutes,
          sleepEndTime: activity.sleepEndTime,
          notes: activity.notes,
          feedType: activity.feedType,
          feedAmount: activity.feedAmount,
          diaperType: activity.diaperType,
          cloudId: cloudId,
        );
        await _db.insertActivity(activityWithCloudId);
      } catch (e) {
        print('Error saving to cloud: $e');
        // Fallback: save to local only
        await _db.insertActivity(activity);
      }
    } else {
      // Not authenticated, save to local only
      await _db.insertActivity(activity);
    }

    await loadActivities();
  }

  Future<void> deleteActivity(int id) async {
    // Cloud-first: Delete from cloud first
    if (_pb.isAuthenticated) {
      try {
        await _pb.deleteActivityFromCloud(id);
      } catch (e) {
        print('Error deleting from cloud: $e');
      }
    }

    // Also delete from local cache
    await _db.deleteActivity(id);
    await loadActivities();
  }

  Future<void> updateActivity(Activity activity) async {
    // Cloud-first: Update in cloud first
    if (_pb.isAuthenticated) {
      try {
        await _pb.syncActivityToCloud(activity);
      } catch (e) {
        print('Error updating cloud: $e');
      }
    }

    // Also update local cache
    await _db.updateActivity(activity);
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
