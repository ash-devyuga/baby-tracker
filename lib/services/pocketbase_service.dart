import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';

class PocketBaseService {
  static final PocketBaseService instance = PocketBaseService._init();
  late PocketBase pb;

  // Replace this URL with your PocketBase server URL
  // For local development: 'http://10.0.2.2:8090' (Android emulator)
  // For production: 'https://your-pocketbase-domain.com'
  static const String pocketBaseUrl = 'http://127.0.0.1:8090';

  PocketBaseService._init() {
    pb = PocketBase(pocketBaseUrl);
    _loadAuthFromStorage();
  }

  // Load saved authentication from local storage
  Future<void> _loadAuthFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('pocketbase_auth');

    if (authData != null) {
      try {
        pb.authStore.save(authData, null);
      } catch (e) {
        print('Error loading auth: $e');
      }
    }
  }

  // Save authentication to local storage
  Future<void> _saveAuthToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pocketbase_auth', pb.authStore.token);
  }

  // Check if user is authenticated
  bool get isAuthenticated => pb.authStore.isValid;

  // Get current user ID
  String? get userId => pb.authStore.model?.id;

  // Register a new user
  Future<bool> register(String email, String password, String name) async {
    try {
      await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        'name': name,
        'emailVisibility': true,
      });

      // Auto-login after registration
      return await login(email, password);
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      await _saveAuthToStorage();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    pb.authStore.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pocketbase_auth');
  }

  // Get current user's baby profile ID
  Future<String?> getBabyProfileId() async {
    if (!isAuthenticated) return null;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('baby_profile_id');
  }

  // Set baby profile ID
  Future<void> setBabyProfileId(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baby_profile_id', profileId);
  }

  // Create a baby profile
  Future<String?> createBabyProfile(String babyName, DateTime birthDate) async {
    if (!isAuthenticated) return null;

    try {
      final record = await pb.collection('baby_profiles').create(body: {
        'name': babyName,
        'birth_date': birthDate.toIso8601String(),
        'parents': [userId],
      });

      await setBabyProfileId(record.id);
      return record.id;
    } catch (e) {
      print('Error creating baby profile: $e');
      return null;
    }
  }

  // Add a parent to existing baby profile (for sharing between parents)
  Future<bool> addParentToProfile(String profileId, String parentEmail) async {
    if (!isAuthenticated) return false;

    try {
      // Find the parent user by email
      final users = await pb.collection('users').getFullList(
        filter: 'email = "$parentEmail"',
      );

      if (users.isEmpty) return false;

      final parentUserId = users.first.id;

      // Get current profile
      final profile = await pb.collection('baby_profiles').getOne(profileId);
      final currentParents = List<String>.from(profile.data['parents'] ?? []);

      if (!currentParents.contains(parentUserId)) {
        currentParents.add(parentUserId);

        await pb.collection('baby_profiles').update(profileId, body: {
          'parents': currentParents,
        });
      }

      return true;
    } catch (e) {
      print('Error adding parent: $e');
      return false;
    }
  }

  // Sync activity to PocketBase
  Future<String?> syncActivityToCloud(Activity activity) async {
    if (!isAuthenticated) return null;

    final profileId = await getBabyProfileId();
    if (profileId == null) return null;

    try {
      final data = {
        'baby_profile': profileId,
        'type': activity.type.toString(),
        'timestamp': activity.timestamp.toIso8601String(),
        'duration_minutes': activity.durationMinutes,
        'notes': activity.notes,
        'feed_type': activity.feedType,
        'feed_amount': activity.feedAmount,
        'diaper_type': activity.diaperType,
        'user': userId,
      };

      if (activity.id != null) {
        // Check if record exists in cloud by local_id
        final existing = await pb.collection('activities').getFullList(
          filter: 'local_id = "${activity.id}"',
        );

        if (existing.isNotEmpty) {
          // Update existing record
          await pb.collection('activities').update(existing.first.id, body: data);
          return existing.first.id;
        }
      }

      // Create new record
      data['local_id'] = activity.id.toString();
      final record = await pb.collection('activities').create(body: data);
      return record.id;
    } catch (e) {
      print('Error syncing activity: $e');
      return null;
    }
  }

  // Get all activities from cloud for current baby profile
  Future<List<Map<String, dynamic>>> getActivitiesFromCloud() async {
    if (!isAuthenticated) return [];

    final profileId = await getBabyProfileId();
    if (profileId == null) return [];

    try {
      final records = await pb.collection('activities').getFullList(
        filter: 'baby_profile = "$profileId"',
        sort: '-timestamp',
      );

      return records.map((record) => record.toJson()).toList();
    } catch (e) {
      print('Error fetching activities: $e');
      return [];
    }
  }

  // Delete activity from cloud
  Future<bool> deleteActivityFromCloud(int localId) async {
    if (!isAuthenticated) return false;

    try {
      final records = await pb.collection('activities').getFullList(
        filter: 'local_id = "$localId"',
      );

      if (records.isNotEmpty) {
        await pb.collection('activities').delete(records.first.id);
      }
      return true;
    } catch (e) {
      print('Error deleting activity: $e');
      return false;
    }
  }

  // Subscribe to real-time updates
  void subscribeToActivities(Function(Map<String, dynamic>) onUpdate) async {
    final profileId = await getBabyProfileId();
    if (profileId == null) return;

    pb.collection('activities').subscribe('*', (e) {
      if (e.record?.data['baby_profile'] == profileId) {
        onUpdate(e.record!.toJson());
      }
    });
  }

  // Unsubscribe from real-time updates
  void unsubscribeFromActivities() {
    pb.collection('activities').unsubscribe();
  }
}
