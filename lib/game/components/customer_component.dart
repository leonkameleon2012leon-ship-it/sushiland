import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../models/customer.dart';
import '../../controllers/game_controller.dart';
import '../../utils/enums.dart';

/// Customer component with AI, pathfinding, and animations
class CustomerComponent extends PositionComponent with CollisionCallbacks {
  final Customer customer;
  final GameController gameController;
  double _animationTime = 0;

  CustomerComponent({
    required this.customer,
    required this.gameController,
  }) : super(
          position: customer.position,
          size: Vector2(35, 35),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: 17.5));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    _animationTime += dt;
    
    // Update customer position from model
    position = customer.position;
    
    // Simple pathfinding to target position
    if (customer.targetPosition != null) {
      final direction = customer.targetPosition! - customer.position;
      if (direction.length > 2) {
        final normalizedDirection = direction.normalized();
        customer.position += normalizedDirection * 50 * dt; // 50 pixels/second
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw customer body
    final paint = Paint()..color = _getCustomerColor();
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      17.5,
      paint,
    );

    // Draw customer emoji
    final textPainter = TextPainter(
      text: TextSpan(
        text: '👤',
        style: TextStyle(fontSize: 20),
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

    // Draw patience bar above head
    _drawPatienceBar(canvas);

    // Draw mood emoji
    _drawMoodEmoji(canvas);

    // Draw order bubble
    if (customer.state == CustomerState.waiting) {
      _drawOrderBubble(canvas);
    }
  }

  void _drawPatienceBar(Canvas canvas) {
    const barWidth = 40.0;
    const barHeight = 5.0;
    final patienceRatio = (customer.currentPatience / customer.maxPatience).clamp(0.0, 1.0);

    // Background
    final bgPaint = Paint()..color = Colors.red;
    canvas.drawRect(
      Rect.fromLTWH(
        size.x / 2 - barWidth / 2,
        -25,
        barWidth,
        barHeight,
      ),
      bgPaint,
    );

    // Fill
    final fillPaint = Paint()..color = Colors.green;
    canvas.drawRect(
      Rect.fromLTWH(
        size.x / 2 - barWidth / 2,
        -25,
        barWidth * patienceRatio,
        barHeight,
      ),
      fillPaint,
    );
  }

  void _drawMoodEmoji(Canvas canvas) {
    String emoji;
    switch (customer.mood) {
      case CustomerMood.happy:
        emoji = '😊';
        break;
      case CustomerMood.neutral:
        emoji = '😐';
        break;
      case CustomerMood.annoyed:
        emoji = '😠';
        break;
      case CustomerMood.angry:
        emoji = '😡';
        break;
      case CustomerMood.furious:
        emoji = '💢';
        break;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        -45,
      ),
    );
  }

  void _drawOrderBubble(Canvas canvas) {
    // Draw speech bubble with order
    final bubblePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x + 25, -20),
      15,
      bubblePaint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(
      Offset(size.x + 25, -20),
      15,
      borderPaint,
    );

    // Draw sushi icon in bubble
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🍣',
        style: TextStyle(fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.x + 25 - textPainter.width / 2, -27),
    );
  }

  Color _getCustomerColor() {
    // Different colors based on customer ID for variety
    final hash = customer.id.hashCode;
    switch (hash % 3) {
      case 0:
        return Colors.blue.shade300;
      case 1:
        return Colors.purple.shade300;
      default:
        return Colors.teal.shade300;
    }
  }
}
