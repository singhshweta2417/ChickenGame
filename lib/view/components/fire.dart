import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class FireDash extends SpriteAnimationComponent with CollisionCallbacks {
  FireDash({required Vector2 position})
      : super(position: position, size: Vector2(150, 80));

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()); // Hit Box for collision detection

    // Load fire animation frames
    final List<Sprite> frames = [];
    for (var i = 1; i <= 10; i++) {
      final String imagePath = 'fire$i.png';
      final sprite = await Sprite.load(imagePath);
      frames.add(sprite);
    }

    // Create the animation
    animation = SpriteAnimation.spriteList(frames, stepTime: 0.5);
  }


}
