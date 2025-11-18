import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../services/activity_provider.dart';
import 'package:intl/intl.dart';

class AddActivityScreen extends StatefulWidget {
  final ActivityType activityType;
  final Activity? activity;

  const AddActivityScreen({
    Key? key,
    required this.activityType,
    this.activity,
  }) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  late DateTime _selectedDateTime;
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();
  final _feedAmountController = TextEditingController();

  String? _selectedFeedType = 'Bottle';
  String? _selectedDiaperType = 'Wet';

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.activity?.timestamp ?? DateTime.now();
    _notesController.text = widget.activity?.notes ?? '';

    if (widget.activity != null) {
      _durationController.text = widget.activity!.durationMinutes?.toString() ?? '';
      _feedAmountController.text = widget.activity!.feedAmount?.toString() ?? '';
      _selectedFeedType = widget.activity!.feedType ?? 'Bottle';
      _selectedDiaperType = widget.activity!.diaperType ?? 'Wet';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _durationController.dispose();
    _feedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: _getColor(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimePicker(),
            const SizedBox(height: 20),
            ..._buildTypeSpecificFields(),
            const SizedBox(height: 20),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColor(),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.activity == null ? 'Save' : 'Update',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    final action = widget.activity == null ? 'Add' : 'Edit';
    switch (widget.activityType) {
      case ActivityType.sleep:
        return '$action Sleep';
      case ActivityType.feed:
        return '$action Feed';
      case ActivityType.diaper:
        return '$action Diaper Change';
    }
  }

  Color _getColor() {
    switch (widget.activityType) {
      case ActivityType.sleep:
        return Colors.indigo;
      case ActivityType.feed:
        return Colors.orange;
      case ActivityType.diaper:
        return Colors.green;
    }
  }

  Widget _buildDateTimePicker() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: const Text('Date & Time'),
        subtitle: Text(DateFormat('MMM dd, yyyy - HH:mm').format(_selectedDateTime)),
        trailing: const Icon(Icons.edit),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDateTime,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
          );

          if (date != null && mounted) {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
            );

            if (time != null && mounted) {
              setState(() {
                _selectedDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              });
            }
          }
        },
      ),
    );
  }

  List<Widget> _buildTypeSpecificFields() {
    switch (widget.activityType) {
      case ActivityType.sleep:
        return [
          TextField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Duration (minutes)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.timer),
            ),
            keyboardType: TextInputType.number,
          ),
        ];

      case ActivityType.feed:
        return [
          DropdownButtonFormField<String>(
            value: _selectedFeedType,
            decoration: const InputDecoration(
              labelText: 'Feed Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_dining),
            ),
            items: ['Bottle', 'Breast - Left', 'Breast - Right', 'Breast - Both', 'Solid']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFeedType = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _feedAmountController,
            decoration: const InputDecoration(
              labelText: 'Amount (ml/oz)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.opacity),
            ),
            keyboardType: TextInputType.number,
          ),
        ];

      case ActivityType.diaper:
        return [
          DropdownButtonFormField<String>(
            value: _selectedDiaperType,
            decoration: const InputDecoration(
              labelText: 'Diaper Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.info_outline),
            ),
            items: ['Wet', 'Dirty', 'Both']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedDiaperType = value;
              });
            },
          ),
        ];
    }
  }

  void _saveActivity() {
    final activity = Activity(
      id: widget.activity?.id,
      type: widget.activityType,
      timestamp: _selectedDateTime,
      durationMinutes: _durationController.text.isNotEmpty
          ? int.tryParse(_durationController.text)
          : null,
      feedType: widget.activityType == ActivityType.feed ? _selectedFeedType : null,
      feedAmount: _feedAmountController.text.isNotEmpty
          ? double.tryParse(_feedAmountController.text)
          : null,
      diaperType: widget.activityType == ActivityType.diaper ? _selectedDiaperType : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    final provider = context.read<ActivityProvider>();

    if (widget.activity == null) {
      provider.addActivity(activity);
    } else {
      provider.updateActivity(activity);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.activity == null
              ? 'Activity added successfully!'
              : 'Activity updated successfully!',
        ),
        backgroundColor: _getColor(),
      ),
    );
  }
}
