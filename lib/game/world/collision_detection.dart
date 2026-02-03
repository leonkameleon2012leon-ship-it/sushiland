import 'package:vector_math/vector_math_64.dart';

/// Collision detection utilities for game entities
class CollisionDetection {
  /// Check if two circles collide
  static bool circleCircle(
    Vector2 pos1,
    double radius1,
    Vector2 pos2,
    double radius2,
  ) {
    final distance = (pos1 - pos2).length;
    return distance < (radius1 + radius2);
  }

  /// Check if circle collides with rectangle
  static bool circleRect(
    Vector2 circlePos,
    double radius,
    Vector2 rectPos,
    double rectWidth,
    double rectHeight,
  ) {
    // Find closest point on rectangle to circle center
    final closestX = circlePos.x.clamp(
      rectPos.x - rectWidth / 2,
      rectPos.x + rectWidth / 2,
    );
    final closestY = circlePos.y.clamp(
      rectPos.y - rectHeight / 2,
      rectPos.y + rectHeight / 2,
    );

    final distance = (circlePos - Vector2(closestX, closestY)).length;
    return distance < radius;
  }

  /// Check if two rectangles collide
  static bool rectRect(
    Vector2 pos1,
    double width1,
    double height1,
    Vector2 pos2,
    double width2,
    double height2,
  ) {
    return (pos1.x - width1 / 2 < pos2.x + width2 / 2 &&
        pos1.x + width1 / 2 > pos2.x - width2 / 2 &&
        pos1.y - height1 / 2 < pos2.y + height2 / 2 &&
        pos1.y + height1 / 2 > pos2.y - height2 / 2);
  }

  /// Check if point is inside circle
  static bool pointInCircle(Vector2 point, Vector2 center, double radius) {
    return (point - center).length < radius;
  }

  /// Check if point is inside rectangle
  static bool pointInRect(
    Vector2 point,
    Vector2 rectPos,
    double width,
    double height,
  ) {
    return (point.x > rectPos.x - width / 2 &&
        point.x < rectPos.x + width / 2 &&
        point.y > rectPos.y - height / 2 &&
        point.y < rectPos.y + height / 2);
  }

  /// Resolve collision by pushing circle out of rectangle
  static Vector2 resolveCircleRectCollision(
    Vector2 circlePos,
    double radius,
    Vector2 rectPos,
    double rectWidth,
    double rectHeight,
  ) {
    // Find penetration depth on each axis
    final dx = circlePos.x - rectPos.x;
    final dy = circlePos.y - rectPos.y;

    final penetrationX = (rectWidth / 2 + radius) - dx.abs();
    final penetrationY = (rectHeight / 2 + radius) - dy.abs();

    // Push out on axis with least penetration
    if (penetrationX < penetrationY) {
      return Vector2(dx > 0 ? penetrationX : -penetrationX, 0);
    } else {
      return Vector2(0, dy > 0 ? penetrationY : -penetrationY);
    }
  }
}
