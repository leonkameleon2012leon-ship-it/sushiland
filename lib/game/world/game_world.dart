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
    await _createEnvironment();
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

  Future<void> _createEnvironment() async {
    // Add entrance door
    final door = _DoorComponent(position: Vector2(400, 50));
    await add(door);
  }
}

/// Door component for entrance
class _DoorComponent extends PositionComponent {
  _DoorComponent({required Vector2 position})
      : super(
          position: position,
          size: Vector2(80, 40),
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw door frame
    final doorPaint = Paint()..color = const Color(0xFF8B4513);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.x / 2, size.y / 2),
          width: size.x,
          height: size.y,
        ),
        Radius.circular(5),
      ),
      doorPaint,
    );

    // Draw door emoji
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🚪',
        style: const TextStyle(fontSize: 28),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ),
    );
  }
}

