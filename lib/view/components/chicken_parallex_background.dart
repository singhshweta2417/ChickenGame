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

  /// List to store text components above coins.
  final List<TextComponent> coinTexts = [];

  /// Spacing between coins in a row.
  static const double coinSpacing = 130;

  /// Starting X position for the first coin in the row.
  static const double coinStartX = 160;

  /// Number of coins to add in a row.
  static const int numberOfCoins = 10;

  /// Base velocity of the parallax background when moving.
  static Vector2 backgroundVelocity = Vector2(15, 0);

  /// Vertical offset for the text above the coins.
  static const double textOffsetY = 170; // Adjusted to position text slightly below

  /// Horizontal spacing between the coin and its text.
  static const double textSpacingX = -130; // Added horizontal spacing

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    try {
      // Load the parallax background
      parallax = await game.loadParallax(
        [
          ParallaxImageData('background/background_image.png'),
        ],
        baseVelocity: Vector2.zero(),
        velocityMultiplierDelta: Vector2(2, 0),
        fill: LayerFill.height,
        repeat: ImageRepeat.repeatX,
      );

      // Add coins in a row sequence
      _addCoins();
    } catch (e) {
      debugPrint('Error loading parallax background or coins: $e');
    }
  }

  /// Adds a sequence of coins in a row with consistent spacing.
  void _addCoins() {
    final double startY = game.size.y / 8;
    for (int i = 0; i < numberOfCoins; i++) {
      final position = Vector2(
        coinStartX + i * coinSpacing,
        startY,
      );

      // Add coin
      final coin = Coin(position: position);
      coins.add(coin);
      add(coin);

      final text = TextComponent(
        text: 'Coin ${i + 1}',
        position: Vector2(
          position.x - textSpacingX * (i+1.7),
          position.y + textOffsetY,
        ),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
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
    // Move coins and their associated text at the same speed as the background
    if (isMoving) {
      for (int i = 0; i < coins.length; i++) {
        final coin = coins[i];
        final text = coinTexts[i];

        // Move coin
        coin.position.x -= backgroundVelocity.x * dt;

        // Move text to stay slightly below and to the left of the coin
        text.position.x = coin.position.x - textSpacingX* (i+1.7);
      }

      // Remove coins and their associated text that go off-screen
      _removeOffscreenCoins();
    }
  }

  /// Removes coins and their associated text that go off-screen.
  void _removeOffscreenCoins() {
    for (int i = coins.length - 1; i >= 0; i--) {
      final coin = coins[i];
      final text = coinTexts[i];

      if (coin.position.x + coin.size.x < 0) {
        // Remove coin and its text from the component tree
        remove(coin);
        remove(text);

        // Remove from the lists
        coins.removeAt(i);
        coinTexts.removeAt(i);
      }
    }
  }

}