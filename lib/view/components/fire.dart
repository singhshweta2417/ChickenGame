import 'package:flame/components.dart';

class FireDash extends SpriteAnimationComponent {
  FireDash({required Vector2 position})
      : super(
    position: position,
    size: Vector2(150, 80),
  );

  @override
  Future<void> onLoad() async {
    try {
      // Load individual frames
      final frames = [
        await Sprite.load('fire1.png'),
        await Sprite.load('fire2.png'),
        await Sprite.load('fire3.png'),
        await Sprite.load('fire4.png'),
        await Sprite.load('fire5.png'),
      ];

      // Create the SpriteAnimation from the frames
      animation = SpriteAnimation.spriteList(
        frames,
        stepTime: 0.1,
      );

      print('Fire animation loaded successfully');
    } catch (e) {
      print('Failed to load fire animation: $e');
    }
  }
}