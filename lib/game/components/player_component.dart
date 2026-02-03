import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../models/player.dart';
import '../../controllers/game_controller.dart';
import '../../utils/enums.dart';
import '../sushiland_game.dart';

/// Player component with smooth movement, animations, and interactions
class PlayerComponent extends PositionComponent with HasGameRef, CollisionCallbacks {
  final Player player;
  final GameController gameController;
  Vector2 _movementDirection = Vector2.zero();
  
  // Animation state
  PlayerAnimationState _currentState = PlayerAnimationState.idleDown;
  double _animationTime = 0;

  PlayerComponent({
    required this.player,
    required this.gameController,
  }) : super(
          position: player.position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add collision detection
    add(CircleHitbox(radius: 20));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update position based on movement
    if (_movementDirection.length > 0) {
      final normalizedDirection = _movementDirection.normalized();
      final movement = normalizedDirection * player.speed * dt;
      
      // Calculate new position
      final newPosition = position + movement;
      
      // Check collision with work stations
      // Player radius: 20px, Station half-width: 30px
      // Normal collision threshold would be 50px (20 + 30)
      // Using 40px instead allows smoother movement near stations
      bool collides = false;
      for (var station in gameController.restaurant.workStations) {
        final distance = (newPosition - station.position).length;
        if (distance < 40) {
          collides = true;
          break;
        }
      }
      
      // Check collision with tables
      for (var table in gameController.restaurant.tables) {
        final distance = (newPosition - table.position).length;
        if (distance < 45) { // Player radius (20) + table radius (25)
          collides = true;
          break;
        }
      }
      
      // Only update position if no collision
      if (!collides) {
        position = newPosition;
        
        // Constrain to world bounds
        position.x = position.x.clamp(20.0, 780.0);
        position.y = position.y.clamp(20.0, 580.0);
        
        player.position = position;
      }
      
      // Update animation state based on direction
      _updateAnimationState(normalizedDirection);
    } else {
      _updateIdleState();
    }
    
    _animationTime += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw player as orange circle with emoji
    final paint = Paint()..color = Colors.orange;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      20,
      paint,
    );
    
    // Draw emoji based on state
    final textPainter = TextPainter(
      text: TextSpan(
        text: '👨‍🍳',
        style: const TextStyle(fontSize: 24),
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
    
    // Show inventory if carrying items
    if (player.inventory.isNotEmpty) {
      final invPainter = TextPainter(
        text: TextSpan(
          text: '📦${player.inventory.length}',
          style: const TextStyle(fontSize: 14, backgroundColor: Colors.black45),
        ),
        textDirection: TextDirection.ltr,
      );
      invPainter.layout();
      invPainter.paint(
        canvas,
        Offset(size.x / 2 - invPainter.width / 2, -25),
      );
    }
    
    // Show held sushi
    if (player.heldSushi != null) {
      final sushiPainter = TextPainter(
        text: TextSpan(
          text: '🍣',
          style: const TextStyle(fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      sushiPainter.layout();
      sushiPainter.paint(
        canvas,
        Offset(size.x / 2 - sushiPainter.width / 2, -30),
      );
    }
  }

  void setMovementDirection(Vector2 direction) {
    _movementDirection = direction;
  }

  void _updateAnimationState(Vector2 direction) {
    // Determine direction
    if (direction.y < -0.5) {
      _currentState = PlayerAnimationState.walkUp;
    } else if (direction.y > 0.5) {
      _currentState = PlayerAnimationState.walkDown;
    } else if (direction.x < 0) {
      _currentState = PlayerAnimationState.walkLeft;
    } else if (direction.x > 0) {
      _currentState = PlayerAnimationState.walkRight;
    }
    
    player.state = PlayerState.walking;
  }

  void _updateIdleState() {
    // Switch to idle based on last direction
    switch (_currentState) {
      case PlayerAnimationState.walkUp:
        _currentState = PlayerAnimationState.idleUp;
        break;
      case PlayerAnimationState.walkDown:
        _currentState = PlayerAnimationState.idleDown;
        break;
      case PlayerAnimationState.walkLeft:
        _currentState = PlayerAnimationState.idleLeft;
        break;
      case PlayerAnimationState.walkRight:
        _currentState = PlayerAnimationState.idleRight;
        break;
      default:
        break;
    }
    
    player.state = PlayerState.idle;
  }

  void interact() {
    // Spawn sparkle effect at player position
    if (gameRef is SushilandGame) {
      final game = gameRef as SushilandGame;
      game.spawnParticleEffect('sparkle', position);
    }
    
    gameController.interact();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Handle collision - can be used to prevent walking through furniture
  }
}

/// Animation states for the player
enum PlayerAnimationState {
  idleUp,
  idleDown,
  idleLeft,
  idleRight,
  walkUp,
  walkDown,
  walkLeft,
  walkRight,
  prepare,
  serve,
}
