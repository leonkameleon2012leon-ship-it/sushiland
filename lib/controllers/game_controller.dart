import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';
import '../models/player.dart';
import '../models/customer.dart';
import '../models/restaurant.dart';
import '../models/sushi.dart';
import '../models/ingredient.dart';
import '../models/work_station.dart';
import '../models/table.dart';
import 'resource_controller.dart';
import 'customer_controller.dart';
import '../utils/enums.dart';
import '../data/recipes.dart';

class GameController extends ChangeNotifier {
  late Player player;
  late Restaurant restaurant;
  late ResourceController resourceController;
  late CustomerController customerController;

  GameState gameState = GameState.menu;
  bool isPaused = false;
  double gameTime = 0;

  double customerSpawnTimer = 0;
  double customerSpawnInterval = 15.0;

  int customersServedThisSession = 0;
  int moneyEarnedThisSession = 0;

  GameController() {
    _initializeGame();
  }

  void _initializeGame() {
    player = Player(position: Vector2(200, 200));
    restaurant = Restaurant();
    resourceController = ResourceController();
    customerController = CustomerController(restaurant: restaurant);

    _setupInitialStations();
  }

  void _setupInitialStations() {
    restaurant.addWorkStation(WorkStation(
      id: 'prep_station_1',
      type: StationType.preparation,
      position: Vector2(100, 100),
    ));

    restaurant.addWorkStation(WorkStation(
      id: 'storage_1',
      type: StationType.storage,
      position: Vector2(300, 100),
    ));

    restaurant.addWorkStation(WorkStation(
      id: 'counter_1',
      type: StationType.counter,
      position: Vector2(200, 300),
    ));

    restaurant.addTable(RestaurantTable(
      id: 0,
      position: Vector2(150, 250),
    ));
    restaurant.addTable(RestaurantTable(
      id: 1,
      position: Vector2(250, 250),
    ));
  }

  void update(double dt) {
    if (isPaused || gameState != GameState.playing) return;

    gameTime += dt;
    customerController.update(dt);
    _updateCustomerSpawning(dt);
    _checkOrderTimeouts();

    notifyListeners();
  }

  void _updateCustomerSpawning(double dt) {
    customerSpawnTimer += dt;

    if (customerSpawnTimer >= customerSpawnInterval) {
      customerSpawnTimer = 0;

      if (customerController.customers.length < restaurant.maxCustomers) {
        customerController.spawnCustomer();
        notifyListeners();
      }
    }
  }

  WorkStation? _findNearbyStation() {
    const double interactionDistance = 80.0;

    for (var station in restaurant.workStations) {
      double distance = (player.position - station.position).length;
      if (distance < interactionDistance) {
        return station;
      }
    }
    return null;
  }

  void interact() {
    WorkStation? station = _findNearbyStation();

    if (station == null) return;

    switch (station.type) {
      case StationType.storage:
        _collectIngredients();
        break;
      case StationType.preparation:
        _prepareSushi(station);
        break;
      case StationType.counter:
        _serveCustomer();
        break;
      default:
        break;
    }

    notifyListeners();
  }

  void _collectIngredients() {
    List<IngredientType> types = [
      IngredientType.rice,
      IngredientType.salmon,
      IngredientType.nori,
      IngredientType.avocado,
    ];

    for (var type in types) {
      if (player.inventory.length < player.maxCapacity) {
        player.addIngredient(Ingredient(type: type));
      }
    }
  }

  void _prepareSushi(WorkStation station) {
    SushiRecipe recipe = SushiRecipes.maki;

    bool hasIngredients = recipe.requiredIngredients.entries.every((entry) {
      return player.hasIngredient(entry.key, entry.value);
    });

    if (!hasIngredients) {
      return;
    }

    player.state = PlayerState.preparing;

    Future.delayed(Duration(seconds: recipe.preparationTime.toInt()), () {
      player.removeIngredients(recipe.requiredIngredients);

      Sushi sushi = Sushi(
        type: recipe.type,
        quality: SushiQuality.normal,
        value: recipe.sellPrice,
      );

      player.heldSushi = sushi;
      player.state = PlayerState.idle;

      notifyListeners();
    });
  }

  void _serveCustomer() {
    if (player.heldSushi == null) return;

    Customer? customer = customerController.findCustomerWaitingFor(player.heldSushi!.type);

    if (customer != null) {
      customer.serve();

      int reward = customer.calculateReward();
      restaurant.addMoney(reward);
      restaurant.addReputation(1);

      customersServedThisSession++;
      moneyEarnedThisSession += reward;
      restaurant.totalCustomersServed++;

      player.heldSushi = null;
      player.gainExperience(10);

      Future.delayed(Duration(seconds: 5), () {
        customer.finishEating();
        customerController.removeCustomer(customer);
        notifyListeners();
      });
    }
  }

  void _checkOrderTimeouts() {
    customerController.customers
        .where((c) => c.currentPatience <= 0)
        .toList()
        .forEach((customer) {
      restaurant.reputation = (restaurant.reputation - 5).clamp(0, double.infinity).toInt();
      customerController.removeCustomer(customer);
    });
  }

  void movePlayer(Vector2 direction) {
    player.position += direction * player.speed * 0.016;
    player.state = direction.length > 0 ? PlayerState.walking : PlayerState.idle;
    notifyListeners();
  }

  void startGame() {
    gameState = GameState.playing;
    notifyListeners();
  }

  void pauseGame() {
    isPaused = true;
    notifyListeners();
  }

  void resumeGame() {
    isPaused = false;
    notifyListeners();
  }

  void resetGame() {
    _initializeGame();
    gameState = GameState.menu;
    customersServedThisSession = 0;
    moneyEarnedThisSession = 0;
    notifyListeners();
  }
}
