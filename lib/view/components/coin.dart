import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Coin extends PositionComponent {
  Coin({required Vector2 position}) : super(position: position, size: Vector2.all(200));

  late Sprite sprite;

  @override
  Future<void> onLoad() async {
    try {
      sprite = await Sprite.load('grey_coin.png');
      print('Coin sprite loaded successfully');
    } catch (e) {
      print('Failed to load coin sprite: $e');
    }
  }

  @override
  void render(Canvas canvas) {
    sprite.render(canvas, position: position, size: size);
  }

}