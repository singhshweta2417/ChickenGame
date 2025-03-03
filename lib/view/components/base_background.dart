import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BaseBackGroundDash extends PositionComponent {
  BaseBackGroundDash({required Vector2 position})
      : super(position: position, size: Vector2(170, 30));

  Sprite? sprite;

  @override
  Future<void> onLoad() async {
    try {
      sprite = await Sprite.load('base_fire_image.png');
      print('Background jail sprite loaded successfully');
    } catch (e) {
      print('Failed to load background base_fire_image sprite: $e');
    }
  }


  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      sprite!.render(canvas, position: position, size: size);
    } else {
      // Optionally, render a placeholder or debug message
      debugPrint('Background base_fire_image sprite is not loaded');
    }
  }
}
