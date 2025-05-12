import 'package:flame/components.dart';

class BackgroundDoorDash extends SpriteComponent {
  BackgroundDoorDash({required Vector2 position})
      : super(position: position, size: Vector2(220, 700));

  @override
  Future<void> onLoad() async {
    try {
      print('Attempting to load background_door.png');
      sprite = await Sprite.load('background/background_door.png');
      print('Background door sprite loaded successfully');
    } catch (e) {
      print('Failed to load background door sprite: $e');
    }
  }
}
