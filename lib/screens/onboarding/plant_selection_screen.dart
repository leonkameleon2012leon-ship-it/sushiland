import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../services/plant_storage_service.dart';
import '../home/dashboard_screen.dart';
import '../plant/plant_scan_screen.dart';
import 'plant_details_screen.dart';

enum DifficultyLevel { latwy, sredni, trudny }

enum LightRequirement { pelneSlonce, polcien, cien }

enum PlantType { doniczkowa, wiszaca, sukulentowa, kwitnaca }

class Plant {
  final String name;
  final String emoji;
  final String description;
  final int wateringDays;
  final int age; // w latach
  final int height; // w cm
  final DifficultyLevel difficulty;
  final LightRequirement lightRequirement;
  final PlantType plantType;
  final bool toxicToAnimals;
  final String? notes;
  
  const Plant({
    required this.name,
    required this.emoji,
    required this.description,
    required this.wateringDays,
    this.age = 1,
    this.height = 30,
    this.difficulty = DifficultyLevel.latwy,
    this.lightRequirement = LightRequirement.polcien,
    this.plantType = PlantType.doniczkowa,
    this.toxicToAnimals = false,
    this.notes,
  });
  
  Plant copyWith({
    String? name,
    String? emoji,
    String? description,
    int? wateringDays,
    int? age,
    int? height,
    DifficultyLevel? difficulty,
    LightRequirement? lightRequirement,
    PlantType? plantType,
    bool? toxicToAnimals,
    String? notes,
  }) {
    return Plant(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      wateringDays: wateringDays ?? this.wateringDays,
      age: age ?? this.age,
      height: height ?? this.height,
      difficulty: difficulty ?? this.difficulty,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      plantType: plantType ?? this.plantType,
      toxicToAnimals: toxicToAnimals ?? this.toxicToAnimals,
      notes: notes ?? this.notes,
    );
  }
}

const List<Plant> availablePlants = [
  Plant(
    name: 'Monstera',
    emoji: '🌿',
    description: 'Łatwa w pielęgnacji',
    wateringDays: 7,
    age: 2,
    height: 45,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Aloes',
    emoji: '🪴',
    description: 'Nie wymaga dużo wody',
    wateringDays: 14,
    age: 3,
    height: 25,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.sukulentowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Paproć',
    emoji: '🌱',
    description: 'Lubi wilgotne środowisko',
    wateringDays: 5,
    age: 1,
    height: 30,
    difficulty: DifficultyLevel.sredni,
    lightRequirement: LightRequirement.cien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Kaktus',
    emoji: '🌵',
    description: 'Bardzo wytrzymały',
    wateringDays: 21,
    age: 5,
    height: 15,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.sukulentowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Storczyk',
    emoji: '🌺',
    description: 'Piękne kwiaty',
    wateringDays: 10,
    age: 2,
    height: 40,
    difficulty: DifficultyLevel.trudny,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.kwitnaca,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Filodendron',
    emoji: '🍃',
    description: 'Duże zielone liście',
    wateringDays: 7,
    age: 3,
    height: 60,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: true,
  ),
  Plant(
    name: 'Sansewieria',
    emoji: '🌿',
    description: 'Bardzo odporna',
    wateringDays: 14,
    age: 4,
    height: 50,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: true,
  ),
  Plant(
    name: 'Pothos',
    emoji: '🌱',
    description: 'Oczyszcza powietrze',
    wateringDays: 7,
    age: 2,
    height: 35,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.wiszaca,
    toxicToAnimals: true,
  ),
  // Nowe rośliny (12 dodatkowych)
  Plant(
    name: 'Palma Areka',
    emoji: '🌴',
    description: 'Tropikalna elegancja',
    wateringDays: 7,
    age: 3,
    height: 80,
    difficulty: DifficultyLevel.sredni,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Begonia',
    emoji: '🌸',
    description: 'Kolorowe kwiaty',
    wateringDays: 5,
    age: 1,
    height: 25,
    difficulty: DifficultyLevel.sredni,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.kwitnaca,
    toxicToAnimals: true,
  ),
  Plant(
    name: 'Koniczyna szczęścia',
    emoji: '🍀',
    description: 'Przynosi szczęście',
    wateringDays: 7,
    age: 1,
    height: 10,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Sukulenty mix',
    emoji: '🌵',
    description: 'Różnorodność form',
    wateringDays: 14,
    age: 2,
    height: 12,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.sukulentowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Hibiskus',
    emoji: '🌺',
    description: 'Egzotyczne kwiaty',
    wateringDays: 3,
    age: 2,
    height: 70,
    difficulty: DifficultyLevel.sredni,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.kwitnaca,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Zamiokulkas',
    emoji: '🪴',
    description: 'Niezniszczalny',
    wateringDays: 14,
    age: 3,
    height: 55,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.cien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: true,
  ),
  Plant(
    name: 'Skrzydłokwiat',
    emoji: '🌿',
    description: 'Białe kwiaty',
    wateringDays: 7,
    age: 2,
    height: 40,
    difficulty: DifficultyLevel.sredni,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.kwitnaca,
    toxicToAnimals: true,
  ),
  Plant(
    name: 'Bazylka',
    emoji: '🌱',
    description: 'Aromatyczne zioło',
    wateringDays: 2,
    age: 1,
    height: 20,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Tulipan',
    emoji: '🌷',
    description: 'Wiosenne kwiaty',
    wateringDays: 5,
    age: 1,
    height: 35,
    difficulty: DifficultyLevel.sredni,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.kwitnaca,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Róża miniaturowa',
    emoji: '🌹',
    description: 'Małe piękne róże',
    wateringDays: 3,
    age: 2,
    height: 30,
    difficulty: DifficultyLevel.trudny,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.kwitnaca,
    toxicToAnimals: false,
  ),
  Plant(
    name: 'Dracena',
    emoji: '🍃',
    description: 'Kolorowe liście',
    wateringDays: 10,
    age: 3,
    height: 65,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.polcien,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: true,
  ),
  Plant(
    name: 'Trawa ozdobna',
    emoji: '🌾',
    description: 'Subtelna elegancja',
    wateringDays: 7,
    age: 1,
    height: 40,
    difficulty: DifficultyLevel.latwy,
    lightRequirement: LightRequirement.pelneSlonce,
    plantType: PlantType.doniczkowa,
    toxicToAnimals: false,
  ),
];

class PlantSelectionScreen extends StatefulWidget {
  final bool isAddingPlants;
  
  const PlantSelectionScreen({
    Key? key,
    this.isAddingPlants = false,
  }) : super(key: key);

  @override
  State<PlantSelectionScreen> createState() => _PlantSelectionScreenState();
}

class _PlantSelectionScreenState extends State<PlantSelectionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedPlants = {};
  final Map<int, Plant> _customizedPlantDetails = {}; // Store customized plant details
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
  
  void _selectPlantAndNavigateToDetails(int index) async {
    final plant = availablePlants[index];
    
    // Navigate to details screen
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PlantDetailsScreen(
          selectedPlant: plant,
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
    
    // If plant details were saved, add to selected plants
    if (result != null && result is Plant) {
      setState(() {
        if (_selectedPlants.contains(index)) {
          _selectedPlants.remove(index);
        }
        _selectedPlants.add(index);
        // Update the plant with customized details
        _customizedPlantDetails[index] = result;
      });
    }
  }
  
  void _openPlantScanner() async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const PlantScanScreen(),
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
    
    // If a plant name was returned, find and select it
    if (result != null && result is String) {
      final plantIndex = availablePlants.indexWhere(
        (plant) => plant.name.toLowerCase() == result.toLowerCase()
      );
      
      if (plantIndex != -1 && mounted) {
        setState(() {
          _selectedPlants.add(plantIndex);
        });
        
        // Scroll to the plant if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$result został zaznaczony! 🌿'),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  void _navigateToHome() async {
    // Get selected plants with their details (or defaults if not customized)
    final selectedPlantsList = _selectedPlants.map((i) {
      return _customizedPlantDetails[i] ?? availablePlants[i];
    }).toList();
    
    // If this is during onboarding, mark it as complete
    if (!widget.isAddingPlants) {
      await PlantStorageService.setOnboardingComplete(true);
      
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
    } else {
      // If adding plants from dashboard, just return the list
      Navigator.of(context).pop(selectedPlantsList);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openPlantScanner,
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Skanuj'),
        elevation: 4,
      ),
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
                        child: _buildPlantCard(plant, isSelected, () => _selectPlantAndNavigateToDetails(originalIndex)),
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
