import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/pocketbase_service.dart';
import 'home_screen.dart';

class BabyProfileScreen extends StatefulWidget {
  const BabyProfileScreen({Key? key}) : super(key: key);

  @override
  State<BabyProfileScreen> createState() => _BabyProfileScreenState();
}

class _BabyProfileScreenState extends State<BabyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _babyNameController = TextEditingController();
  final _profileIdController = TextEditingController();
  final _partnerEmailController = TextEditingController();
  DateTime _birthDate = DateTime.now();
  bool _isLoading = false;
  bool _isJoiningProfile = false;

  @override
  void dispose() {
    _babyNameController.dispose();
    _profileIdController.dispose();
    _partnerEmailController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final pb = PocketBaseService.instance;
    final profileId = await pb.createBabyProfile(
      _babyNameController.text.trim(),
      _birthDate,
    );

    setState(() => _isLoading = false);

    if (profileId != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create baby profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _joinProfile() async {
    if (_profileIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a profile ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final pb = PocketBaseService.instance;
    await pb.setBabyProfileId(_profileIdController.text.trim());

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Profile Setup'),
        backgroundColor: Colors.pink[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await PocketBaseService.instance.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/auth');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.child_care,
                size: 80,
                color: Colors.pink[300],
              ),
              const SizedBox(height: 16),
              const Text(
                'Set up your baby\'s profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Create a new profile or join an existing one',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Create New'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Join Existing'),
                    icon: Icon(Icons.group_add),
                  ),
                ],
                selected: {_isJoiningProfile},
                onSelectionChanged: (Set<bool> selection) {
                  setState(() {
                    _isJoiningProfile = selection.first;
                  });
                },
              ),
              const SizedBox(height: 32),
              if (!_isJoiningProfile) _buildCreateProfileForm(),
              if (_isJoiningProfile) _buildJoinProfileForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _babyNameController,
            decoration: const InputDecoration(
              labelText: 'Baby\'s Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.child_care),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter baby\'s name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cake),
              title: const Text('Birth Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_birthDate)),
              trailing: const Icon(Icons.edit),
              onTap: _selectBirthDate,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _createProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Create Profile',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Ask your partner to share the Profile ID from Settings',
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _profileIdController,
          decoration: const InputDecoration(
            labelText: 'Profile ID',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.key),
            hintText: 'Enter the profile ID',
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _joinProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Join Profile',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }
}
