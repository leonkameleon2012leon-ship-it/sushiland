import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Particle effect components for visual feedback

/// Sparkle particle effect when collecting items
class SparkleEffect extends PositionComponent {
  final List<_Particle> particles = [];
  double lifetime = 0;
  final double maxLifetime = 1.0;

  SparkleEffect({required Vector2 position}) : super(position: position) {
    // Create 5-10 sparkle particles
    final random = math.Random();
    for (int i = 0; i < 7; i++) {
      particles.add(_Particle(
        offset: Vector2(
          (random.nextDouble() - 0.5) * 40,
          (random.nextDouble() - 0.5) * 40,
        ),
        velocity: Vector2(
          (random.nextDouble() - 0.5) * 100,
          (random.nextDouble() - 0.5) * 100,
        ),
        color: Colors.yellow,
        size: random.nextDouble() * 5 + 3,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    lifetime += dt;

    for (var particle in particles) {
      particle.offset += particle.velocity * dt;
      particle.velocity *= 0.95; // Slow down
    }

    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final alpha = (1 - lifetime / maxLifetime).clamp(0.0, 1.0);
    
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(alpha)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(particle.offset.x, particle.offset.y),
        particle.size,
        paint,
      );
    }
  }
}

/// Star burst effect when completing a dish
class StarBurstEffect extends PositionComponent {
  final List<_Particle> particles = [];
  double lifetime = 0;
  final double maxLifetime = 1.2;

  StarBurstEffect({required Vector2 position}) : super(position: position) {
    // Create 8 stars radiating out
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      particles.add(_Particle(
        offset: Vector2.zero(),
        velocity: Vector2(math.cos(angle), math.sin(angle)) * 80,
        color: Colors.yellow,
        size: 8,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    lifetime += dt;

    for (var particle in particles) {
      particle.offset += particle.velocity * dt;
    }

    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final alpha = (1 - lifetime / maxLifetime).clamp(0.0, 1.0);
    
    for (var particle in particles) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '⭐',
          style: TextStyle(fontSize: particle.size * 2),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      canvas.save();
      canvas.translate(particle.offset.x, particle.offset.y);
      canvas.scale(alpha);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }
}

/// Money float effect when serving customers
class MoneyFloatEffect extends PositionComponent {
  final int amount;
  double lifetime = 0;
  final double maxLifetime = 2.0;

  MoneyFloatEffect({
    required Vector2 position,
    required this.amount,
  }) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    lifetime += dt;
    position.y -= 30 * dt; // Float upward

    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final alpha = (1 - lifetime / maxLifetime).clamp(0.0, 1.0);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '+\$$amount',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green.withOpacity(alpha),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}

/// Heart effect when customer is happy
class HeartEffect extends PositionComponent {
  final List<_Particle> particles = [];
  double lifetime = 0;
  final double maxLifetime = 1.5;

  HeartEffect({required Vector2 position}) : super(position: position) {
    // Create 3 hearts
    final random = math.Random();
    for (int i = 0; i < 3; i++) {
      particles.add(_Particle(
        offset: Vector2(
          (random.nextDouble() - 0.5) * 20,
          0,
        ),
        velocity: Vector2(
          (random.nextDouble() - 0.5) * 20,
          -50,
        ),
        color: Colors.pink,
        size: 8,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    lifetime += dt;

    for (var particle in particles) {
      particle.offset += particle.velocity * dt;
    }

    if (lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final alpha = (1 - lifetime / maxLifetime).clamp(0.0, 1.0);
    
    for (var particle in particles) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '💗',
          style: TextStyle(fontSize: particle.size * 2),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      canvas.save();
      canvas.translate(particle.offset.x, particle.offset.y);
      canvas.scale(alpha);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }
}

/// Simple particle data class
class _Particle {
  Vector2 offset;
  Vector2 velocity;
  Color color;
  double size;

  _Particle({
    required this.offset,
    required this.velocity,
    required this.color,
    required this.size,
  });
}
