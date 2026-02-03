import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import 'components/player_component.dart';
import 'components/customer_component.dart';
import 'components/workstation_component.dart';
import 'components/table_component.dart';
import 'components/particle_effects.dart';
import 'world/game_world.dart';

/// Main Flame game class that manages the game world, camera, and components
class SushilandGame extends FlameGame with HasCollisionDetection {
  final GameController gameController;
  late PlayerComponent playerComponent;
  late GameWorld gameWorld;
  late CameraComponent cameraComponent;

  // World bounds
  static const double worldWidth = 800;
  static const double worldHeight = 600;

  SushilandGame({required this.gameController});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create game world
    gameWorld = GameWorld(gameController: gameController);
    await add(gameWorld);

    // Create player component
    playerComponent = PlayerComponent(
      player: gameController.player,
      gameController: gameController,
    );
    await gameWorld.add(playerComponent);

    // Setup camera to follow player
    _setupCamera();

    // Load existing game elements
    await _loadGameElements();
  }

  void _setupCamera() {
    cameraComponent = CameraComponent.withFixedResolution(
      world: gameWorld,
      width: worldWidth,
      height: worldHeight,
    );
    cameraComponent.viewfinder.anchor = Anchor.center;
    cameraComponent.viewfinder.zoom = 1.5;
    add(cameraComponent);
  }

  Future<void> _loadGameElements() async {
    // Add work stations
    for (var station in gameController.restaurant.workStations) {
      final stationComponent = WorkStationComponent(
        workStation: station,
        gameController: gameController,
      );
      await gameWorld.add(stationComponent);
    }

    // Add tables
    for (var table in gameController.restaurant.tables) {
      final tableComponent = TableComponent(
        table: table,
      );
      await gameWorld.add(tableComponent);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update camera to follow player
    _updateCamera();

    // Sync customer components with controller
    _syncCustomers();
  }

  void _updateCamera() {
    // Smooth camera following with lerp
    final targetPosition = playerComponent.position;
    final currentPosition = cameraComponent.viewfinder.position;
    final lerpFactor = 0.1;

    cameraComponent.viewfinder.position = Vector2(
      currentPosition.x + (targetPosition.x - currentPosition.x) * lerpFactor,
      currentPosition.y + (targetPosition.y - currentPosition.y) * lerpFactor,
    );

    // Constrain camera to world bounds
    final halfWidth = worldWidth / (2 * cameraComponent.viewfinder.zoom);
    final halfHeight = worldHeight / (2 * cameraComponent.viewfinder.zoom);

    cameraComponent.viewfinder.position.x = cameraComponent.viewfinder.position.x
        .clamp(halfWidth, worldWidth - halfWidth);
    cameraComponent.viewfinder.position.y = cameraComponent.viewfinder.position.y
        .clamp(halfHeight, worldHeight - halfHeight);
  }

  void _syncCustomers() {
    // Get existing customer components
    final existingCustomers = gameWorld.children.whereType<CustomerComponent>().toList();
    final existingCustomerIds = existingCustomers.map((c) => c.customer.id).toSet();

    // Add new customers
    for (var customer in gameController.customerController.customers) {
      if (!existingCustomerIds.contains(customer.id)) {
        final customerComponent = CustomerComponent(
          customer: customer,
          gameController: gameController,
        );
        gameWorld.add(customerComponent);
      }
    }

    // Remove customers that no longer exist
    final activeCustomerIds = gameController.customerController.customers
        .map((c) => c.id)
        .toSet();

    for (var component in existingCustomers) {
      if (!activeCustomerIds.contains(component.customer.id)) {
        component.removeFromParent();
      }
    }
  }

  /// Update player movement from joystick input
  void updatePlayerMovement(Vector2 direction) {
    playerComponent.setMovementDirection(direction);
  }

  /// Trigger player interaction
  void triggerInteraction() {
    playerComponent.interact();
  }

  /// Spawn particle effect at position
  void spawnParticleEffect(String effectType, Vector2 position, {int? value}) {
    switch (effectType) {
      case 'sparkle':
        gameWorld.add(SparkleEffect(position: position));
        break;
      case 'starburst':
        gameWorld.add(StarBurstEffect(position: position));
        break;
      case 'money':
        if (value != null) {
          gameWorld.add(MoneyFloatEffect(position: position, amount: value));
        }
        break;
      case 'heart':
        gameWorld.add(HeartEffect(position: position));
        break;
    }
  }
}

