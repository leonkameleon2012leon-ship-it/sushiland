import '../models/sushi.dart';
import '../utils/enums.dart';

class SushiRecipes {
  static final SushiRecipe maki = SushiRecipe(
    type: SushiType.maki,
    name: 'Maki Roll',
    description: 'Basic sushi roll with rice and nori',
    requiredIngredients: {
      IngredientType.rice: 2,
      IngredientType.nori: 1,
      IngredientType.salmon: 1,
    },
    preparationTime: 3.0,
    sellPrice: 50,
    difficultyLevel: 1,
  );

  static final SushiRecipe nigiri = SushiRecipe(
    type: SushiType.nigiri,
    name: 'Nigiri',
    description: 'Rice topped with fresh fish',
    requiredIngredients: {
      IngredientType.rice: 2,
      IngredientType.salmon: 2,
    },
    preparationTime: 4.0,
    sellPrice: 70,
    difficultyLevel: 2,
  );

  static final SushiRecipe californiaRoll = SushiRecipe(
    type: SushiType.californiaRoll,
    name: 'California Roll',
    description: 'Roll with avocado and cucumber',
    requiredIngredients: {
      IngredientType.rice: 2,
      IngredientType.nori: 1,
      IngredientType.avocado: 1,
      IngredientType.cucumber: 1,
    },
    preparationTime: 5.0,
    sellPrice: 90,
    difficultyLevel: 2,
  );

  static Map<SushiType, SushiRecipe> getAllRecipes() {
    return {
      SushiType.maki: maki,
      SushiType.nigiri: nigiri,
      SushiType.californiaRoll: californiaRoll,
    };
  }
}
