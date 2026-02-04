import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Plant identification result
class PlantIdentification {
  final String name;
  final String scientificName;
  final String description;
  final double confidence;
  final List<String> commonNames;
  
  PlantIdentification({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.confidence,
    required this.commonNames,
  });
  
  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    final suggestions = json['suggestions'] as List;
    if (suggestions.isEmpty) {
      throw Exception('No plant identified');
    }
    
    final bestMatch = suggestions.first;
    final plantName = bestMatch['plant_name'] as String;
    final plantDetails = bestMatch['plant_details'];
    
    return PlantIdentification(
      name: plantName,
      scientificName: plantDetails['scientific_name'] ?? plantName,
      description: plantDetails['wiki_description']?['value'] ?? 'Brak opisu',
      confidence: (bestMatch['probability'] as num).toDouble(),
      commonNames: (plantDetails['common_names'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [plantName],
    );
  }
  
  /// Create demo identification for testing
  factory PlantIdentification.demo() {
    return PlantIdentification(
      name: 'Monstera deliciosa',
      scientificName: 'Monstera deliciosa',
      description: 'Popularna roślina doniczkowa o dużych, dziurawych liściach. Łatwa w pielęgnacji.',
      confidence: 0.95,
      commonNames: ['Monstera', 'Filodendron dziurawy', 'Monstera deliciosa'],
    );
  }
  
  String get confidencePercent => '${(confidence * 100).toInt()}%';
  
  String get polishName {
    // Try to find Polish name or return first common name
    for (final name in commonNames) {
      if (name.contains('Monstera')) return 'Monstera';
      if (name.contains('Aloes')) return 'Aloes';
      if (name.contains('Paproć')) return 'Paproć';
      if (name.contains('Kaktus')) return 'Kaktus';
      if (name.contains('Storczyk')) return 'Storczyk';
    }
    return commonNames.isNotEmpty ? commonNames.first : name;
  }
}

/// Service for plant recognition using image analysis
class PlantRecognitionService {
  /// Identify plant from image file
  /// 
  /// Uses Plant.id API for plant identification
  /// Returns PlantIdentification with plant details
  static Future<PlantIdentification> identifyPlant(File imageFile) async {
    // Use demo mode if API key not configured
    if (ApiConfig.useDemoMode || !ApiConfig.isPlantIdConfigured) {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      return PlantIdentification.demo();
    }
    
    try {
      // Read image as base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Prepare request
      final url = Uri.parse('${ApiConfig.plantIdBaseUrl}/identify');
      final headers = {
        'Content-Type': 'application/json',
        'Api-Key': ApiConfig.plantIdApiKey,
      };
      
      final body = jsonEncode({
        'images': [base64Image],
        'modifiers': ['similar_images'],
        'plant_details': [
          'common_names',
          'scientific_name',
          'wiki_description',
        ],
      });
      
      // Send request
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      ).timeout(
        const Duration(seconds: 30),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PlantIdentification.fromJson(data);
      } else {
        throw Exception('Failed to identify plant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error identifying plant: $e');
    }
  }
  
  /// Validate image before sending to API
  /// Returns true if image is valid, false otherwise
  static Future<bool> validateImage(File imageFile) async {
    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        return false;
      }
      
      // Check file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Get estimated credit cost for identification
  /// Plant.id API uses credits per request
  static int getEstimatedCreditCost() {
    return 1; // Standard identification costs 1 credit
  }
}
