import 'package:flutter/material.dart';
import 'package:chicken_game/view/chicken_game.dart';
import 'package:flame/game.dart';
import 'flutter/sprite_image_of_chicken.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ChickenGame _chickenGame;

  @override
  void initState() {
    super.initState();
    _chickenGame = ChickenGame();
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _chickenGame.pauseEngine();
    } else if (state == AppLifecycleState.resumed) {
      _chickenGame.resumeEngine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: _chickenGame,
            backgroundBuilder: (context) {
              return Container(
                color: Colors.black,
              );
            },
            overlayBuilderMap: {
              'GameOverOverlay': (BuildContext context, ChickenGame game) {
                return Center(
                  child: AlertDialog(
                    title: const Text('🔥 Game Over'),
                    content: const Text('The chicken touched fire!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          game.overlays.remove('GameOverOverlay');
                          game.resumeEngine();
                          //game.reset(); // if you have a reset method
                        },
                        child: const Text('Restart'),
                      )
                    ],
                  ),
                );
              },
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StoppedChicken()));
                // _chickenGame.toggleBackgroundMovement();
              },
              child: const Icon(Icons.touch_app),
            ),
          ),
        ],
      ),
    );
  }

}
