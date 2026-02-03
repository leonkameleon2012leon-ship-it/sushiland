import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../models/table.dart';

/// Table component with visual states
class TableComponent extends PositionComponent with CollisionCallbacks {
  final dynamic table;

  TableComponent({
    required this.table,
  }) : super(
          position: table.position,
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: 25));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw table
    Color tableColor;
    if (table.isOccupied) {
      tableColor = Colors.red.shade300;
    } else {
      tableColor = Colors.green.shade300;
    }

    final paint = Paint()..color = tableColor;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      25,
      paint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.brown.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      25,
      borderPaint,
    );

    // Draw table number
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'T${table.id + 1}',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
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
