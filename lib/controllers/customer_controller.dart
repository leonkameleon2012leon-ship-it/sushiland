import 'package:vector_math/vector_math_64.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/restaurant.dart';
import '../utils/enums.dart';

class CustomerController {
  final Restaurant restaurant;
  List<Customer> customers = [];
  int _customerIdCounter = 0;

  CustomerController({required this.restaurant});

  void update(double dt) {
    for (var customer in customers) {
      customer.updatePatience(dt);
      
      if (customer.targetPosition != null) {
        Vector2 direction = customer.targetPosition! - customer.position;
        if (direction.length > 5) {
          direction.normalize();
          customer.position += direction * 50 * dt;
        }
      }
    }
  }

  void spawnCustomer() {
    List<SushiType> availableTypes = [
      SushiType.maki,
      SushiType.nigiri,
      SushiType.californiaRoll,
    ];
    
    SushiType randomType = availableTypes[DateTime.now().millisecond % availableTypes.length];
    
    Customer newCustomer = Customer(
      id: 'customer_' + _customerIdCounter.toString(),
      position: Vector2(50, 300),
      order: SushiOrder(
        id: 'order_' + _customerIdCounter.toString(),
        sushiType: randomType,
        basePrice: 50 + (randomType.index * 20),
      ),
      maxPatience: 60.0,
      baseReward: 50,
    );

    _customerIdCounter++;

    var table = restaurant.findAvailableTable();
    if (table != null) {
      table.occupy(newCustomer.id);
      newCustomer.tableId = table.id;
      newCustomer.targetPosition = table.position;
    }

    customers.add(newCustomer);
  }

  void removeCustomer(Customer customer) {
    if (customer.tableId != null) {
      var table = restaurant.tables.firstWhere((t) => t.id == customer.tableId);
      table.free();
    }
    customers.remove(customer);
  }

  Customer? findCustomerWaitingFor(SushiType sushiType) {
    try {
      return customers.firstWhere(
        (c) => c.state == CustomerState.waiting && c.order.sushiType == sushiType,
      );
    } catch (e) {
      return null;
    }
  }
}
