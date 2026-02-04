import 'dart:io';
import 'dart:math';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../config/api_keys.dart';

class PlantIdentification {
  final String plantName;
  final String scientificName;
  final double confidence;
  final String description;

  PlantIdentification({
    required this.plantName,
    required this.scientificName,
    required this.confidence,
    required this.description,
  });
}

class PlantRecognitionService {
  // DEMO MODE: Returns random plant from list after 2 seconds delay
  static Future<PlantIdentification> identifyPlant(File image) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Demo plants list
    final demoPlants = [
      PlantIdentification(
        plantName: 'Monstera',
        scientificName: 'Monstera deliciosa',
        confidence: 0.92,
        description: 'Popularna roślina doniczkowa o dużych dziurawych liściach. Łatwa w pielęgnacji, preferuje jasne, rozproszone światło.',
      ),
      PlantIdentification(
        plantName: 'Kaktus',
        scientificName: 'Cactaceae',
        confidence: 0.88,
        description: 'Sukulent idealny dla zapominalskich. Wymaga minimalnej ilości wody i pełnego słońca.',
      ),
      PlantIdentification(
        plantName: 'Aloes',
        scientificName: 'Aloe vera',
        confidence: 0.95,
        description: 'Roślina lecznicza o wielu zastosowaniach. Lubi słońce i rzadkie podlewanie.',
      ),
    ];

    final random = Random();
    return demoPlants[random.nextInt(demoPlants.length)];

    /* REAL API IMPLEMENTATION - Uncomment when you have API key
    
    // Convert image to base64
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    
    // Plant.id API call
    final response = await http.post(
      Uri.parse('https://api.plant.id/v2/identify'),
      headers: {
        'Content-Type': 'application/json',
        'Api-Key': ApiKeys.plantId,
      },
      body: jsonEncode({
        'images': [base64Image],
        'modifiers': ['similar_images'],
        'plant_details': ['common_names', 'taxonomy', 'description'],
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final suggestions = data['suggestions'] as List;
      
      if (suggestions.isNotEmpty) {
        final topResult = suggestions[0];
        return PlantIdentification(
          plantName: topResult['plant_name'] ?? 'Nieznana roślina',
          scientificName: topResult['plant_details']?['scientific_name'] ?? '',
          confidence: (topResult['probability'] ?? 0.0).toDouble(),
          description: topResult['plant_details']?['wiki_description']?['value'] ?? 'Brak opisu',
        );
      }
    }
    
    throw Exception('Nie udało się rozpoznać rośliny');
    */
  }
}
