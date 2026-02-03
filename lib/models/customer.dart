import 'package:vector_math/vector_math_64.dart';
import 'order.dart';
import '../utils/enums.dart';

class Customer {
  final String id;
  Vector2 position;
  Vector2? targetPosition;
  SushiOrder order;
  CustomerState state;
  CustomerMood mood;
  double maxPatience;
  double currentPatience;
  int baseReward;
  int tipAmount;
  int? tableId;

  Customer({
    required this.id,
    required this.position,
    required this.order,
    this.maxPatience = 60.0,
    this.baseReward = 50,
    this.state = CustomerState.waiting,
    this.mood = CustomerMood.neutral,
  }) : currentPatience = maxPatience, tipAmount = 0;

  void updatePatience(double dt) {
    if (state == CustomerState.waiting) {
      currentPatience -= dt;
      double patienceRatio = currentPatience / maxPatience;
      if (patienceRatio > 0.7) mood = CustomerMood.happy;
      else if (patienceRatio > 0.3) mood = CustomerMood.neutral;
      else mood = CustomerMood.angry;
      if (currentPatience <= 0) {
        state = CustomerState.leaving;
        mood = CustomerMood.furious;
      }
    }
  }

  int calculateReward() {
    double patienceRatio = currentPatience / maxPatience;
    if (patienceRatio > 0.8) tipAmount = (baseReward * 0.5).toInt();
    else if (patienceRatio > 0.5) tipAmount = (baseReward * 0.2).toInt();
    return baseReward + tipAmount;
  }

  void serve() {
    state = CustomerState.eating;
    mood = CustomerMood.happy;
  }

  void finishEating() { state = CustomerState.leaving; }
}
