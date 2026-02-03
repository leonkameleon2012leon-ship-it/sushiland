import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../home/dashboard_screen.dart';

class Plant {
  final String name;
  final String emoji;
  final String description;
  final int wateringDays;
  
  const Plant({
    required this.name,
    required this.emoji,
    required this.description,
    required this.wateringDays,
  });
}

const List<Plant> availablePlants = [
  Plant(name: 'Monstera', emoji: '🌿', description: 'Łatwa w pielęgnacji', wateringDays: 7),
  Plant(name: 'Aloes', emoji: '🪴', description: 'Nie wymaga dużo wody', wateringDays: 14),
  Plant(name: 'Paproć', emoji: '🌱', description: 'Lubi wilgotne środowisko', wateringDays: 5),
  Plant(name: 'Kaktus', emoji: '🌵', description: 'Bardzo wytrzymały', wateringDays: 21),
  Plant(name: 'Storczyk', emoji: '🌺', description: 'Piękne kwiaty', wateringDays: 10),
  Plant(name: 'Filodendron', emoji: '🍃', description: 'Duże zielone liście', wateringDays: 7),
  Plant(name: 'Sansewieria', emoji: '🌿', description: 'Bardzo odporna', wateringDays: 14),
  Plant(name: 'Pothos', emoji: '🌱', description: 'Oczyszcza powietrze', wateringDays: 7),
];

class PlantSelectionScreen extends StatefulWidget {
  const PlantSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PlantSelectionScreen> createState() => _PlantSelectionScreenState();
}

class _PlantSelectionScreenState extends State<PlantSelectionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedPlants = {};
  late AnimationController _animationController;
  List<Plant> _filteredPlants = availablePlants;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _animationController.forward();
    
    _searchController.addListener(_filterPlants);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _filterPlants() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPlants = availablePlants;
      } else {
        _filteredPlants = availablePlants.where((plant) {
          return plant.name.toLowerCase().contains(query) ||
                 plant.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  
  void _togglePlant(int index) {
    setState(() {
      if (_selectedPlants.contains(index)) {
        _selectedPlants.remove(index);
      } else {
        _selectedPlants.add(index);
      }
    });
  }
  
  void _navigateToHome() {
    final selectedPlantsList = _selectedPlants.map((i) => availablePlants[i]).toList();
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DashboardScreen(
          initialPlants: selectedPlantsList,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
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
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    Text(
                      'Wybierz swoje rośliny',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      'Wybierz rośliny, o które chcesz dbać',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textDark.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Szukaj rośliny...',
                        prefixIcon: Icon(Icons.search, color: AppTheme.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  itemCount: _filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = _filteredPlants[index];
                    final originalIndex = availablePlants.indexOf(plant);
                    final isSelected = _selectedPlants.contains(originalIndex);
                    
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: Transform.scale(
                              scale: 0.8 + (0.2 * value),
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildPlantCard(plant, isSelected, () => _togglePlant(originalIndex)),
                      ),
                    );
                  },
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (_selectedPlants.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Wybrano: ${_selectedPlants.length} roślin',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textDark.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    
                    ElevatedButton(
                      onPressed: _selectedPlants.isNotEmpty ? _navigateToHome : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Dalej',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPlantCard(Plant plant, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? AppTheme.primaryGreen.withOpacity(0.3)
                  : AppTheme.primaryGreen.withOpacity(0.1),
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryGreen.withOpacity(0.2)
                    : AppTheme.lightGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                plant.emoji,
                style: const TextStyle(fontSize: 36),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Podlewanie co ${plant.wateringDays} dni',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryGreen.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.0 : 0.8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.lightGreen,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
