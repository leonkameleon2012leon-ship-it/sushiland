import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_theme.dart';
import '../../models/plant.dart';

class PlantDetailsScreen extends StatefulWidget {
  final Plant selectedPlant;
  final Plant? existingPlant; // For editing existing plants
  
  const PlantDetailsScreen({
    Key? key,
    required this.selectedPlant,
    this.existingPlant,
  }) : super(key: key);

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _notesController;
  
  late DifficultyLevel _difficulty;
  late LightRequirement _lightRequirement;
  late PlantType _plantType;
  late bool _toxicToAnimals;
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    
    // Use existing plant data if editing, otherwise use defaults from selected plant
    final plant = widget.existingPlant ?? widget.selectedPlant;
    
    _ageController = TextEditingController(text: plant.age.toString());
    _heightController = TextEditingController(text: plant.height.toString());
    _notesController = TextEditingController(text: plant.notes ?? '');
    
    _difficulty = plant.difficulty;
    _lightRequirement = plant.lightRequirement;
    _plantType = plant.plantType;
    _toxicToAnimals = plant.toxicToAnimals;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _notesController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
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
  
  void _savePlant() {
    if (_formKey.currentState!.validate()) {
      final updatedPlant = widget.selectedPlant.copyWith(
        age: int.parse(_ageController.text),
        height: int.parse(_heightController.text),
        difficulty: _difficulty,
        lightRequirement: _lightRequirement,
        plantType: _plantType,
        toxicToAnimals: _toxicToAnimals,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      Navigator.of(context).pop(updatedPlant);
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
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Szczegóły rośliny',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 24,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Plant emoji and name
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.lightGreen.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                widget.selectedPlant.emoji,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.selectedPlant.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  Text(
                                    widget.selectedPlant.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textDark.withOpacity(0.7),
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
              
              // Form
              Expanded(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  )),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Age input
                          _buildSectionTitle('Wiek rośliny', Icons.calendar_today),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              hintText: 'Wprowadź wiek w latach',
                              suffixText: 'lat',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj wiek rośliny';
                              }
                              final age = int.tryParse(value);
                              if (age == null || age < 0 || age > 100) {
                                return 'Wiek musi być między 0 a 100 lat';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Height input
                          _buildSectionTitle('Wysokość', Icons.height),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _heightController,
                            decoration: InputDecoration(
                              hintText: 'Wprowadź wysokość',
                              suffixText: 'cm',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj wysokość rośliny';
                              }
                              final height = int.tryParse(value);
                              if (height == null || height < 1 || height > 500) {
                                return 'Wysokość musi być między 1 a 500 cm';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Difficulty level
                          _buildSectionTitle('Poziom trudności pielęgnacji', Icons.psychology),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonFormField<DifficultyLevel>(
                              value: _difficulty,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: DifficultyLevel.values.map((level) {
                                return DropdownMenuItem(
                                  value: level,
                                  child: Text(_getDifficultyLabel(level)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _difficulty = value;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Light requirement
                          _buildSectionTitle('Wymagania świetlne', Icons.wb_sunny),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonFormField<LightRequirement>(
                              value: _lightRequirement,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: LightRequirement.values.map((req) {
                                return DropdownMenuItem(
                                  value: req,
                                  child: Text(_getLightRequirementLabel(req)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _lightRequirement = value;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Plant type
                          _buildSectionTitle('Typ rośliny', Icons.category),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonFormField<PlantType>(
                              value: _plantType,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: PlantType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(_getPlantTypeLabel(type)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _plantType = value;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Toxic to animals
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pets,
                                  color: _toxicToAnimals ? Colors.red : AppTheme.primaryGreen,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Toksyczna dla zwierząt',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _toxicToAnimals,
                                  onChanged: (value) {
                                    setState(() {
                                      _toxicToAnimals = value;
                                    });
                                  },
                                  activeColor: AppTheme.primaryGreen,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Notes
                          _buildSectionTitle('Notatki (opcjonalne)', Icons.notes),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              hintText: 'Dodaj własne notatki o roślinie...',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 4,
                            maxLength: 500,
                          ),
                          
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
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
          onPressed: _savePlant,
          backgroundColor: AppTheme.primaryGreen,
          icon: const Icon(Icons.check),
          label: const Text(
            'Zapisz',
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
  
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
