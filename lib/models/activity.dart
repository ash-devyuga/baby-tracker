enum ActivityType {
  sleep,
  feed,
  diaper,
}

class Activity {
  final int? id;
  final ActivityType type;
  final DateTime timestamp; // For sleep: start time, For others: activity time
  final int? durationMinutes; // For sleep (calculated from start/end or manually entered)
  final DateTime? sleepEndTime; // For sleep: end time (optional, can be updated later)
  final String? notes;
  final String? feedType; // bottle, breast, solid
  final double? feedAmount; // in ml or oz
  final String? diaperType; // wet, dirty, both
  final String? cloudId; // PocketBase sync ID

  Activity({
    this.id,
    required this.type,
    required this.timestamp,
    this.durationMinutes,
    this.sleepEndTime,
    this.notes,
    this.feedType,
    this.feedAmount,
    this.diaperType,
    this.cloudId,
  });

  // Calculate duration from start and end times if both are available
  int? get calculatedDuration {
    if (type == ActivityType.sleep && sleepEndTime != null) {
      return sleepEndTime!.difference(timestamp).inMinutes;
    }
    return durationMinutes;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'durationMinutes': durationMinutes,
      'sleepEndTime': sleepEndTime?.toIso8601String(),
      'notes': notes,
      'feedType': feedType,
      'feedAmount': feedAmount,
      'diaperType': diaperType,
      'cloudId': cloudId,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int?,
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      timestamp: DateTime.parse(map['timestamp'] as String),
      durationMinutes: map['durationMinutes'] as int?,
      sleepEndTime: map['sleepEndTime'] != null
          ? DateTime.parse(map['sleepEndTime'] as String)
          : null,
      notes: map['notes'] as String?,
      feedType: map['feedType'] as String?,
      feedAmount: map['feedAmount'] as double?,
      diaperType: map['diaperType'] as String?,
      cloudId: map['cloudId'] as String?,
    );
  }

  // Create Activity from PocketBase cloud data
  factory Activity.fromCloud(Map<String, dynamic> cloudData) {
    // Helper to safely parse dates (handles null and empty strings)
    DateTime? parseDate(dynamic value) {
      if (value == null || value == '') return null;
      try {
        return DateTime.parse(value.toString());
      } catch (e) {
        return null;
      }
    }

    return Activity(
      id: cloudData['local_id'] != null ? int.tryParse(cloudData['local_id'].toString()) : null,
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == cloudData['type'],
      ),
      timestamp: parseDate(cloudData['timestamp']) ?? DateTime.now(),
      durationMinutes: cloudData['duration_minutes'] as int?,
      sleepEndTime: parseDate(cloudData['sleep_end_time']),
      notes: cloudData['notes'] as String?,
      feedType: cloudData['feed_type'] as String?,
      feedAmount: cloudData['feed_amount'] != null
          ? (cloudData['feed_amount'] as num).toDouble()
          : null,
      diaperType: cloudData['diaper_type'] as String?,
      cloudId: cloudData['id'] as String?,
    );
  }
}
