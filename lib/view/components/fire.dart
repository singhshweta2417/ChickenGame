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
      final List<Sprite> frames = [];
      for (var i = 1; i <= 100; i++) {
        try {
          final String imagePath = 'fire$i.png';
          print('Loading image: $imagePath');

          // Check if the image exists before loading
          final sprite = await Sprite.load(imagePath);
          frames.add(sprite);

          print('Successfully loaded: $imagePath');
        } catch (e) {
          print('Skipping invalid image: fire$i.png - Error: $e');
        }
      }
      // Create the SpriteAnimation from the frames
      animation = SpriteAnimation.spriteList(
        frames,
        stepTime: 0.03,
      );

      print('Fire animation loaded successfully');
    } catch (e) {
      print('Failed to load fire animation: $e');
    }
  }
}
