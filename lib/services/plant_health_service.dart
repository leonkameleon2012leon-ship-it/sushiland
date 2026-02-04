import 'dart:io';
import 'dart:math';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../config/api_keys.dart';

enum HealthIssue {
  healthy,
  underwatered,
  overwatered,
  pests,
  disease,
}

class HealthDiagnosis {
  final HealthIssue issue;
  final String title;
  final String description;
  final List<String> recommendations;
  final double confidence;

  HealthDiagnosis({
    required this.issue,
    required this.title,
    required this.description,
    required this.recommendations,
    required this.confidence,
  });
}

class PlantHealthService {
  // DEMO MODE: Returns random diagnosis with recommendations
  static Future<HealthDiagnosis> diagnose(File image) async {
    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final diagnoses = _getDemoDiagnoses();
    
    return diagnoses[random.nextInt(diagnoses.length)];

    /* REAL API IMPLEMENTATION - Uncomment when you have API key
    
    // Convert image to base64
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    
    // Plant.id Health Assessment API call
    final response = await http.post(
      Uri.parse('https://api.plant.id/v2/health_assessment'),
      headers: {
        'Content-Type': 'application/json',
        'Api-Key': ApiKeys.plantId,
      },
      body: jsonEncode({
        'images': [base64Image],
        'modifiers': ['similar_images'],
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final healthAssessment = data['health_assessment'];
      
      if (healthAssessment != null) {
        final isHealthy = healthAssessment['is_healthy'] as bool;
        
        if (isHealthy) {
          return _getHealthyDiagnosis();
        } else {
          final diseases = healthAssessment['diseases'] as List;
          if (diseases.isNotEmpty) {
            final topDisease = diseases[0];
            return HealthDiagnosis(
              issue: _mapToHealthIssue(topDisease['name']),
              title: topDisease['name'] ?? 'Problem zdrowotny',
              description: topDisease['description'] ?? 'Wykryto problem',
              recommendations: (topDisease['treatment'] as List?)
                  ?.map((t) => t.toString())
                  .toList() ?? [],
              confidence: (topDisease['probability'] ?? 0.0).toDouble(),
            );
          }
        }
      }
    }
    
    return _getHealthyDiagnosis();
    */
  }

  static List<HealthDiagnosis> _getDemoDiagnoses() {
    return [
      HealthDiagnosis(
        issue: HealthIssue.healthy,
        title: 'Roślina jest zdrowa! 🌿',
        description: 'Twoja roślina wygląda świetnie! Liście są zielone i jędrne, nie ma oznak chorób ani szkodników.',
        recommendations: [
          'Kontynuuj obecną pielęgnację',
          'Regularnie sprawdzaj stan liści',
          'Utrzymuj stały harmonogram podlewania',
        ],
        confidence: 0.95,
      ),
      HealthDiagnosis(
        issue: HealthIssue.underwatered,
        title: 'Niedobór wody 💧',
        description: 'Roślina wykazuje oznaki zbyt rzadkiego podlewania. Liście mogą być zwiędnięte lub suche.',
        recommendations: [
          'Podlej roślinę obficie, ale nie zalewaj',
          'Sprawdź wilgotność gleby przed podlewaniem',
          'Rozważ częstsze podlewanie w ciepłe dni',
          'Upewnij się, że doniczka ma odpowiedni drenaż',
        ],
        confidence: 0.87,
      ),
      HealthDiagnosis(
        issue: HealthIssue.overwatered,
        title: 'Nadmiar wody 🌊',
        description: 'Roślina otrzymuje zbyt dużo wody. Może to prowadzić do gnicia korzeni i żółknięcia liści.',
        recommendations: [
          'Ogranicz podlewanie - gleba powinna przeschnąć między podlewaniami',
          'Sprawdź czy doniczka ma odpowiednie otwory drenażowe',
          'Przesadź roślinę do świeżej ziemi jeśli korzenie gniją',
          'Zwiększ cyrkulację powietrza wokół rośliny',
        ],
        confidence: 0.82,
      ),
      HealthDiagnosis(
        issue: HealthIssue.pests,
        title: 'Szkodniki 🐛',
        description: 'Na roślinie zauważono obecność szkodników. Mogą to być mszyce, przędziorki lub inne owady.',
        recommendations: [
          'Spryskaj liście roztworem wody z mydłem',
          'Odizoluj roślinę od innych aby zapobiec rozprzestrzenieniu',
          'Regularnie sprawdzaj spód liści',
          'Rozważ użycie naturalnych środków owadobójczych',
          'Zwiększ wilgotność powietrza - szkodniki nie lubią wilgoci',
        ],
        confidence: 0.78,
      ),
      HealthDiagnosis(
        issue: HealthIssue.disease,
        title: 'Choroba rośliny 🦠',
        description: 'Wykryto możliwą chorobę grzybiczą lub bakteryjną. Objawy mogą obejmować plamy na liściach lub więdnięcie.',
        recommendations: [
          'Usuń wszystkie chore liście',
          'Ogranicz podlewanie liści - podlewaj tylko glebę',
          'Zapewnij lepszą cyrkulację powietrza',
          'Rozważ użycie fungicydu naturalnego',
          'Przesadź do świeżej, sterylnej ziemi',
        ],
        confidence: 0.75,
      ),
    ];
  }

  static HealthDiagnosis _getHealthyDiagnosis() {
    return HealthDiagnosis(
      issue: HealthIssue.healthy,
      title: 'Roślina jest zdrowa! 🌿',
      description: 'Twoja roślina wygląda świetnie! Liście są zielone i jędrne, nie ma oznak chorób ani szkodników.',
      recommendations: [
        'Kontynuuj obecną pielęgnację',
        'Regularnie sprawdzaj stan liści',
        'Utrzymuj stały harmonogram podlewania',
      ],
      confidence: 0.95,
    );
  }

  static HealthIssue _mapToHealthIssue(String diseaseName) {
    final lower = diseaseName.toLowerCase();
    if (lower.contains('water') && lower.contains('under')) {
      return HealthIssue.underwatered;
    } else if (lower.contains('water') && lower.contains('over')) {
      return HealthIssue.overwatered;
    } else if (lower.contains('pest') || lower.contains('insect')) {
      return HealthIssue.pests;
    } else {
      return HealthIssue.disease;
    }
  }

  static String getHealthEmoji(HealthIssue issue) {
    switch (issue) {
      case HealthIssue.healthy:
        return '✅';
      case HealthIssue.underwatered:
        return '💧';
      case HealthIssue.overwatered:
        return '🌊';
      case HealthIssue.pests:
        return '🐛';
      case HealthIssue.disease:
        return '🦠';
    }
  }

  static String getHealthStatusText(HealthIssue issue) {
    switch (issue) {
      case HealthIssue.healthy:
        return 'Zdrowa';
      case HealthIssue.underwatered:
        return 'Za mało wody';
      case HealthIssue.overwatered:
        return 'Za dużo wody';
      case HealthIssue.pests:
        return 'Szkodniki';
      case HealthIssue.disease:
        return 'Choroba';
    }
  }
}
