import 'package:flutter/material.dart';
import 'package:chicken_game/view/chicken_game.dart';
import 'package:flame/game.dart';

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
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _chickenGame.toggleBackgroundMovement();
              },
              child: const Icon(Icons.touch_app),
            ),
          ),
        ],
      ),
    );
  }

}