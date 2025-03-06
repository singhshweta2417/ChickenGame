import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../chicken_game.dart';

class Coin extends SpriteComponent with HasGameRef<ChickenGame> {
  bool isGreen = false; // Track if the coin is green

  Coin({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    // Load the initial grey coin sprite
    sprite = await gameRef.loadSprite('coins/grey_coin.png');
    size = Vector2(50, 50); // Set the size of the coin
  }

  void flipToGreen() async {
    // Flip the coin horizontally
     flipHorizontallyAroundCenter();

    // Change the coin's appearance to green
    sprite = await gameRef.loadSprite('coins/green_coin.png');
    isGreen = true;
  }
}