import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../services/activity_provider.dart';
import 'package:intl/intl.dart';
import 'add_activity_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        backgroundColor: Colors.blue[300],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.bedtime), text: 'Sleep'),
            Tab(icon: Icon(Icons.restaurant), text: 'Feed'),
            Tab(icon: Icon(Icons.baby_changing_station), text: 'Diaper'),
          ],
        ),
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildActivityList(
                provider.getTodayActivities(ActivityType.sleep),
                ActivityType.sleep,
                Colors.indigo,
              ),
              _buildActivityList(
                provider.getTodayActivities(ActivityType.feed),
                ActivityType.feed,
                Colors.orange,
              ),
              _buildActivityList(
                provider.getTodayActivities(ActivityType.diaper),
                ActivityType.diaper,
                Colors.green,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActivityList(
    List<Activity> activities,
    ActivityType type,
    Color color,
  ) {
    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(type),
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No ${_getTypeName(type).toLowerCase()} recorded today',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(_getIcon(type), color: color),
            ),
            title: Text(_getActivityTitle(activity)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(activity.timestamp),
                ),
                if (activity.notes != null && activity.notes!.isNotEmpty)
                  Text(
                    activity.notes!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _editActivity(activity);
                } else if (value == 'delete') {
                  _deleteActivity(activity);
                }
              },
            ),
          ),
        );
      },
    );
  }

  IconData _getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.sleep:
        return Icons.bedtime;
      case ActivityType.feed:
        return Icons.restaurant;
      case ActivityType.diaper:
        return Icons.baby_changing_station;
    }
  }

  String _getTypeName(ActivityType type) {
    switch (type) {
      case ActivityType.sleep:
        return 'Sleep';
      case ActivityType.feed:
        return 'Feed';
      case ActivityType.diaper:
        return 'Diaper';
    }
  }

  String _getActivityTitle(Activity activity) {
    switch (activity.type) {
      case ActivityType.sleep:
        final duration = activity.calculatedDuration ?? 0;
        final hours = duration ~/ 60;
        final minutes = duration % 60;
        final durationStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

        if (activity.sleepEndTime != null) {
          final startTime = DateFormat('HH:mm').format(activity.timestamp);
          final endTime = DateFormat('HH:mm').format(activity.sleepEndTime!);
          return 'Sleep - $durationStr ($startTime → $endTime)';
        } else {
          return 'Sleep - Started (no end time yet)';
        }

      case ActivityType.feed:
        final feedInfo = StringBuffer(activity.feedType ?? 'Feed');
        if (activity.feedAmount != null) {
          feedInfo.write(' - ${activity.feedAmount} ml');
        }
        return feedInfo.toString();

      case ActivityType.diaper:
        return 'Diaper - ${activity.diaperType ?? "Changed"}';
    }
  }

  void _editActivity(Activity activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(
          activityType: activity.type,
          activity: activity,
        ),
      ),
    );
  }

  void _deleteActivity(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ActivityProvider>().deleteActivity(activity.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Activity deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
