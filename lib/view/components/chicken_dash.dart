import 'dart:ui';
import 'package:flame/components.dart';

class ChickenDash extends PositionComponent {
  ChickenDash()
      : super(
    position: Vector2(-280, 260),
    size: Vector2.all(200.0),
    anchor: Anchor.center,
  );

  late Sprite _dashSprite;
  Vector2 _movementDirection = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _dashSprite = await Sprite.load('hen.gif');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(
      canvas,
      size: size,
    );
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
