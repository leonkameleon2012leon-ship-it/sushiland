import 'work_station.dart';
import 'table.dart';

class Restaurant {
  int level;
  int money;
  int reputation;
  List<WorkStation> workStations;
  List<RestaurantTable> tables;
  int maxCustomers;
  int maxTables;
  int totalCustomersServed;
  int totalMoneyEarned;
  double customerSatisfaction;

  Restaurant({
    this.level = 1,
    this.money = 100,
    this.reputation = 0,
    this.maxCustomers = 3,
    this.maxTables = 2,
    this.totalCustomersServed = 0,
    this.totalMoneyEarned = 0,
    this.customerSatisfaction = 1.0,
  }) : workStations = [], tables = [];

  void addMoney(int amount) {
    money += amount;
    totalMoneyEarned += amount;
  }

  bool spendMoney(int amount) {
    if (money >= amount) {
      money -= amount;
      return true;
    }
    return false;
  }

  void addReputation(int amount) {
    reputation += amount;
    checkLevelUp();
  }

  void checkLevelUp() {
    int requiredReputation = level * 100;
    if (reputation >= requiredReputation) levelUp();
  }

  void levelUp() {
    level++;
    maxCustomers++;
    maxTables++;
  }

  void addWorkStation(WorkStation station) { workStations.add(station); }

  void addTable(RestaurantTable table) {
    if (tables.length < maxTables) tables.add(table);
  }

  RestaurantTable? findAvailableTable() {
    try {
      return tables.firstWhere((table) => !table.isOccupied);
    } catch (e) {
      return null;
    }
  }
}
