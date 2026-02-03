import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/game_controller.dart';

class GameHUD extends StatelessWidget {
  const GameHUD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, gameController, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HUDItem(
                icon: Icons.monetization_on,
                label: 'Money',
                value: '\$' + gameController.restaurant.money.toString(),
                color: Colors.yellow,
              ),
              HUDItem(
                icon: Icons.star,
                label: 'Reputation',
                value: gameController.restaurant.reputation.toString(),
                color: Colors.orange,
              ),
              HUDItem(
                icon: Icons.people,
                label: 'Customers',
                value: gameController.customerController.customers.length.toString() + '/' + gameController.restaurant.maxCustomers.toString(),
                color: Colors.blue,
              ),
              HUDItem(
                icon: Icons.timer,
                label: 'Time',
                value: gameController.gameTime.toInt().toString() + 's',
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}

class HUDItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const HUDItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 5),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
