import 'package:flame/components.dart';
import 'coin.dart';

enum ChickenState { idle, running }

class ChickenDash extends SpriteAnimationGroupComponent<ChickenState> {
  final List<Vector2> pathPoints;
  List<Coin> coins = [];

  ChickenDash({
    required List<Vector2> coinPositions,
    required this.coins,
  })  : pathPoints = coinPositions.isNotEmpty
            ? coinPositions.map((coin) => coin.clone()).toList()
            : [],
        super(
          position: coinPositions.isNotEmpty
              ? coinPositions.first.clone()
              : Vector2(-280, 260),
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
        _targetPosition = pathPoints[currentIndex];
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
      } catch (_) {}
    }
    if (frames.isEmpty) throw Exception('❌ No frames loaded for $basePath');
    return SpriteAnimation.spriteList(frames, stepTime: stepTime);
  }

  void moveToNextPoint() {
    if (!isMoving && currentIndex < pathPoints.length - 1) {
      currentIndex++;
      _targetPosition = pathPoints[currentIndex];
      isMoving = true;
      current = ChickenState.running;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isMoving) {
      final direction = (_targetPosition - position).normalized();
      position += direction * chickenSpeed * dt;

      if (position.distanceTo(_targetPosition) < 2.0) {
        position = _targetPosition;
        isMoving = false;
        current = ChickenState.idle;

        // ✅ Check and flip coins if near
        for (var coin in coins) {
          if (coin.position.distanceTo(position) < 10.0) {
            coin.flipCoin();
            print('🟡 Coin flipped at ${coin.position}!');
          }
        }
      }
    }
  }
}
