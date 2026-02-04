import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_theme.dart';
import '../../utils/plant_helpers.dart';
import '../onboarding/plant_selection_screen.dart';
import '../onboarding/plant_details_screen.dart';
import '../../services/plant_storage_service.dart';

class PlantInfoScreen extends StatefulWidget {
  final Plant plant;
  final DateTime lastWatered;
  final List<DateTime> wateringHistory;
  final Function(Plant) onPlantUpdated;
  final VoidCallback onWaterNow;
  
  const PlantInfoScreen({
    Key? key,
    required this.plant,
    required this.lastWatered,
    required this.wateringHistory,
    required this.onPlantUpdated,
    required this.onWaterNow,
  }) : super(key: key);

  @override
  State<PlantInfoScreen> createState() => _PlantInfoScreenState();
}

class _PlantInfoScreenState extends State<PlantInfoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  int get daysUntilWatering {
    final nextWateringDate = widget.lastWatered.add(Duration(days: widget.plant.wateringDays));
    final difference = nextWateringDate.difference(DateTime.now());
    return difference.inDays;
  }
  
  bool get needsWater => daysUntilWatering <= 0;
  
  String _getDifficultyLabel(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.latwy:
        return 'Łatwy';
      case DifficultyLevel.sredni:
        return 'Średni';
      case DifficultyLevel.trudny:
        return 'Trudny';
    }
  }
  
  String _getLightRequirementLabel(LightRequirement req) {
    switch (req) {
      case LightRequirement.pelneSlonce:
        return 'Pełne słońce';
      case LightRequirement.polcien:
        return 'Półcień';
      case LightRequirement.cien:
        return 'Cień';
    }
  }
  
  String _getPlantTypeLabel(PlantType type) {
    switch (type) {
      case PlantType.doniczkowa:
        return 'Doniczkowa';
      case PlantType.wiszaca:
        return 'Wisząca';
      case PlantType.sukulentowa:
        return 'Sukulentowa';
      case PlantType.kwitnaca:
        return 'Kwitnąca';
    }
  }
  
  Color _getDifficultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.latwy:
        return Colors.green;
      case DifficultyLevel.sredni:
        return Colors.orange;
      case DifficultyLevel.trudny:
        return Colors.red;
    }
  }
  
  void _editPlant() async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsScreen(
          selectedPlant: widget.plant,
          existingPlant: widget.plant,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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
    
    if (result != null && result is Plant) {
      widget.onPlantUpdated(result);
      setState(() {
        // Refresh the UI with updated plant
      });
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
              AppTheme.backgroundGreen,
              AppTheme.lightGreen.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppTheme.primaryGreen),
                      onPressed: _editPlant,
                    ),
                  ],
                ),
              ),
              
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero emoji
                      Center(
                        child: FadeTransition(
                          opacity: _animationController,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.plant.emoji,
                                style: const TextStyle(fontSize: 80),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Plant name and difficulty
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-0.3, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeInOut,
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.plant.name,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(widget.plant.difficulty).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getDifficultyLabel(widget.plant.difficulty),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _getDifficultyColor(widget.plant.difficulty),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.plant.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textDark.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Details section
                      FadeTransition(
                        opacity: _animationController,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              const Text(
                                'Szczegóły',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              _buildDetailRow(
                                icon: Icons.height,
                                label: 'Wysokość',
                                value: '${widget.plant.height} cm',
                                color: Colors.blue,
                              ),
                              const Divider(height: 24),
                              
                              _buildDetailRow(
                                icon: Icons.cake,
                                label: 'Wiek',
                                value: '${widget.plant.age} ${getAgePluralization(widget.plant.age)}',
                                color: Colors.purple,
                              ),
                              const Divider(height: 24),
                              
                              _buildDetailRow(
                                icon: Icons.wb_sunny,
                                label: 'Wymagania świetlne',
                                value: _getLightRequirementLabel(widget.plant.lightRequirement),
                                color: Colors.orange,
                              ),
                              const Divider(height: 24),
                              
                              _buildDetailRow(
                                icon: Icons.category,
                                label: 'Typ rośliny',
                                value: _getPlantTypeLabel(widget.plant.plantType),
                                color: Colors.teal,
                              ),
                              const Divider(height: 24),
                              
                              _buildDetailRow(
                                icon: Icons.water_drop,
                                label: 'Częstotliwość podlewania',
                                value: 'Co ${widget.plant.wateringDays} dni',
                                color: AppTheme.primaryGreen,
                              ),
                              
                              if (widget.plant.toxicToAnimals) ...[
                                const Divider(height: 24),
                                _buildDetailRow(
                                  icon: Icons.pets,
                                  label: 'Ostrzeżenie',
                                  value: 'Toksyczna dla zwierząt',
                                  color: Colors.red,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      if (widget.plant.notes != null && widget.plant.notes!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _animationController,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
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
                                const Row(
                                  children: [
                                    Icon(Icons.notes, color: AppTheme.primaryGreen, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Notatki',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.plant.notes!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textDark.withOpacity(0.7),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Watering history
                      FadeTransition(
                        opacity: _animationController,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
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
                              const Row(
                                children: [
                                  Icon(Icons.history, color: AppTheme.primaryGreen, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Historia podlewania',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              if (widget.wateringHistory.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Brak historii podlewania',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textDark.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              else
                                ...widget.wateringHistory.reversed.take(5).map((date) {
                                  final formatter = DateFormat('dd.MM.yyyy, HH:mm');
                                  final daysAgo = DateTime.now().difference(date).inDays;
                                  String timeAgo;
                                  if (daysAgo == 0) {
                                    timeAgo = 'Dzisiaj';
                                  } else if (daysAgo == 1) {
                                    timeAgo = 'Wczoraj';
                                  } else {
                                    timeAgo = '$daysAgo dni temu';
                                  }
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.primaryGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                timeAgo,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textDark,
                                                ),
                                              ),
                                              Text(
                                                formatter.format(date),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.textDark.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.water_drop,
                                          color: AppTheme.lightGreen,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: _animationController,
        child: FloatingActionButton.extended(
          onPressed: () {
            widget.onWaterNow();
            Navigator.of(context).pop();
          },
          backgroundColor: AppTheme.primaryGreen,
          icon: const Icon(Icons.water_drop),
          label: const Text(
            'Podlej teraz',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textDark.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
