import 'ingredient.dart';
import '../utils/enums.dart';

class SushiRecipe {
  final SushiType type;
  final String name;
  final String description;
  final Map<IngredientType, int> requiredIngredients;
  final double preparationTime;
  final int sellPrice;
  final int difficultyLevel;

  SushiRecipe({
    required this.type,
    required this.name,
    required this.description,
    required this.requiredIngredients,
    required this.preparationTime,
    required this.sellPrice,
    this.difficultyLevel = 1,
  });
}

class Sushi {
  final SushiType type;
  SushiQuality quality;
  final int value;

  Sushi({required this.type, this.quality = SushiQuality.normal, required this.value});

  int get finalValue {
    switch (quality) {
      case SushiQuality.poor: return (value * 0.7).toInt();
      case SushiQuality.normal: return value;
      case SushiQuality.good: return (value * 1.3).toInt();
      case SushiQuality.excellent: return (value * 1.5).toInt();
    }
  }
}
