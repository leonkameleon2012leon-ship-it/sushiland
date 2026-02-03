import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../controllers/game_controller.dart';

/// Game world component that contains all game entities
class GameWorld extends World {
  final GameController gameController;

  GameWorld({required this.gameController});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _createFloorTiles();
  }

  Future<void> _createFloorTiles() async {
    // Create floor tiles for the restaurant
    const tileSize = 64.0;
    const worldWidth = 800.0;
    const worldHeight = 600.0;

    for (double x = 0; x < worldWidth; x += tileSize) {
      for (double y = 0; y < worldHeight; y += tileSize) {
        final isAlternate = ((x / tileSize).toInt() + (y / tileSize).toInt()) % 2 == 0;
        final color = isAlternate ? const Color(0xFFD2691E) : const Color(0xFFDEB887);

        final tile = RectangleComponent(
          position: Vector2(x, y),
          size: Vector2(tileSize, tileSize),
          paint: Paint()..color = color,
        );
        await add(tile);
      }
    }
  }
}
