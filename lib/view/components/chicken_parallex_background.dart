import 'dart:math';

import 'package:chicken_game/view/components/background_jail.dart';
import 'package:chicken_game/view/components/base_background.dart';
import 'package:chicken_game/view/components/coin.dart';
import 'package:chicken_game/view/components/fire.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/text.dart';
import 'package:chicken_game/view/chicken_game.dart';
import 'package:flutter/material.dart';
import 'dart:async'
    as dart_async; // Ensures we use dart_async.Timer instead of Flame's Timer

class ChickenDashParallaxBackground extends ParallaxComponent<ChickenGame> {
  /// Whether the background is currently moving.
  bool isMoving = false;

  /// Lists to store game elements.
  final List<Coin> coins = [];
  final List<BackgroundJailDash> jails = [];
  final List<BaseBackGroundDash> baseSurfaces = [];
  final List<FireDash> fireSurfaces = [];
  final List<TextComponent> coinTexts = [];

  /// Spacing between coins in a row.
  static const double coinSpacing = 100;
  static const double coinStartX = 110;
  static const int numberOfCoins = 10;

  /// Background velocity.
  static Vector2 backgroundVelocity = Vector2(20, 0);
  static const double textOffsetY = -190;

  /// Timer for repositioning fire surfaces.
  dart_async.Timer? _fireRepositionTimer;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    try {
      // Load the parallax background
      parallax = await game.loadParallax(
        [ParallaxImageData('background/background_image.png')],
        baseVelocity: Vector2.zero(),
        velocityMultiplierDelta: Vector2(2, 0),
        fill: LayerFill.height,
        repeat: ImageRepeat.repeat,
      );

      // Add game elements
      _addCoins();
      startFireRepositioning();
    } catch (e) {
      debugPrint('Error loading parallax background or coins: $e');
    }
  }

  /// Adds coins, jails, fire, and text.
  void _addCoins() {
    final double startY = game.size.y / 6;
    for (int i = 0; i < numberOfCoins; i++) {
      final coinPosition = Vector2(coinStartX + i * coinSpacing, startY);

      final jail =
          BackgroundJailDash(position: coinPosition + Vector2(-15, -120));
      jails.add(jail);
      add(jail);

      final coin = Coin(position: coinPosition);
      coins.add(coin);
      add(coin);

      final baseSurface =
          BaseBackGroundDash(position: coinPosition + Vector2(-8, 220));
      baseSurfaces.add(baseSurface);
      add(baseSurface);

      final fireSurface = FireDash(position: coinPosition + Vector2(100, 480));
      fireSurfaces.add(fireSurface);
      add(fireSurface);

      final text = TextComponent(
        text: '${i + 1}',
        position: coinPosition + Vector2(coin.size.x / 0.8, -textOffsetY),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      const double textSpacing = 100;
      text.position.x += textSpacing * i;
      fireSurface.position.x += textSpacing * i;
      coinTexts.add(text);
      add(text);
    }
  }

  /// Toggles background movement.
  void toggleMovement() {
    if (isMoving) {
      parallax?.baseVelocity = Vector2.zero();
    } else {
      parallax?.baseVelocity = backgroundVelocity;
    }
    isMoving = !isMoving;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      for (int i = 0; i < coins.length; i++) {
        final coin = coins[i];
        final text = coinTexts[i];
        final jail = jails[i];
        final baseSurface = baseSurfaces[i];
        final fireSurface = fireSurfaces[i];

        text.position.x -= backgroundVelocity.x * dt;
        coin.position.x -= backgroundVelocity.x / 2 * dt;
        jail.position.x -= backgroundVelocity.x / 2 * dt;
        baseSurface.position.x -= backgroundVelocity.x / 2 * dt;
        fireSurface.position.x -= backgroundVelocity.x / 2 * dt;
      }
      _removeOffscreenCoins();
      _removeOffscreenBaseSurfaces();
      _removeOffscreenJails();
      _removeOffscreenFireSurfaces();
    }
  }

  /// Removes off-screen elements.
  void _removeOffscreenCoins() {
    for (int i = coins.length - 1; i >= 0; i--) {
      if (coins[i].position.x / 2 + coins[i].size.x < 0) {
        remove(coins[i]);
        remove(coinTexts[i]);
        coins.removeAt(i);
        coinTexts.removeAt(i);
      }
    }
  }

  void _removeOffscreenJails() {
    for (int i = jails.length - 1; i >= 0; i--) {
      if (jails[i].position.x / 2 + jails[i].size.x < 0) {
        remove(jails[i]);
        jails.removeAt(i);
      }
    }
  }

  void _removeOffscreenBaseSurfaces() {
    for (int i = baseSurfaces.length - 1; i >= 0; i--) {
      if (baseSurfaces[i].position.x / 2 + baseSurfaces[i].size.x < 0) {
        remove(baseSurfaces[i]);
        baseSurfaces.removeAt(i);
      }
    }
  }

  void _removeOffscreenFireSurfaces() {
    for (int i = fireSurfaces.length - 1; i >= 0; i--) {
      if (fireSurfaces[i].position.x / 2 + fireSurfaces[i].size.x < 0) {
        remove(fireSurfaces[i]);
        fireSurfaces.removeAt(i);
      }
    }
  }

  Vector2 _generateRandomFirePosition() {
    final Random random = Random();
    double randomX =
        random.nextDouble() * game.size.x; // Anywhere within the screen width
    double randomY = 200 + random.nextDouble() * 150; // Between Y=300 and Y=450

    return Vector2(randomX, randomY);
  }

  /// **Handles the fire repositioning timer**
  void startFireRepositioning() {
    _fireRepositionTimer?.cancel(); // Cancel existing timer if any

    _fireRepositionTimer =
        dart_async.Timer.periodic(Duration(seconds: 2), (timer) {
      debugPrint("Fire repositioning triggered!");

      if (fireSurfaces.isEmpty) return;

      // Hide all fires first
      for (var fire in fireSurfaces) {
        fire.position = Vector2(-100, -100); // Move them off-screen
      }

      // Select a random fire index
      final Random random = Random();
      int randomIndex = random.nextInt(fireSurfaces.length);

      // Set position of only the selected fire
      fireSurfaces[randomIndex].position = _generateRandomFirePosition();
    });
  }

  /// **Stops and cleans up the timer when component is removed**
  @override
  void onRemove() {
    _fireRepositionTimer?.cancel();
    _fireRepositionTimer = null;
    super.onRemove();
  }
}
