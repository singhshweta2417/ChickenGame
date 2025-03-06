import 'package:flame/components.dart';

class ChickenDash extends SpriteAnimationComponent {
  ChickenDash()
      : super(
          position: Vector2(-280, 260),
          size: Vector2.all(200.0),
          anchor: Anchor.center,
        );

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _runAnimation;
  Vector2 _movementDirection = Vector2.zero();

  final double chickenSpeed = 80.0; // Pixels per second

  @override
  Future<void> onLoad() async {
    try {
      final List<Sprite> idleFrames = [];
      final List<Sprite> runFrames = [];

      // Load idle animation frames (chicken1.png to chicken30.png)
      for (var i = 1; i <= 30; i++) {
        try {
          final String imagePath = 'chickens/chicken$i.png';
          final sprite = await Sprite.load(imagePath);
          idleFrames.add(sprite);
        } catch (e) {
          print('Skipping invalid image: chickens/chicken$i.png - Error: $e');
        }
      }

      // Load run animation frames (chicken_run1.png to chicken_runN.png)
      for (var i = 1; i <= 4; i++) {
        try {
          final String imagePath = 'chickens/chicken_run$i.png';
          final sprite = await Sprite.load(imagePath);
          runFrames.add(sprite);
        } catch (e) {
          print(
              'Skipping invalid image: chickens/chicken_run$i.png - Error: $e');
        }
      }

      if (idleFrames.isNotEmpty) {
        _idleAnimation = SpriteAnimation.spriteList(idleFrames, stepTime: 0.03);
      } else {
        throw Exception('No idle frames loaded');
      }

      if (runFrames.isNotEmpty) {
        _runAnimation = SpriteAnimation.spriteList(runFrames, stepTime: 0.2);
      } else {
        throw Exception('No run frames loaded');
      }

      // Set initial animation to idle
      animation = _idleAnimation;
    } catch (e) {
      print('Failed to load chicken animations: $e');
    }
  }

  void moveInDirection(Vector2 direction) {
    _movementDirection = direction;
    if (direction != Vector2.zero()) {
      animation = _runAnimation; // Switch to run animation
    } else {
      animation = _idleAnimation; // Switch to idle animation
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _movementDirection * dt * chickenSpeed;
  }

  void stopMovement() {
    _movementDirection = Vector2.zero();
    animation = _idleAnimation; // Switch to idle animation
  }
}
