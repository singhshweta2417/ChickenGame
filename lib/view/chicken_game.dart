import 'package:chicken_game/view/components/chicken_dash.dart';
import 'package:chicken_game/view/components/chicken_parallex_background.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/coin.dart';
import 'components/fire.dart';

class ChickenGame extends FlameGame<ChickenGameWorld> {
  ChickenGame()
      : super(
          world: ChickenGameWorld(),//it serves as the container for the game's components. It is a fundamental part of managing the game’s entities, handling updates, rendering, and managing interactions.
          camera: CameraComponent.withFixedResolution(width: 800, height: 700),//yaha adjust the portion of the game for game view okay
        );

  void toggleBackgroundMovement() {
    world.toggleMovement();
  }
}

class ChickenGameWorld extends World {
  late final ChickenDashParallaxBackground background;
  late final ChickenDash chicken;
  bool isMoving = false;

  @override
  Future<void> onLoad() async {
    background = ChickenDashParallaxBackground(
      onCoinsReady: (List<Coin> coins) {
        chicken = ChickenDash(
          coinPositions: coins.map((coin) => coin.position).toList(),
          coins: coins,
        );
        add(chicken);
        final fire = FireDash(position: Vector2(400, 260)); // Match coin[0] position
        add(fire);
      },
    );
    add(background);
  }

  Future<void> toggleMovement() async {
    isMoving = !isMoving;
    if (isMoving) {
      background.parallax?.baseVelocity = Vector2(-50, 0);
      chicken.moveToNextPoint();
    } else {
      background.parallax?.baseVelocity = Vector2.zero();
    }
  }
}
