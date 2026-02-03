import 'package:flutter/material.dart';
import 'dart:math';
import '../../constants/app_theme.dart';
import 'name_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _leafController;
  late AnimationController _fadeController;
  
  @override
  void initState() {
    super.initState();
    
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeController.forward();
  }
  
  @override
  void dispose() {
    _leafController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  
  void _navigateToNameScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const NameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: FadeTransition(
        opacity: _fadeController,
        child: Container(
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
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _leafController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: sin(_leafController.value * 2 * pi) * 0.1,
                          child: Transform.translate(
                            offset: Offset(
                              sin(_leafController.value * 2 * pi) * 20,
                              0,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.eco,
                        size: 120,
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                      ),
                    ),
                    
                    AnimatedBuilder(
                      animation: _leafController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: -sin(_leafController.value * 2 * pi + 1) * 0.15,
                          child: Transform.translate(
                            offset: Offset(
                              -sin(_leafController.value * 2 * pi + 1) * 15,
                              sin(_leafController.value * 2 * pi + 1) * 10,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.eco,
                        size: 80,
                        color: AppTheme.darkGreen.withOpacity(0.4),
                      ),
                    ),
                    
                    const Icon(
                      Icons.spa,
                      size: 100,
                      color: AppTheme.primaryGreen,
                    ),
                  ],
                ),
                
                const SizedBox(height: 60),
                
                Text(
                  'Zadbaj o swoje',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'rośliny 🌱',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  'Twoje rośliny to żywe istoty,\nktóre potrzebują Twojej uwagi',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textDark.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(flex: 3),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _navigateToNameScreen,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Zaczynamy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
