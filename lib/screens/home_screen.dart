import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/activity_provider.dart';
import '../models/activity.dart';
import 'add_activity_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ActivityProvider>();
      provider.loadActivities();
      provider.syncFromCloud();
      provider.initializeRealtimeSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Care Tracker'),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'Statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.syncFromCloud();
              await provider.loadActivities();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDailySummaryCard(provider),
                  const SizedBox(height: 20),
                  _buildLastActivityCard(
                    'Last Sleep',
                    provider.lastSleep,
                    provider.getTimeSinceLastActivity(provider.lastSleep),
                    Icons.bedtime,
                    Colors.indigo,
                  ),
                  const SizedBox(height: 12),
                  _buildLastActivityCard(
                    'Last Feed',
                    provider.lastFeed,
                    provider.getTimeSinceLastActivity(provider.lastFeed),
                    Icons.restaurant,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildLastActivityCard(
                    'Last Diaper',
                    provider.lastDiaper,
                    provider.getTimeSinceLastActivity(provider.lastDiaper),
                    Icons.baby_changing_station,
                    Colors.green,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActionButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailySummaryCard(ActivityProvider provider) {
    final totalSleepMinutes = provider.getTotalSleepMinutes();
    final totalSleepHours = totalSleepMinutes ~/ 60;
    final remainingMinutes = totalSleepMinutes % 60;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Sleep',
                  '${totalSleepHours}h ${remainingMinutes}m',
                  Icons.bedtime,
                  Colors.indigo,
                ),
                _buildSummaryItem(
                  'Feeds',
                  '${provider.getTotalFeeds()}\n${provider.getTotalFeedVolume().toInt()} ml',
                  Icons.restaurant,
                  Colors.orange,
                ),
                _buildSummaryItem(
                  'Diapers',
                  '${provider.getTotalDiapers()}',
                  Icons.baby_changing_station,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLastActivityCard(
    String title,
    Activity? activity,
    String timeSince,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(timeSince),
        trailing: activity != null
            ? Text(
                _formatTime(activity.timestamp),
                style: const TextStyle(fontSize: 12),
              )
            : null,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildQuickActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToAddActivity(context, ActivityType.sleep),
            icon: const Icon(Icons.bedtime),
            label: const Text('Sleep'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToAddActivity(context, ActivityType.feed),
            icon: const Icon(Icons.restaurant),
            label: const Text('Feed'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToAddActivity(context, ActivityType.diaper),
            icon: const Icon(Icons.baby_changing_station),
            label: const Text('Diaper'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToAddActivity(BuildContext context, ActivityType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(activityType: type),
      ),
    );
  }
}
