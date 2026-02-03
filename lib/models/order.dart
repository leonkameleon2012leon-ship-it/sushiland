import '../utils/enums.dart';

class SushiOrder {
  final String id;
  final SushiType sushiType;
  final int quantity;
  final int basePrice;

  SushiOrder({
    required this.id,
    required this.sushiType,
    this.quantity = 1,
    required this.basePrice,
  });

  int get totalPrice => basePrice * quantity;
}
