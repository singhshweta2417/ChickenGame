import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'fire.dart';

class Coin extends PositionComponent {
  Coin({required Vector2 position})
      : super(position: position, size: Vector2.all(150));

  late Sprite greySprite;
  late Sprite greenSprite;
  bool isCollected = false;
  FireDash? fire; // Reference to the FireDash component

  @override
  Future<void> onLoad() async {
    try {
      greySprite = await Sprite.load('grey_coin.png');
      greenSprite = await Sprite.load('green_coin.png');
      print('Coin sprites loaded successfully');
    } catch (e) {
      print('Failed to load coin sprites: $e');
    }
  }

  void setFire(FireDash fireComponent) {
    fire = fireComponent;
  }

  void flipCoin() {
    isCollected = true;
    if (fire != null) {
      fire!.removeFromParent(); // Remove the fire when the coin is flipped
      fire = null; // Clear the reference
    }
    print('🟡 Coin flipped and fire removed!');
  }

  @override
  void render(Canvas canvas) {
    (isCollected ? greenSprite : greySprite).render(canvas, position: position, size: size);
  }
}