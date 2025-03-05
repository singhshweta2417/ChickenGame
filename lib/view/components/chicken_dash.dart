import 'dart:ui';
import 'package:flame/components.dart';

class ChickenDash extends SpriteAnimationComponent {
  ChickenDash()
      : super(
          position: Vector2(-280, 260),
          size: Vector2.all(200.0),
          anchor: Anchor.center,
        );

  late Sprite _dashSprite;
  Vector2 _movementDirection = Vector2.zero();

  final bool _isLoaded = false;

  @override
  Future<void> onLoad() async {
    try {
      final List<Sprite> frames = [];

      for (var i = 1; i <= 30; i++) {
        try {
          final String imagePath = 'chickens/chicken$i.png';
          print('Loading image: $imagePath');

          // Check if the image exists before loading
          final sprite = await Sprite.load(imagePath);
          frames.add(sprite);

          print('Successfully loaded: $imagePath');
        } catch (e) {
          print('Skipping invalid image: chickens/chicken$i.png - Error: $e');
        }
      }

      if (frames.isNotEmpty) {
        animation = SpriteAnimation.spriteList(frames, stepTime: 0.03);
      }
    } catch (e) {
      print('Failed to load chicken animation: $e');
    }
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_isLoaded) {
      // Render only if _dashSprite is loaded
      _dashSprite.render(canvas, size: size);
    }
  }

  void moveInDirection(Vector2 direction) {
    _movementDirection = direction;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _movementDirection * dt * 200;
  }

  void stopMovement() {
    _movementDirection = Vector2.zero();
  }

}
