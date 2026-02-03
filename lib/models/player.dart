import 'package:vector_math/vector_math_64.dart';
import 'ingredient.dart';
import 'sushi.dart';
import '../utils/enums.dart';

class Player {
  Vector2 position;
  double speed;
  PlayerState state;
  List<Ingredient> inventory;
  int maxCapacity;
  double preparationSpeed;
  int level;
  int experience;
  Sushi? heldSushi;

  Player({
    required this.position,
    this.speed = 100.0,
    this.maxCapacity = 5,
    this.preparationSpeed = 1.0,
    this.level = 1,
    this.experience = 0,
    this.state = PlayerState.idle,
  }) : inventory = [];

  bool addIngredient(Ingredient ingredient) {
    if (inventory.length < maxCapacity) {
      inventory.add(ingredient);
      return true;
    }
    return false;
  }

  bool hasIngredient(IngredientType type, int amount) {
    return inventory.where((i) => i.type == type).length >= amount;
  }

  void removeIngredients(Map<IngredientType, int> ingredients) {
    ingredients.forEach((type, amount) {
      for (int i = 0; i < amount; i++) {
        inventory.removeWhere((item) => item.type == type);
      }
    });
  }

  void gainExperience(int exp) {
    experience += exp;
    if (experience >= experienceToNextLevel) levelUp();
  }

  int get experienceToNextLevel => level * 100;

  void levelUp() {
    level++;
    experience = 0;
    maxCapacity++;
    speed += 5;
  }
}
