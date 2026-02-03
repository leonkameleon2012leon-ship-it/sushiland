import 'package:vector_math/vector_math_64.dart';

class RestaurantTable {
  final int id;
  Vector2 position;
  bool isOccupied;
  String? occupiedByCustomerId;
  int seats;

  RestaurantTable({
    required this.id,
    required this.position,
    this.isOccupied = false,
    this.occupiedByCustomerId,
    this.seats = 2,
  });

  void occupy(String customerId) {
    isOccupied = true;
    occupiedByCustomerId = customerId;
  }

  void free() {
    isOccupied = false;
    occupiedByCustomerId = null;
  }
}
