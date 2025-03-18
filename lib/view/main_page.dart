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
//import 'package:flame/components.dart';
// import 'coin.dart';
//
// enum ChickenState { idle, running }
//
// class ChickenDash extends SpriteAnimationGroupComponent<ChickenState> {
//   final List<Vector2> pathPoints;
//   List<Coin> coins = [];
//
//   ChickenDash({
//     required List<Vector2> coinPositions,
//     required this.coins,
//   })  : pathPoints = coinPositions.isNotEmpty
//             ? coinPositions.map((coin) => coin.clone()).toList()
//             : [],
//         super(
//           position: Vector2(-280, 260),
//           size: Vector2.all(200.0),
//           anchor: Anchor.center,
//         ) {
//     print("Coins List Received in ChickenDash: $coins");
//     print("Total Coins in ChickenDash: ${coins.length}");
//   }
//
//   late SpriteAnimation _idleAnimation;
//   late SpriteAnimation _runAnimation;
//
//   final double chickenSpeed = 80.0;
//
//   int currentIndex = 0;
//   bool isMoving = false;
//   Vector2 _targetPosition = Vector2.zero();
//
//   @override
//   Future<void> onLoad() async {
//     try {
//       _idleAnimation = await _loadAnimation('chickens/chicken', 30, 0.05);
//       _runAnimation = await _loadAnimation('chickens/chicken_run', 4, 0.2);
//
//       animations = {
//         ChickenState.idle: _idleAnimation,
//         ChickenState.running: _runAnimation,
//       };
//
//       current = ChickenState.idle;
//       if (pathPoints.isNotEmpty) {
//         _targetPosition = pathPoints[currentIndex];
//       }
//     } catch (e) {
//       print('Failed to load animations: $e');
//     }
//   }
//
//   Future<SpriteAnimation> _loadAnimation(
//       String basePath, int count, double stepTime) async {
//     final List<Sprite> frames = [];
//     for (var i = 1; i <= count; i++) {
//       try {
//         frames.add(await Sprite.load('$basePath$i.png'));
//       } catch (_) {}
//     }
//     if (frames.isEmpty) throw Exception('❌ No frames loaded for $basePath');
//     return SpriteAnimation.spriteList(frames, stepTime: stepTime);
//   }
//
//   void moveToNextPoint() {
//     if (!isMoving && currentIndex < pathPoints.length) {
//       _targetPosition = Vector2(pathPoints[currentIndex].x - 180,
//           pathPoints[currentIndex].y + 130); // Set target position
//       isMoving = true;
//       current = ChickenState.running;
//       print(ChickenState.running);
//       print('ChickenState.running');
//     }
//   }
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//
//     if (isMoving) {
//       final direction = (_targetPosition - position).normalized();
//       position += direction * chickenSpeed * dt;
//
//       if (position.distanceTo(_targetPosition) < 2.0) {
//         position = _targetPosition;
//         isMoving = false;
//         current = ChickenState.idle;
//
//         // Debug prints to check positions
//         print('Chicken Position: $position');
//         print(
//             'Coins Positions: ${coins.map((coin) => coin.position).toList()}');
//
//         // ✅ Flip coins if near
//         for (var coin in coins) {
//           final distance = coin.position.distanceTo(position);
//           print('Distance to coin at ${coin.position}: $distance');
//           if (coin.position.distanceTo(position) < 50.0) {
//             coin.flipCoin();
//             print('🟡 Coin flipped at ${coin.position}!');
//           }
//         }
//
//         // ✅ Automatically move to the next point
//         if (currentIndex < pathPoints.length - 1) {
//           currentIndex++; // Move to next point
//           _targetPosition = pathPoints[currentIndex]; // Update target position
//         }
//       }
//     }
//   }
// }