enum ActivityType {
  sleep,
  feed,
  diaper,
}

class Activity {
  final int? id;
  final ActivityType type;
  final DateTime timestamp;
  final int? durationMinutes; // For sleep
  final String? notes;
  final String? feedType; // bottle, breast, solid
  final double? feedAmount; // in ml or oz
  final String? diaperType; // wet, dirty, both

  Activity({
    this.id,
    required this.type,
    required this.timestamp,
    this.durationMinutes,
    this.notes,
    this.feedType,
    this.feedAmount,
    this.diaperType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
      'feedType': feedType,
      'feedAmount': feedAmount,
      'diaperType': diaperType,
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
      notes: map['notes'] as String?,
      feedType: map['feedType'] as String?,
      feedAmount: map['feedAmount'] as double?,
      diaperType: map['diaperType'] as String?,
    );
  }
}
