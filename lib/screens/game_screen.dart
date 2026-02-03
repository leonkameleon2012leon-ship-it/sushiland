import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/ui/hud.dart';
import '../widgets/controls/virtual_joystick.dart';
import '../widgets/controls/action_buttons.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 16),
    )..addListener(_gameLoop);
    _animationController.repeat();
  }

  void _gameLoop() {
    final gameController = context.read<GameController>();
    gameController.update(0.016);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameController>(
        builder: (context, gameController, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.brown.shade200, Colors.brown.shade100],
                  ),
                ),
              ),
              Center(
                child: CustomPaint(
                  size: Size(double.infinity, double.infinity),
                  painter: GameWorldPainter(gameController: gameController),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: GameHUD(),
              ),
              Positioned(
                bottom: 40,
                left: 40,
                child: VirtualJoystick(
                  onDirectionChanged: (direction) {
                    gameController.movePlayer(direction);
                  },
                ),
              ),
              Positioned(
                bottom: 40,
                right: 40,
                child: ActionButtons(
                  onInteract: () => gameController.interact(),
                  onMenu: () => gameController.pauseGame(),
                ),
              ),
              if (gameController.isPaused)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'PAUSED',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => gameController.resumeGame(),
                              child: Text('Resume'),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                gameController.resetGame();
                                Navigator.pop(context);
                              },
                              child: Text('Main Menu'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class GameWorldPainter extends CustomPainter {
  final GameController gameController;

  GameWorldPainter({required this.gameController});

  @override
  void paint(Canvas canvas, Size size) {
    for (var station in gameController.restaurant.workStations) {
      _drawStation(canvas, station);
    }

    for (var table in gameController.restaurant.tables) {
      _drawTable(canvas, table);
    }

    for (var customer in gameController.customerController.customers) {
      _drawCustomer(canvas, customer);
    }

    _drawPlayer(canvas, gameController.player);
  }

  void _drawStation(Canvas canvas, station) {
    Paint paint = Paint()..color = Colors.grey.shade700;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(station.position.x, station.position.y),
        width: 60,
        height: 60,
      ),
      paint,
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: station.typeName,
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        station.position.x - textPainter.width / 2,
        station.position.y - 10,
      ),
    );
  }

  void _drawTable(Canvas canvas, table) {
    Paint paint = Paint()
      ..color = table.isOccupied ? Colors.red.shade300 : Colors.green.shade300;
    canvas.drawCircle(
      Offset(table.position.x, table.position.y),
      25,
      paint,
    );
  }

  void _drawCustomer(Canvas canvas, customer) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(
      Offset(customer.position.x, customer.position.y),
      20,
      paint,
    );

    double barWidth = 40;
    double patienceRatio = customer.currentPatience / customer.maxPatience;
    Paint barBg = Paint()..color = Colors.red;
    Paint barFill = Paint()..color = Colors.green;

    canvas.drawRect(
      Rect.fromLTWH(
        customer.position.x - barWidth / 2,
        customer.position.y - 35,
        barWidth,
        5,
      ),
      barBg,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        customer.position.x - barWidth / 2,
        customer.position.y - 35,
        barWidth * patienceRatio,
        5,
      ),
      barFill,
    );
  }

  void _drawPlayer(Canvas canvas, player) {
    Paint paint = Paint()..color = Colors.orange;
    canvas.drawCircle(
      Offset(player.position.x, player.position.y),
      25,
      paint,
    );

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '👨‍🍳',
        style: TextStyle(fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        player.position.x - textPainter.width / 2,
        player.position.y - textPainter.height / 2,
      ),
    );

    if (player.inventory.isNotEmpty) {
      TextPainter invPainter = TextPainter(
        text: TextSpan(
          text: 'Items: ' + player.inventory.length.toString(),
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      invPainter.layout();
      invPainter.paint(
        canvas,
        Offset(player.position.x - 20, player.position.y + 30),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
