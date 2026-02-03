import '../utils/enums.dart';

class Ingredient {
  final IngredientType type;
  final String name;
  int quantity;

  Ingredient({required this.type, String? name, this.quantity = 1})
      : name = name ?? _getDefaultName(type);

  static String _getDefaultName(IngredientType type) {
    switch (type) {
      case IngredientType.rice: return 'Rice';
      case IngredientType.salmon: return 'Salmon';
      case IngredientType.tuna: return 'Tuna';
      case IngredientType.shrimp: return 'Shrimp';
      case IngredientType.nori: return 'Nori';
      case IngredientType.cucumber: return 'Cucumber';
      case IngredientType.avocado: return 'Avocado';
      case IngredientType.wasabi: return 'Wasabi';
      case IngredientType.ginger: return 'Ginger';
      case IngredientType.soySauce: return 'Soy Sauce';
    }
  }
}
