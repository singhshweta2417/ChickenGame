import 'dart:ui';

import 'package:flame/components.dart';

class ChickenDash extends PositionComponent {
  ChickenDash()
      : super(
    position: Vector2(-230, 170), // Initial position
    size: Vector2.all(250.0),
    anchor: Anchor.center,
  );

  late Sprite _dashSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _dashSprite = await Sprite.load('hen_image.png');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(
      canvas,
      size: size,
    );
  }

  // Method to update the position
  void move(Vector2 newPosition) {
    position = newPosition;
  }
}