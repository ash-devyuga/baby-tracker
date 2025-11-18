import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/activity_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, dynamic>? _weeklyStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    final provider = context.read<ActivityProvider>();
    final stats = await provider.getWeeklyStats();
    setState(() {
      _weeklyStats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Statistics'),
        backgroundColor: Colors.blue[300],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAveragesCard(),
                    const SizedBox(height: 20),
                    const Text(
                      'Last 7 Days',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDailyStatsTable(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAveragesCard() {
    if (_weeklyStats == null) return const SizedBox.shrink();

    final averages = _weeklyStats!['averages'] as Map<String, dynamic>;
    final avgSleepMinutes = averages['sleepMinutes'] as int;
    final avgSleepHours = avgSleepMinutes ~/ 60;
    final avgSleepRemainingMinutes = avgSleepMinutes % 60;
    final avgFeeds = averages['feeds'] as double;
    final avgFeedVolume = averages['feedVolume'] as double;
    final avgDiapers = averages['diapers'] as double;

    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Daily Averages (Last 7 Days)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAverageStat(
                  'Sleep',
                  '${avgSleepHours}h ${avgSleepRemainingMinutes}m',
                  Icons.bedtime,
                  Colors.indigo,
                ),
                _buildAverageStat(
                  'Feeds',
                  '${avgFeeds.toStringAsFixed(1)}\n${avgFeedVolume.toStringAsFixed(0)} ml',
                  Icons.restaurant,
                  Colors.orange,
                ),
                _buildAverageStat(
                  'Diapers',
                  avgDiapers.toStringAsFixed(1),
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

  Widget _buildAverageStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildDailyStatsTable() {
    if (_weeklyStats == null) return const SizedBox.shrink();

    final dailyStats = _weeklyStats!['dailyStats'] as Map<String, Map<String, dynamic>>;
    final sortedKeys = dailyStats.keys.toList()..sort((a, b) => b.compareTo(a));

    return Card(
      elevation: 2,
      child: Column(
        children: [
          // Table Header
          Container(
            color: Colors.blue[100],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(Icons.bedtime, color: Colors.indigo, size: 20),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(Icons.restaurant, color: Colors.orange, size: 20),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(Icons.baby_changing_station, color: Colors.green, size: 20),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...sortedKeys.map((dateKey) {
            final dayData = dailyStats[dateKey]!;
            final date = dayData['date'] as DateTime;
            final sleepMinutes = dayData['sleepMinutes'] as int;
            final sleepHours = sleepMinutes ~/ 60;
            final sleepRemainingMinutes = sleepMinutes % 60;
            final feeds = dayData['feeds'] as int;
            final feedVolume = dayData['feedVolume'] as double;
            final diapers = dayData['diapers'] as int;

            final isToday = DateTime.now().difference(date).inHours < 24 &&
                DateTime.now().day == date.day;

            return Container(
              decoration: BoxDecoration(
                color: isToday ? Colors.blue[50] : null,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM dd').format(date),
                          style: TextStyle(
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        sleepMinutes > 0
                            ? '${sleepHours}h ${sleepRemainingMinutes}m'
                            : '-',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        feeds > 0
                            ? '$feeds\n${feedVolume.toInt()}ml'
                            : '-',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        diapers > 0 ? '$diapers' : '-',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
