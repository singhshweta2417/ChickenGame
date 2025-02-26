import 'package:chicken_game/view/components/background_jail.dart';
import 'package:chicken_game/view/components/base_background.dart';
import 'package:chicken_game/view/components/coin.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/text.dart';
import 'package:chicken_game/view/chicken_game.dart';
import 'package:flutter/material.dart';

class ChickenDashParallaxBackground extends ParallaxComponent<ChickenGame> {

  /// Whether the background is currently moving.
  bool isMoving = false;

  /// List to store all coins in the game.
  final List<Coin> coins = [];
  final List<BackgroundJailDash> jails = [];
  final List<BaseBackGroundDash> baseSurfaces = [];
  /// List to store text components above coins.
  final List<TextComponent> coinTexts = [];

  /// Spacing between coins in a row.
  static const double coinSpacing = 100;

  /// Starting X position for the first coin in the row.
  static const double coinStartX = 110;

  /// Number of coins to add in a row.
  static const int numberOfCoins = 10;

  /// Base velocity of the parallax background when moving.
  static Vector2 backgroundVelocity = Vector2(20, 0);

  /// Vertical offset for the text above the coins.
  static const double textOffsetY = -190;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    try {
      // Load the parallax background
      parallax = await game.loadParallax([
        ParallaxImageData('background/background_image.png'),
      ],
          baseVelocity: Vector2.zero(),
          velocityMultiplierDelta: Vector2(2, 0),
          fill: LayerFill.height,
          repeat: ImageRepeat.repeat);

      // Add coins in a row sequence
      _addCoins();
    } catch (e) {
      debugPrint('Error loading parallax background or coins: $e');
    }
  }

  /// List to store all jail images in the game.

  void _addCoins() {
    final double startY = game.size.y / 6;
    for (int i = 0; i < numberOfCoins; i++) {
      final coinPosition = Vector2(
        coinStartX + i * coinSpacing,
        startY,
      );

      // Add jail image
      final jail = BackgroundJailDash(position: coinPosition + Vector2(-15, -120)); // Adjust the Y offset as needed
      jails.add(jail);
      add(jail);
      // Add coin
      final coin = Coin(position: coinPosition);
      coins.add(coin);
      add(coin);
      // Add baseSurface image
      final baseSurface = BaseBackGroundDash(position: coinPosition + Vector2(-8, 220)); // Adjust the Y offset as needed
      baseSurfaces.add(baseSurface);
      add(baseSurface);
      // Add text at a fixed position relative to the coin
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
      // Adjust text spacing
      const double textSpacing = 100;
      text.position.x += textSpacing * i;
      coinTexts.add(text);
      add(text);
    }
  }

  /// Toggles the background's movement.
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
        text.position.x -= backgroundVelocity.x * dt;
        coin.position.x -= backgroundVelocity.x / 2 * dt;
        jail.position.x -= backgroundVelocity.x / 2 * dt;
        baseSurface.position.x -= backgroundVelocity.x / 2 * dt;
      }
      _removeOffscreenCoins();
      _removeOffscreenBaseSurfaces();
      _removeOffscreenJails();

    }
  }

  /// Removes coins and their associated text that go off-screen.
  void _removeOffscreenCoins() {
    for (int i = coins.length - 1; i >= 0; i--) {
      final coin = coins[i];
      final text = coinTexts[i];
      if (coin.position.x / 2 + coin.size.x < 0) {
        remove(coin);
        remove(text);
        coins.removeAt(i);
        coinTexts.removeAt(i);
      }
    }
  }

  /// Removes jail images that go off-screen.
  void _removeOffscreenJails() {
    for (int i = jails.length - 1; i >= 0; i--) {
      final jail = jails[i];
      if (jail.position.x / 2 + jail.size.x < 0) {
        remove(jail);
        jails.removeAt(i);
      }
    }
  }
  /// Removes baseSurface images that go off-screen.
  void _removeOffscreenBaseSurfaces() {
    for (int i = baseSurfaces.length - 1; i >= 0; i--) {
      final baseSurface = baseSurfaces[i];
      if (baseSurface.position.x / 2 + baseSurface.size.x < 0) {
        remove(baseSurface);
        baseSurfaces.removeAt(i);
      }
    }
  }
}
