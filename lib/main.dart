import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/activity_provider.dart';
import 'services/pocketbase_service.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/baby_profile_screen.dart';

void main() {
  runApp(const BabyTrackerApp());
}

class BabyTrackerApp extends StatelessWidget {
  const BabyTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityProvider(),
      child: MaterialApp(
        title: 'Baby Care Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/profile': (context) => const BabyProfileScreen(),
          '/home': (context) => const HomeScreen(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final pb = PocketBaseService.instance;

    // Wait a moment for splash screen effect
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (pb.isAuthenticated) {
      // Check if user has a baby profile
      final profileId = await pb.getBabyProfileId();

      if (profileId == null) {
        // Navigate to baby profile setup
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        // Navigate to home screen and initialize sync
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // Navigate to auth screen
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.baby_changing_station,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Baby Care Tracker',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
