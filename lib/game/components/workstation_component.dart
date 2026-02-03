import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../models/work_station.dart';
import '../../controllers/game_controller.dart';
import '../../utils/enums.dart';

/// Work station component with visual states and interactions
class WorkStationComponent extends PositionComponent with CollisionCallbacks {
  final dynamic workStation;
  final GameController gameController;
  bool isHighlighted = false;

  WorkStationComponent({
    required this.workStation,
    required this.gameController,
  }) : super(
          position: workStation.position,
          size: Vector2(60, 60),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw station base
    final paint = Paint()
      ..color = isHighlighted ? Colors.yellow.shade700 : Colors.grey.shade700;
    
    final rect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: size.x,
      height: size.y,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(8)),
      paint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(8)),
      borderPaint,
    );

    // Draw icon based on station type
    String emoji;
    switch (workStation.type) {
      case StationType.storage:
        emoji = '📦';
        break;
      case StationType.preparation:
        emoji = '🔪';
        break;
      case StationType.counter:
        emoji = '💰';
        break;
      default:
        emoji = '❓';
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: 32),
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

    // Draw interaction prompt when highlighted
    if (isHighlighted) {
      final promptPainter = TextPainter(
        text: TextSpan(
          text: 'Press A',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            backgroundColor: Colors.black87,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      promptPainter.layout();
      promptPainter.paint(
        canvas,
        Offset(
          size.x / 2 - promptPainter.width / 2,
          -20,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check if player is nearby for highlighting
    final playerPos = gameController.player.position;
    final distance = (position - playerPos).length;
    isHighlighted = distance < 80.0;
  }
}
