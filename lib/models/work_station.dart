import 'package:vector_math/vector_math_64.dart';
import '../utils/enums.dart';

class WorkStation {
  final String id;
  final StationType type;
  Vector2 position;
  bool isOccupied;
  bool isInteractable;
  int level;

  WorkStation({
    required this.id,
    required this.type,
    required this.position,
    this.isOccupied = false,
    this.isInteractable = false,
    this.level = 1,
  });

  String get typeName {
    switch (type) {
      case StationType.storage: return 'Storage';
      case StationType.preparation: return 'Preparation Station';
      case StationType.counter: return 'Counter';
      case StationType.dishwashing: return 'Dishwashing';
      case StationType.decoration: return 'Decoration';
    }
  }
}
