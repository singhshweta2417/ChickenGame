import 'package:flame/components.dart';
import 'coin.dart';

enum ChickenState { idle, running }

class ChickenDash extends SpriteAnimationGroupComponent<ChickenState> {
  final List<Vector2> pathPoints;
  List<Coin> coins = [];

  ChickenDash({
    required List<Vector2> coinPositions,
    required this.coins,
  })  : pathPoints = List.from(coinPositions), // Ensures safe copying
        super(
        position: Vector2(-280, 260),
        size: Vector2.all(200.0),
        anchor: Anchor.center,
      ) {
    print("Coins List Received in ChickenDash: $coins");
    print("Total Coins in ChickenDash: ${coins.length}");
  }

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _runAnimation;

  final double chickenSpeed = 80.0;

  int currentIndex = 0;
  bool isMoving = false;
  Vector2 _targetPosition = Vector2.zero();
  Vector2 _originalCoinPosition = Vector2.zero(); // Store the original coin position

  @override
  Future<void> onLoad() async {
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
        _originalCoinPosition = pathPoints[currentIndex]; // Store the original coin position
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
      _targetPosition = Vector2(
        pathPoints[currentIndex].x - 200,
        pathPoints[currentIndex].y + 130,
      );
      _originalCoinPosition = pathPoints[currentIndex]; // Store the original coin position
      isMoving = true;
      current = ChickenState.running;
      print('🐔 Moving to coin at: $_targetPosition');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      final direction = _targetPosition - position;

      if (direction.length > 1.0) {
        position += direction.normalized() * chickenSpeed * dt;
      }

      if (position.distanceTo(_targetPosition) < 2.0) {
        position = _targetPosition;
        isMoving = false;
        current = ChickenState.idle;

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
}