import 'package:flutter/foundation.dart';
import '../utils/enums.dart';

class ResourceController extends ChangeNotifier {
  Map<IngredientType, int> ingredients = {};
  int money = 0;

  ResourceController() {
    // Początkowe zasoby
    ingredients[IngredientType.rice] = 20;
    ingredients[IngredientType.salmon] = 10;
    ingredients[IngredientType.tuna] = 10;
    ingredients[IngredientType.nori] = 15;
    money = 100;
  }

  void addIngredient(IngredientType type, int amount) {
    ingredients[type] = (ingredients[type] ?? 0) + amount;
    notifyListeners();
  }

  bool useIngredient(IngredientType type, int amount) {
    int current = ingredients[type] ?? 0;
    if (current >= amount) {
      ingredients[type] = current - amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool hasIngredient(IngredientType type, int amount) {
    return (ingredients[type] ?? 0) >= amount;
  }

  void addMoney(int amount) {
    money += amount;
    notifyListeners();
  }

  bool spendMoney(int amount) {
    if (money >= amount) {
      money -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  int getIngredientCount(IngredientType type) {
    return ingredients[type] ?? 0;
  }
}
