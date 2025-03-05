import 'package:chicken_game/view/components/chicken_dash.dart';
import 'package:chicken_game/view/components/chicken_parallex_background.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ChickenGame extends FlameGame<ChickenGameWorld> {
  ChickenGame()
      : super(
          world: ChickenGameWorld(),
          camera: CameraComponent.withFixedResolution(width: 800, height: 700),
        );

  void toggleBackgroundMovement() {
    world.background.toggleMovement();
  }
}


class ChickenGameWorld extends World {
  late final ChickenDashParallaxBackground background;
  late final ChickenDash chicken;

  @override
  Future<void> onLoad() async {
    // Initialize and add the background
    background = ChickenDashParallaxBackground();
    add(background);

    // Initialize and add the chicken
    chicken = ChickenDash();
    add(chicken);
  }
}
