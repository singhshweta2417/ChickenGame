import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/cupertino.dart';

class FireDash extends SpriteAnimationComponent with CollisionCallbacks {
  FireDash({required Vector2 position})
      : super(
          position: position,
          size: Vector2(150, 80),
        );

  @override
  Future<void> onLoad() async {
    // Add a hitbox for collision detection
    add(RectangleHitbox());

    try {
      final List<Sprite> frames = [];
      for (var i = 1; i <= 10; i++) {
        try {
          final String imagePath = 'fire$i.png';
          debugPrint('Loading image: $imagePath');

          // Check if the image exists before loading
          final sprite = await Sprite.load(imagePath);
          frames.add(sprite);

          debugPrint('Successfully loaded: $imagePath');
        } catch (e) {
          debugPrint('Skipping invalid image: fire$i.png - Error: $e');
        }
      }

      if (frames.isEmpty) {
        throw Exception('No valid frames loaded for fire animation');
      }

      // Create the SpriteAnimation from the frames
      animation = SpriteAnimation.spriteList(
        frames,
        stepTime: 0.08,
      );

      debugPrint('Fire animation loaded successfully');
    } catch (e) {
      debugPrint('Failed to load fire animation: $e');
    }
  }
}
