import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../controllers/game_controller.dart';
import '../widgets/ui/hud.dart';
import '../widgets/controls/virtual_joystick.dart';
import '../widgets/controls/action_buttons.dart';
import '../game/sushiland_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late SushilandGame _game;
  late GameController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = context.read<GameController>();
    _game = SushilandGame(gameController: _gameController);
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 16),
    )..addListener(_gameLoop);
    _animationController.repeat();
  }

  void _gameLoop() {
    _gameController.update(0.016);
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
              // Flame game widget
              GameWidget(
                game: _game,
              ),
              // HUD overlay
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: GameHUD(),
              ),
              // Virtual joystick
              Positioned(
                bottom: 40,
                left: 40,
                child: VirtualJoystick(
                  onDirectionChanged: (direction) {
                    _game.updatePlayerMovement(direction);
                    gameController.movePlayer(direction);
                  },
                ),
              ),
              // Action buttons
              Positioned(
                bottom: 40,
                right: 40,
                child: ActionButtons(
                  onInteract: () {
                    _game.triggerInteraction();
                  },
                  onMenu: () => gameController.pauseGame(),
                ),
              ),
              // Pause menu overlay
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
