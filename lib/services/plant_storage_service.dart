import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/onboarding/plant_selection_screen.dart';

class PlantData {
  final String name;
  final String emoji;
  final String description;
  final int wateringDays;
  final DateTime lastWatered;
  final int age; // w latach
  final int height; // w cm
  final DifficultyLevel difficulty;
  final LightRequirement lightRequirement;
  final PlantType plantType;
  final bool toxicToAnimals;
  final String? notes;
  final List<DateTime> wateringHistory; // Historia podlewania
  
  PlantData({
    required this.name,
    required this.emoji,
    required this.description,
    required this.wateringDays,
    required this.lastWatered,
    this.age = 1,
    this.height = 30,
    this.difficulty = DifficultyLevel.latwy,
    this.lightRequirement = LightRequirement.polcien,
    this.plantType = PlantType.doniczkowa,
    this.toxicToAnimals = false,
    this.notes,
    List<DateTime>? wateringHistory,
  }) : wateringHistory = wateringHistory ?? [lastWatered];
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'description': description,
      'wateringDays': wateringDays,
      'lastWatered': lastWatered.toIso8601String(),
      'age': age,
      'height': height,
      'difficulty': difficulty.name,
      'lightRequirement': lightRequirement.name,
      'plantType': plantType.name,
      'toxicToAnimals': toxicToAnimals,
      'notes': notes,
      'wateringHistory': wateringHistory.map((date) => date.toIso8601String()).toList(),
    };
  }
  
  factory PlantData.fromJson(Map<String, dynamic> json) {
    // Migracja starych danych - użyj wartości domyślnych jeśli brak nowych pól
    return PlantData(
      name: json['name'],
      emoji: json['emoji'],
      description: json['description'],
      wateringDays: json['wateringDays'],
      lastWatered: DateTime.parse(json['lastWatered']),
      age: json['age'] ?? 1,
      height: json['height'] ?? 30,
      difficulty: json['difficulty'] != null 
          ? DifficultyLevel.values.firstWhere(
              (e) => e.name == json['difficulty'],
              orElse: () => DifficultyLevel.latwy,
            )
          : DifficultyLevel.latwy,
      lightRequirement: json['lightRequirement'] != null
          ? LightRequirement.values.firstWhere(
              (e) => e.name == json['lightRequirement'],
              orElse: () => LightRequirement.polcien,
            )
          : LightRequirement.polcien,
      plantType: json['plantType'] != null
          ? PlantType.values.firstWhere(
              (e) => e.name == json['plantType'],
              orElse: () => PlantType.doniczkowa,
            )
          : PlantType.doniczkowa,
      toxicToAnimals: json['toxicToAnimals'] ?? false,
      notes: json['notes'],
      wateringHistory: json['wateringHistory'] != null
          ? (json['wateringHistory'] as List)
              .map((dateStr) => DateTime.parse(dateStr))
              .toList()
          : [DateTime.parse(json['lastWatered'])],
    );
  }
  
  factory PlantData.fromPlant(Plant plant, DateTime lastWatered) {
    return PlantData(
      name: plant.name,
      emoji: plant.emoji,
      description: plant.description,
      wateringDays: plant.wateringDays,
      lastWatered: lastWatered,
      age: plant.age,
      height: plant.height,
      difficulty: plant.difficulty,
      lightRequirement: plant.lightRequirement,
      plantType: plant.plantType,
      toxicToAnimals: plant.toxicToAnimals,
      notes: plant.notes,
      wateringHistory: [lastWatered],
    );
  }
  
  Plant toPlant() {
    return Plant(
      name: name,
      emoji: emoji,
      description: description,
      wateringDays: wateringDays,
      age: age,
      height: height,
      difficulty: difficulty,
      lightRequirement: lightRequirement,
      plantType: plantType,
      toxicToAnimals: toxicToAnimals,
      notes: notes,
    );
  }
  
  PlantData copyWith({
    String? name,
    String? emoji,
    String? description,
    int? wateringDays,
    DateTime? lastWatered,
    int? age,
    int? height,
    DifficultyLevel? difficulty,
    LightRequirement? lightRequirement,
    PlantType? plantType,
    bool? toxicToAnimals,
    String? notes,
    List<DateTime>? wateringHistory,
  }) {
    return PlantData(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      wateringDays: wateringDays ?? this.wateringDays,
      lastWatered: lastWatered ?? this.lastWatered,
      age: age ?? this.age,
      height: height ?? this.height,
      difficulty: difficulty ?? this.difficulty,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      plantType: plantType ?? this.plantType,
      toxicToAnimals: toxicToAnimals ?? this.toxicToAnimals,
      notes: notes ?? this.notes,
      wateringHistory: wateringHistory ?? this.wateringHistory,
    );
  }
}

class PlantStorageService {
  static const String _plantsKey = 'user_plants';
  static const String _onboardingCompleteKey = 'onboarding_complete';
  
  static Future<void> savePlants(List<PlantData> plants) async {
    final prefs = await SharedPreferences.getInstance();
    final plantsJson = plants.map((p) => p.toJson()).toList();
    await prefs.setString(_plantsKey, jsonEncode(plantsJson));
  }
  
  static Future<List<PlantData>> loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final plantsString = prefs.getString(_plantsKey);
    
    if (plantsString == null) {
      return [];
    }
    
    try {
      final List<dynamic> plantsJson = jsonDecode(plantsString);
      return plantsJson.map((json) => PlantData.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
  
  static Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, complete);
  }
  
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
  
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
