import 'dart:collection';
import 'package:vector_math/vector_math_64.dart';

/// Simple A* pathfinding for customers to navigate around obstacles
class Pathfinding {
  static const double tileSize = 32.0;
  static const int gridWidth = 25; // 800 / 32
  static const int gridHeight = 19; // 600 / 32

  /// Find path from start to end using A* algorithm
  /// 
  /// Time Complexity: O(b^d) where b is branching factor (4) and d is path depth
  /// Space Complexity: O(b^d) for storing open and closed sets
  /// Insertion into priority queue: O(log n) using HeapPriorityQueue
  static List<Vector2> findPath(
    Vector2 start,
    Vector2 end,
    List<Vector2> obstacles,
  ) {
    // Convert world coordinates to grid coordinates
    final startTile = _worldToGrid(start);
    final endTile = _worldToGrid(end);

    // If start or end is invalid, return direct path
    if (!_isValidTile(startTile) || !_isValidTile(endTile)) {
      return [end];
    }

    // Create grid with obstacles
    final grid = _createGrid(obstacles);

    // A* pathfinding - using HeapPriorityQueue for O(log n) insertion
    final openSet = HeapPriorityQueue<_Node>((a, b) => a.f.compareTo(b.f));
    final closedSet = <String>{};
    final cameFrom = <String, _Node>{};

    final startNode = _Node(startTile, 0, _heuristic(startTile, endTile));
    openSet.add(startNode);

    while (openSet.isNotEmpty) {
      final current = openSet.removeFirst();
      final currentKey = '${current.tile.x.toInt()},${current.tile.y.toInt()}';

      if ((current.tile - endTile).length < 1) {
        // Reconstruct path
        return _reconstructPath(cameFrom, current, end);
      }

      if (closedSet.contains(currentKey)) continue;
      closedSet.add(currentKey);

      // Check neighbors (4-directional)
      final neighbors = [
        Vector2(current.tile.x + 1, current.tile.y),
        Vector2(current.tile.x - 1, current.tile.y),
        Vector2(current.tile.x, current.tile.y + 1),
        Vector2(current.tile.x, current.tile.y - 1),
      ];

      for (var neighbor in neighbors) {
        if (!_isValidTile(neighbor)) continue;
        if (grid[neighbor.y.toInt()][neighbor.x.toInt()]) continue; // Obstacle

        final neighborKey = '${neighbor.x.toInt()},${neighbor.y.toInt()}';
        if (closedSet.contains(neighborKey)) continue;

        final g = current.g + 1;
        final h = _heuristic(neighbor, endTile);
        final neighborNode = _Node(neighbor, g, h);

        cameFrom[neighborKey] = current;
        openSet.add(neighborNode);
      }
    }

    // No path found, return direct path
    return [end];
  }

  /// Convert world coordinates to grid coordinates
  static Vector2 _worldToGrid(Vector2 world) {
    return Vector2(
      (world.x / tileSize).floorToDouble(),
      (world.y / tileSize).floorToDouble(),
    );
  }

  /// Convert grid coordinates to world coordinates
  static Vector2 _gridToWorld(Vector2 grid) {
    return Vector2(
      grid.x * tileSize + tileSize / 2,
      grid.y * tileSize + tileSize / 2,
    );
  }

  /// Check if tile is within grid bounds
  static bool _isValidTile(Vector2 tile) {
    return tile.x >= 0 &&
        tile.x < gridWidth &&
        tile.y >= 0 &&
        tile.y < gridHeight;
  }

  /// Create grid with obstacles
  static List<List<bool>> _createGrid(List<Vector2> obstacles) {
    final grid = List.generate(
      gridHeight,
      (_) => List.generate(gridWidth, (_) => false),
    );

    // Mark obstacles
    for (var obstacle in obstacles) {
      final tile = _worldToGrid(obstacle);
      if (_isValidTile(tile)) {
        grid[tile.y.toInt()][tile.x.toInt()] = true;
      }
    }

    return grid;
  }

  /// Heuristic function (Manhattan distance)
  static double _heuristic(Vector2 a, Vector2 b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }

  /// Reconstruct path from came_from map
  static List<Vector2> _reconstructPath(
    Map<String, _Node> cameFrom,
    _Node current,
    Vector2 end,
  ) {
    final path = <Vector2>[end];
    var currentNode = current;

    while (true) {
      final key = '${currentNode.tile.x.toInt()},${currentNode.tile.y.toInt()}';
      if (!cameFrom.containsKey(key)) break;

      currentNode = cameFrom[key]!;
      path.insert(0, _gridToWorld(currentNode.tile));
    }

    return path;
  }
}

/// Node for A* pathfinding
class _Node {
  final Vector2 tile;
  final double g; // Cost from start
  final double h; // Heuristic to end
  double get f => g + h;

  _Node(this.tile, this.g, this.h);
}
