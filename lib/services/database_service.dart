import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('baby_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        durationMinutes INTEGER,
        sleepEndTime TEXT,
        notes TEXT,
        feedType TEXT,
        feedAmount REAL,
        diaperType TEXT,
        cloudId TEXT
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add cloudId column for PocketBase sync
      await db.execute('ALTER TABLE activities ADD COLUMN cloudId TEXT');
    }
    if (oldVersion < 3) {
      // Add sleepEndTime column for sleep tracking
      await db.execute('ALTER TABLE activities ADD COLUMN sleepEndTime TEXT');
    }
  }

  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return await db.insert('activities', activity.toMap());
  }

  Future<List<Activity>> getActivities({ActivityType? type, DateTime? date}) async {
    final db = await database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (type != null) {
      whereClause = 'type = ?';
      whereArgs.add(type.toString());
    }

    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'timestamp >= ? AND timestamp <= ?';
      whereArgs.addAll([startOfDay.toIso8601String(), endOfDay.toIso8601String()]);
    }

    final maps = await db.query(
      'activities',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => Activity.fromMap(map)).toList();
  }

  Future<Activity?> getLastActivity(ActivityType type) async {
    final db = await database;
    final maps = await db.query(
      'activities',
      where: 'type = ?',
      whereArgs: [type.toString()],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Activity.fromMap(maps.first);
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await database;
    return await db.update(
      'activities',
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
