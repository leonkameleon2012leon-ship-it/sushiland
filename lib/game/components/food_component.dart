import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/sushi.dart';
import '../../utils/enums.dart';

/// Food component for visual representation of sushi
class FoodComponent extends PositionComponent {
  final Sushi sushi;
  double _floatAnimation = 0;

  FoodComponent({
    required this.sushi,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(30, 30),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _floatAnimation += dt * 3;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Floating effect
    final floatOffset = Offset(0, 3 * (0.5 + 0.5 * math.sin(_floatAnimation)));

    // Draw sushi emoji
    final textPainter = TextPainter(
      text: TextSpan(
        text: _getSushiEmoji(),
        style: TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ) + floatOffset,
    );

    // Draw quality stars
    if (sushi.quality != SushiQuality.poor) {
      final starPainter = TextPainter(
        text: TextSpan(
          text: '⭐' * _getQualityStars(),
          style: TextStyle(fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      starPainter.layout();
      starPainter.paint(
        canvas,
        Offset(
          size.x / 2 - starPainter.width / 2,
          -15,
        ),
      );
    }
  }

  String _getSushiEmoji() {
    switch (sushi.type) {
      case SushiType.maki:
        return '🍣';
      case SushiType.nigiri:
        return '🍱';
      case SushiType.sashimi:
        return '🐟';
      case SushiType.californiaRoll:
        return '🥒';
      case SushiType.dragonRoll:
        return '🐉';
      case SushiType.rainbowRoll:
        return '🌈';
      default:
        return '🍣';
    }
  }

  int _getQualityStars() {
    switch (sushi.quality) {
      case SushiQuality.excellent:
        return 3;
      case SushiQuality.good:
        return 2;
      case SushiQuality.normal:
        return 1;
      default:
        return 0;
    }
  }
}
