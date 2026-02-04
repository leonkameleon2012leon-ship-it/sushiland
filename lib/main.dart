import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'services/plant_storage_service.dart';

void main() {
  runApp(const PlantCareApp());
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twoje Rośliny',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
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
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final isComplete = await PlantStorageService.isOnboardingComplete();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      if (isComplete) {
        final plants = await PlantStorageService.loadPlants();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              savedPlants: plants,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightGreen.withOpacity(0.3),
              AppTheme.backgroundGreen,
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.spa,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
