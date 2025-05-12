import 'package:chicken_game/view/components/chicken_dash.dart';
import 'package:chicken_game/view/components/chicken_parallex_background.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/coin.dart';

class ChickenGame extends FlameGame<ChickenGameWorld> {
  ChickenGame()
      : super(
          world: ChickenGameWorld(),
          camera: CameraComponent.withFixedResolution(width: 800, height: 700),
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
