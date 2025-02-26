import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BackgroundJailDash extends PositionComponent {
  BackgroundJailDash({required Vector2 position}) : super(position: position, size: Vector2(220, 700));

  Sprite? sprite;

  @override
  Future<void> onLoad() async {
    try {
      print('Attempting to load background_jail.png');
      sprite = await Sprite.load('front_jali.png');
      print('Background jail sprite loaded successfully');
    } catch (e) {
      print('Failed to load background jail sprite: $e');
    }
  }

  @override
  void render(Canvas canvas) {
    if (sprite != null) {
      sprite!.render(canvas, position: position, size: size);
    } else {
      // Optionally, render a placeholder or debug message
      debugPrint('Background jail sprite is not loaded');
    }
  }
}