import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

/// Health diagnosis result
class HealthDiagnosis {
  final HealthStatus status;
  final String diagnosis;
  final List<String> symptoms;
  final List<String> recommendations;
  final double confidence;
  
  HealthDiagnosis({
    required this.status,
    required this.diagnosis,
    required this.symptoms,
    required this.recommendations,
    required this.confidence,
  });
  
  String get statusEmoji {
    switch (status) {
      case HealthStatus.healthy:
        return '✅';
      case HealthStatus.warning:
        return '⚠️';
      case HealthStatus.critical:
        return '🚨';
    }
  }
  
  String get statusText {
    switch (status) {
      case HealthStatus.healthy:
        return 'Zdrowa';
      case HealthStatus.warning:
        return 'Wymaga uwagi';
      case HealthStatus.critical:
        return 'Stan krytyczny';
    }
  }
}

/// Health status levels
enum HealthStatus {
  healthy,
  warning,
  critical,
}

/// Issue types that can be detected
enum PlantIssue {
  overwatering,    // Zalanie
  underwatering,   // Przesuszenie
  pests,           // Szkodniki
  disease,         // Choroba
  nutritional,     // Niedobory pokarmowe
  sunburn,         // Poparzenie słońcem
}

/// Service for diagnosing plant health from images
class PlantHealthService {
  /// Analyze plant health from leaf image
  /// 
  /// This is a simplified analysis based on color and brightness
  /// In production, this would use a trained ML model
  static Future<HealthDiagnosis> analyzePlantHealth(File imageFile) async {
    try {
      // Read and decode image
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // Analyze image colors and brightness
      final analysis = _analyzeImageColors(image);
      
      // Determine health status based on analysis
      return _diagnoseFromAnalysis(analysis);
    } catch (e) {
      // If analysis fails, return a neutral diagnosis
      return _getDefaultDiagnosis();
    }
  }
  
  /// Analyze image colors to detect potential issues
  static Map<String, double> _analyzeImageColors(img.Image image) {
    int totalPixels = 0;
    int greenPixels = 0;
    int yellowPixels = 0;
    int brownPixels = 0;
    int blackPixels = 0;
    double totalBrightness = 0;
    
    // Sample pixels (not all for performance)
    final sampleRate = 10;
    
    for (int y = 0; y < image.height; y += sampleRate) {
      for (int x = 0; x < image.width; x += sampleRate) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        
        totalPixels++;
        totalBrightness += (r + g + b) / 3;
        
        // Detect green (healthy)
        if (g > r && g > b && g > 100) {
          greenPixels++;
        }
        // Detect yellow (overwatering or nutrient issues)
        else if (r > 180 && g > 180 && b < 100) {
          yellowPixels++;
        }
        // Detect brown (underwatering or dead tissue)
        else if (r > 100 && g > 60 && b < 80 && r > g) {
          brownPixels++;
        }
        // Detect black spots (disease or pests)
        else if (r < 50 && g < 50 && b < 50) {
          blackPixels++;
        }
      }
    }
    
    return {
      'green_ratio': greenPixels / totalPixels,
      'yellow_ratio': yellowPixels / totalPixels,
      'brown_ratio': brownPixels / totalPixels,
      'black_ratio': blackPixels / totalPixels,
      'avg_brightness': totalBrightness / totalPixels,
    };
  }
  
  /// Diagnose plant health from color analysis
  static HealthDiagnosis _diagnoseFromAnalysis(Map<String, double> analysis) {
    final greenRatio = analysis['green_ratio']!;
    final yellowRatio = analysis['yellow_ratio']!;
    final brownRatio = analysis['brown_ratio']!;
    final blackRatio = analysis['black_ratio']!;
    
    // Healthy plant: mostly green
    if (greenRatio > 0.5 && yellowRatio < 0.1 && brownRatio < 0.1) {
      return HealthDiagnosis(
        status: HealthStatus.healthy,
        diagnosis: 'Roślina wygląda zdrowo',
        symptoms: ['Zielone liście', 'Dobry kolor'],
        recommendations: [
          'Kontynuuj obecną pielęgnację',
          'Regularnie podlewaj',
          'Sprawdzaj liście co tydzień',
        ],
        confidence: 0.85,
      );
    }
    
    // Overwatering: yellow leaves
    if (yellowRatio > 0.2) {
      return HealthDiagnosis(
        status: HealthStatus.warning,
        diagnosis: 'Możliwe zalanie',
        symptoms: ['Żółte liście', 'Zwiędnięcie'],
        recommendations: [
          'Ogranicz podlewanie',
          'Sprawdź drenażw doniczce',
          'Poczekaj aż gleba wyschnie',
          'Usuń gnijące korzenie jeśli są widoczne',
        ],
        confidence: 0.70,
      );
    }
    
    // Underwatering: brown, dry leaves
    if (brownRatio > 0.2) {
      return HealthDiagnosis(
        status: HealthStatus.warning,
        diagnosis: 'Przesuszenie',
        symptoms: ['Brązowe końcówki liści', 'Suche liście'],
        recommendations: [
          'Podlej natychmiast',
          'Zwiększ wilgotność powietrza',
          'Sprawdź czy woda dociera do korzeni',
          'Rozważ częstsze podlewanie',
        ],
        confidence: 0.75,
      );
    }
    
    // Disease or pests: black spots
    if (blackRatio > 0.1) {
      return HealthDiagnosis(
        status: HealthStatus.critical,
        diagnosis: 'Możliwe szkodniki lub choroba',
        symptoms: ['Czarne plamy', 'Przebarwienia'],
        recommendations: [
          'Odizoluj roślinę od innych',
          'Sprawdź obecność szkodników',
          'Usuń chore liście',
          'Rozważ użycie środka ochrony roślin',
          'Skonsultuj się ze specjalistą',
        ],
        confidence: 0.65,
      );
    }
    
    // Mixed symptoms or unclear
    return HealthDiagnosis(
      status: HealthStatus.warning,
      diagnosis: 'Niepewny stan',
      symptoms: ['Mieszane objawy'],
      recommendations: [
        'Monitoruj roślinę przez kilka dni',
        'Sprawdź warunki świetlne',
        'Upewnij się, że podlewanie jest odpowiednie',
        'Zrób kolejne zdjęcie za tydzień',
      ],
      confidence: 0.50,
    );
  }
  
  /// Get default diagnosis when analysis fails
  static HealthDiagnosis _getDefaultDiagnosis() {
    return HealthDiagnosis(
      status: HealthStatus.healthy,
      diagnosis: 'Nie można przeanalizować zdjęcia',
      symptoms: ['Zrób wyraźne zdjęcie liści'],
      recommendations: [
        'Zrób zdjęcie w dobrym świetle',
        'Zbliż się do liści',
        'Upewnij się, że zdjęcie jest ostre',
        'Spróbuj ponownie',
      ],
      confidence: 0.0,
    );
  }
  
  /// Get demo diagnosis for testing
  static Future<HealthDiagnosis> getDemoDiagnosis() async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Return random diagnosis for demo
    final random = Random();
    final options = [
      HealthDiagnosis(
        status: HealthStatus.healthy,
        diagnosis: 'Roślina wygląda zdrowo',
        symptoms: ['Zielone liście', 'Dobry kolor', 'Brak widocznych problemów'],
        recommendations: [
          'Kontynuuj obecną pielęgnację',
          'Regularnie podlewaj zgodnie z harmonogramem',
          'Sprawdzaj liście co tydzień',
        ],
        confidence: 0.92,
      ),
      HealthDiagnosis(
        status: HealthStatus.warning,
        diagnosis: 'Przesuszenie',
        symptoms: ['Brązowe końcówki liści', 'Suche brzegi'],
        recommendations: [
          'Podlej natychmiast',
          'Zwiększ wilgotność powietrza',
          'Rozważ częstsze podlewanie',
        ],
        confidence: 0.78,
      ),
      HealthDiagnosis(
        status: HealthStatus.warning,
        diagnosis: 'Możliwe zalanie',
        symptoms: ['Żółte liście', 'Zwiędnięcie'],
        recommendations: [
          'Ogranicz podlewanie',
          'Sprawdź drenażw doniczce',
          'Poczekaj aż gleba wyschnie',
        ],
        confidence: 0.71,
      ),
    ];
    
    return options[random.nextInt(options.length)];
  }
}
