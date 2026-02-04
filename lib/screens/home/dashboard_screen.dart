import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../../constants/app_theme.dart';
import '../../services/plant_storage_service.dart';
import '../onboarding/plant_selection_screen.dart';
import '../onboarding/welcome_screen.dart';

class PlantStatus {
  final Plant plant;
  DateTime lastWatered;
  
  PlantStatus({
    required this.plant,
    DateTime? lastWatered,
  }) : lastWatered = lastWatered ?? DateTime.now();
  
  int get daysUntilWatering {
    final nextWateringDate = lastWatered.add(Duration(days: plant.wateringDays));
    final difference = nextWateringDate.difference(DateTime.now());
    return difference.inDays;
  }
  
  bool get needsWater => daysUntilWatering <= 0;
  
  String get statusMessage {
    if (needsWater) {
      return 'Twoja ${plant.name.toLowerCase()} chce się napić 💧';
    } else if (daysUntilWatering == 1) {
      return 'Jutro podlej swoją ${plant.name.toLowerCase()} 🌱';
    } else {
      return 'Wszystko w porządku 😊';
    }
  }
  
  PlantData toPlantData() {
    return PlantData(
      name: plant.name,
      emoji: plant.emoji,
      description: plant.description,
      wateringDays: plant.wateringDays,
      lastWatered: lastWatered,
    );
  }
  
  factory PlantStatus.fromPlantData(PlantData data) {
    return PlantStatus(
      plant: data.toPlant(),
      lastWatered: data.lastWatered,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final List<Plant>? initialPlants;
  final List<PlantData>? savedPlants;
  
  const DashboardScreen({
    Key? key,
    this.initialPlants,
    this.savedPlants,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late List<PlantStatus> _plants;
  String _userName = '';
  late AnimationController _greetingAnimationController;
  
  @override
  void initState() {
    super.initState();
    
    // Load plants from either saved data or initial plants
    if (widget.savedPlants != null && widget.savedPlants!.isNotEmpty) {
      _plants = widget.savedPlants!.map((data) => PlantStatus.fromPlantData(data)).toList();
    } else if (widget.initialPlants != null && widget.initialPlants!.isNotEmpty) {
      _plants = widget.initialPlants!.map((plant) => PlantStatus(plant: plant)).toList();
    } else {
      _plants = [];
    }
    
    _greetingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _greetingAnimationController.forward();
    _loadUserName();
    
    // Save plants whenever they're initialized or modified
    if (_plants.isNotEmpty) {
      _savePlants();
    }
  }
  
  @override
  void dispose() {
    _greetingAnimationController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'Przyjacielu';
    setState(() {
      _userName = name;
    });
  }
  
  Future<void> _savePlants() async {
    final plantDataList = _plants.map((p) => p.toPlantData()).toList();
    await PlantStorageService.savePlants(plantDataList);
  }
  
  void _waterPlant(int index) {
    setState(() {
      _plants[index].lastWatered = DateTime.now();
    });
    
    _savePlants();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_plants[index].plant.name} podlany! 💧'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  void _deletePlant(int index) {
    final plantName = _plants[index].plant.name;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Usuń roślinę'),
          content: Text('Czy na pewno chcesz usunąć $plantName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _plants.removeAt(index);
                });
                _savePlants();
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$plantName została usunięta'),
                    backgroundColor: AppTheme.darkGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Usuń'),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _addPlant() async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const PlantSelectionScreen(
          isAddingPlants: true,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
    
    // If plants were added, update the list
    if (result != null && result is List<Plant>) {
      setState(() {
        for (final plant in result) {
          // Check if plant already exists
          final exists = _plants.any((p) => p.plant.name == plant.name);
          if (!exists) {
            _plants.add(PlantStatus(plant: plant));
          }
        }
      });
      _savePlants();
    }
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Dzień dobry';
    } else if (hour < 18) {
      return 'Witaj';
    } else {
      return 'Dobry wieczór';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent going back to onboarding
        return false;
      },
      child: Scaffold(
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
          child: SafeArea(
            child: Column(
              children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _greetingAnimationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.5),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _greetingAnimationController,
                      curve: Curves.easeInOut,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        Row(
                          children: [
                            const Icon(
                              Icons.spa,
                              color: AppTheme.primaryGreen,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Twoje Rośliny',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 24,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const Spacer(),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.settings,
                                color: AppTheme.textDark,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (value) async {
                                if (value == 'reset') {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: const Text('Resetuj aplikację'),
                                        content: const Text(
                                          'Czy na pewno chcesz zresetować aplikację? '
                                          'Wszystkie dane zostaną usunięte i będziesz musiał '
                                          'ponownie przejść przez onboarding.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Anuluj'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('Resetuj'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  
                                  if (confirm == true && mounted) {
                                    await PlantStorageService.clearAllData();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const WelcomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'reset',
                                  child: Row(
                                    children: [
                                      Icon(Icons.refresh, color: Colors.red, size: 20),
                                      SizedBox(width: 8),
                                      Text('Resetuj aplikację'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Text(
                          '${_getGreeting()}, $_userName! 🌱',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            color: AppTheme.textDark.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: _plants.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _plants.length,
                        itemBuilder: (context, index) {
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 400 + (index * 100)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 50 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildPlantCard(_plants[index], index),
                            ),
                          );
                        },
                      ),
              ),
              
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _addPlant,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text(
                            'Dodaj roślinę',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_florist,
            size: 80,
            color: AppTheme.lightGreen,
          ),
          const SizedBox(height: 24),
          Text(
            'Nie masz jeszcze roślin',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dodaj swoją pierwszą roślinę,\naby zacząć o nią dbać',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textDark.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlantCard(PlantStatus plantStatus, int index) {
    final needsWater = plantStatus.needsWater;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: needsWater
                      ? AppTheme.lightGreen.withOpacity(0.2)
                      : AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  plantStatus.plant.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plantStatus.plant.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plantStatus.plant.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.textDark,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _deletePlant(index);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Usuń'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: needsWater
                  ? AppTheme.primaryGreen.withOpacity(0.1)
                  : AppTheme.backgroundGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  needsWater ? Icons.water_drop : Icons.check_circle,
                  color: needsWater ? AppTheme.primaryGreen : AppTheme.lightGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    plantStatus.statusMessage,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textDark.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (!needsWater) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: AppTheme.lightGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Podlewanie za ${plantStatus.daysUntilWatering} dni',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 20),
          
          if (needsWater)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _waterPlant(index),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.water_drop, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Podlej teraz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
