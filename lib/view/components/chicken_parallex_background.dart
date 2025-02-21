import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:chicken_game/view/chicken_game.dart';

class ChickenDashParallaxBackground extends ParallaxComponent<ChickenGame> {
  bool isMoving = false; // Track whether the background is moving

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/background_image.png'),
      ],
      baseVelocity: Vector2.zero(), // Start with zero velocity
      velocityMultiplierDelta: Vector2(2, 0),
      fill: LayerFill.height,
    );
  }

  // Method to toggle the parallax velocity
  void toggleMovement() {
    if (isMoving) {
      parallax?.baseVelocity = Vector2.zero(); // Stop movement
    } else {
      parallax?.baseVelocity = Vector2(10, 0); // Start movement
    }
    isMoving = !isMoving; // Toggle the state
  }
}