import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class BigFireAnimation extends SpriteAnimationComponent {
  BigFireAnimation({required Vector2 position})
      : super(position: position, size: Vector2(300, 300));

  @override
  Future<void> onLoad() async {
    try {
      final List<Sprite> frames = [];
      for (var i = 1; i <= 8; i++) {
        try {
          final sprite = await Sprite.load('big_fire$i.png');
          frames.add(sprite);
        } catch (e) {
          debugPrint('Failed to load big fire frame $i: $e');
        }
      }

      if (frames.isEmpty) {
        throw Exception('No valid frames loaded for big fire animation');
      }

      animation = SpriteAnimation.spriteList(
        frames,
        stepTime: 0.1, // Adjust animation speed
        loop: false, // Play once
      );

    } catch (e) {
      debugPrint('Failed to load big fire animation: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animationTicker != null && animationTicker!.done()) {
      removeFromParent();
    }
  }
}
