import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../chicken_game.dart';
import 'big_fire.dart';
import 'coin.dart';
import 'fire.dart';

enum ChickenState { idle, running }

class ChickenDash extends SpriteAnimationGroupComponent<ChickenState>
    with CollisionCallbacks, HasGameRef<ChickenGame> {
  final List<Vector2> pathPoints;
  List<Coin> coins = [];

  ChickenDash({
    required List<Vector2> coinPositions,
    required this.coins,
  })  : pathPoints = List.from(coinPositions), // Ensures safe copying
        super(
          position: Vector2(-280, 260),
          size: Vector2.all(180.0),
          anchor: Anchor.center,
        ) {
    print("Coins List Received in ChickenDash: $coins");
    print("Total Coins in ChickenDash: ${coins.length}");
  }

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _runAnimation;

  int currentIndex = 0;
  bool isMoving = false;
  Vector2 _targetPosition = Vector2.zero();
  Vector2 _originalCoinPosition =
      Vector2.zero(); // Store the original coin position
  double chickenSpeed = 25.0; // Base speed
  double speedMultiplier =
      2.0; // Speed multiplier (can be adjusted dynamically)

  void setSpeedMultiplier(double multiplier) {
    speedMultiplier = multiplier;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()..debugMode = true);
    try {
      _idleAnimation = await _loadAnimation('chickens/chicken', 30, 0.03);
      _runAnimation = await _loadAnimation('chickens/chicken_run', 4, 0.2);

      animations = {
        ChickenState.idle: _idleAnimation,
        ChickenState.running: _runAnimation,
      };

      current = ChickenState.idle;

      if (pathPoints.isNotEmpty) {
        _targetPosition = Vector2(
          pathPoints[currentIndex].x - 200,
          pathPoints[currentIndex].y + 130,
        );
        _originalCoinPosition =
            pathPoints[currentIndex]; // Store the original coin position
      }
    } catch (e) {
      print('Failed to load animations: $e');
    }
  }

  Future<SpriteAnimation> _loadAnimation(
      String basePath, int count, double stepTime) async {
    final List<Sprite> frames = [];
    for (var i = 1; i <= count; i++) {
      try {
        frames.add(await Sprite.load('$basePath$i.png'));
      } catch (e) {
        print("❌ Failed to load frame $i for $basePath: $e");
      }
    }
    if (frames.isEmpty) throw Exception('❌ No frames loaded for $basePath');
    return SpriteAnimation.spriteList(frames, stepTime: stepTime);
  }

  void moveToNextPoint() {
    if (!isMoving && currentIndex < pathPoints.length) {
      // final getChickenLastMovementStopIndex =
      //     pathPoints.indexWhere((e) => e.x >= 250 && e.x <= 350);
      //
      // // for (int i = 0; i < pathPoints.length; i++) {
      // //   final position = pathPoints[i];
      // //   final fixedPosition = pathPoints[getChickenLastMovementStopIndex];
      // //   debugPrint("x: ${position.x} || y: ${position.y}");
      // //   if (position.x <= 300) {
      // //     _targetPosition = Vector2(position.x + 290, position.y + 130);
      // //   } else {
      // //     _targetPosition = Vector2(.5,  position.y + 130);
      // //   }
      // // }
      // final position = pathPoints[currentIndex];
      //
      // // Optional alignment offset
      // //  double xOffset =currentIndex==0? 300:200;
      // const double yOffset = 130;
      // if(currentIndex==0){
      //   print("id gfgfh");
      //   _targetPosition = Vector2(
      //     position.x - 300,
      //     position.y + yOffset,
      //   );
      // }else if(currentIndex==1){
      //   print("ytubhdsfetygu,MediaQuery.of(context)");
      //   _targetPosition = Vector2(
      //     position.x - 250,
      //     position.y + yOffset,
      //   );
      // }else{
      //   print("yrmnbutnbvdtkj");
      //   _targetPosition = Vector2(
      //     position.x - 200,
      //     position.y + yOffset,
      //   );
      // }

      _targetPosition = Vector2(
        currentIndex == 0
            ? pathPoints[currentIndex].x - 290
            : currentIndex == 1
            ? pathPoints[currentIndex].x - 230
            : currentIndex == 2
            ? pathPoints[currentIndex].x - 170
            : currentIndex == 3
            ? pathPoints[currentIndex].x - 120
            : currentIndex == 4
            ? pathPoints[currentIndex].x - 70: currentIndex == 5
            ? pathPoints[currentIndex].x - 10: pathPoints[currentIndex].x - 0,
        pathPoints[currentIndex].y + 130,
      );
      print('pathPoints.x:${pathPoints[currentIndex].x}');
      print('pathPoints.y:${pathPoints[currentIndex].y}');
      _originalCoinPosition = pathPoints[currentIndex];
      isMoving = true;
      current = ChickenState.running;
      print('🐔 Moving to coin at: $_targetPosition');
      gameRef.world.background.toggleMovement(true);
    }
  }


  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      final direction = _targetPosition - position;
      final distanceToTarget = direction.length;

      debugPrint('Distance to target: $distanceToTarget');
      debugPrint('Current speed: ${chickenSpeed * speedMultiplier}');

      if (distanceToTarget > 1.0) {
        final step =
            direction.normalized() * chickenSpeed * speedMultiplier * dt;
        if (step.length > distanceToTarget) {
          debugPrint('Snapping to target');
          position = _targetPosition;
        } else {
          position += step;
        }
      } else {
        debugPrint('Reached target');
        position = _targetPosition;
        isMoving = false;
        current = ChickenState.idle;

        // Stop background movement
        gameRef.world.background.toggleMovement(false);

        // ✅ Flip the coin at the current position
        for (var coin in coins) {
          if (coin.position.distanceTo(_originalCoinPosition) < 10.0) {
            coin.flipCoin();
            print('🟡 Coin flipped at ${coin.position}!');
          }
        }

        // ✅ Prepare for the next move (but do NOT move yet)
        if (currentIndex < pathPoints.length - 1) {
          currentIndex++;
        }
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    debugPrint("🔥 Collision detected with: ${other.runtimeType}");

    if (other is FireDash) {
      debugPrint("🔥 Chicken touched FireDash!");
      _handleFireCollision();
    }
  }

  void _handleFireCollision() {
    // Stop the chicken's movement and animation
    current = ChickenState.idle;
    isMoving = false;

    // Store the chicken's position before removing it
    final Vector2 firePosition = position.clone();

    // Remove the chicken from the game
    removeFromParent();

    final bigFire = BigFireAnimation(position: firePosition);
    gameRef.add(bigFire);

// Show overlay right after adding the fire
    Future.delayed(Duration(milliseconds: 200), () {
      gameRef.pauseEngine();
      gameRef.overlays.add('GameOverOverlay'); // or your desired overlay
    });

    // Delay Game Over screen to let animation play
    _showGameOver();
  }

  void _showGameOver() {
    Future.delayed(Duration(seconds: 1), () {
      gameRef.pauseEngine();
      gameRef.overlays.add('GameOverOverlay');
    });
  }
}
