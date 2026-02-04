import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/onboarding/plant_selection_screen.dart';

class PlantData {
  final String name;
  final String emoji;
  final String description;
  final int wateringDays;
  final DateTime lastWatered;
  
  PlantData({
    required this.name,
    required this.emoji,
    required this.description,
    required this.wateringDays,
    required this.lastWatered,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'description': description,
      'wateringDays': wateringDays,
      'lastWatered': lastWatered.toIso8601String(),
    };
  }
  
  factory PlantData.fromJson(Map<String, dynamic> json) {
    return PlantData(
      name: json['name'],
      emoji: json['emoji'],
      description: json['description'],
      wateringDays: json['wateringDays'],
      lastWatered: DateTime.parse(json['lastWatered']),
    );
  }
  
  factory PlantData.fromPlant(Plant plant, DateTime lastWatered) {
    return PlantData(
      name: plant.name,
      emoji: plant.emoji,
      description: plant.description,
      wateringDays: plant.wateringDays,
      lastWatered: lastWatered,
    );
  }
  
  Plant toPlant() {
    return Plant(
      name: name,
      emoji: emoji,
      description: description,
      wateringDays: wateringDays,
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
