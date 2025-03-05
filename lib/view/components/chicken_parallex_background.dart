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
    as dart_async;

class ChickenDashParallaxBackground extends ParallaxComponent<ChickenGame> {
  bool isMoving = false;
  int? targetCoinIndex; // Target coin index

  final List<Coin> coins = [];
  final List<BackgroundJailDash> jails = [];
  final List<BaseBackGroundDash> baseSurfaces = [];
  final List<FireDash> fireSurfaces = [];
  final List<TextComponent> coinTexts = [];
  final List<Vector2> _originalFirePositions = [];

  static const double coinSpacing = 100;
  static const double coinStartX = 110;
  static const int numberOfCoins = 10;
  static Vector2 backgroundVelocity = Vector2(20, 0);
  static const double textOffsetY = -190;

  dart_async.Timer? _fireRepositionTimer;

  // New variables for chicken movement
  Vector2? chickenTargetPosition;
  final double chickenSpeed = 100.0; // Pixels per second

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    try {
      parallax = await game.loadParallax(
        [ParallaxImageData('background/background_image.png')],
        baseVelocity: Vector2.zero(),
        velocityMultiplierDelta: Vector2(2, 0),
        fill: LayerFill.height,
        repeat: ImageRepeat.repeat,
      );
      _addCoins();
      _storeOriginalFirePositions();
      _hideAllFires();
      startFireRepositioning();
    } catch (e) {
      debugPrint('Error loading parallax background or coins: $e');
    }
  }

  void _addCoins() {
    final double startY = game.size.y / 6;
    for (int i = 0; i < numberOfCoins; i++) {
      final coinPosition = Vector2(coinStartX + i * coinSpacing, startY);

      final jail = BackgroundJailDash(position: coinPosition + Vector2(-15, -120));
      jails.add(jail);
      jail.priority = 1;
      add(jail);

      final coin = Coin(position: coinPosition);
      coins.add(coin);
      coin.priority = 2;
      add(coin);

      final baseSurface = BaseBackGroundDash(position: coinPosition + Vector2(-8, 220));
      baseSurfaces.add(baseSurface);
      baseSurface.priority = 3;
      add(baseSurface);

      final fireSurface = FireDash(position: coinPosition + Vector2(100, 480));
      fireSurfaces.add(fireSurface);
      fireSurface.priority = 4;
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
      text.priority = 5;
      add(text);
    }
  }

  void _storeOriginalFirePositions() {
    for (var fire in fireSurfaces) {
      _originalFirePositions.add(fire.position.clone());
    }
  }

  void _hideAllFires() {
    for (var fire in fireSurfaces) {
      fire.position = Vector2(-100, -100);
    }
  }

  void startFireRepositioning() {
    _fireRepositionTimer?.cancel();

    _showRandomFire();

    _fireRepositionTimer = dart_async.Timer.periodic(Duration(seconds: 1), (timer) {
      debugPrint("Fire repositioning triggered!");

      if (fireSurfaces.isEmpty) return;

      for (var fire in fireSurfaces) {
        fire.position = Vector2(-100, -100);
      }

      _showRandomFire();
    });
  }

  void _showRandomFire() {
    final Random random = Random();
    int randomIndex = random.nextInt(fireSurfaces.length);
    fireSurfaces[randomIndex].position = _getOriginalFirePosition(randomIndex);
  }

  Vector2 _getOriginalFirePosition(int index) {
    return _originalFirePositions[index];
  }
  // void toggleMovement() {
  //   isMoving = !isMoving;
  //   parallax?.baseVelocity = isMoving ? Vector2(20, 0) : Vector2.zero();
  // }
  void toggleMovement() {
    if (isMoving) {
      parallax?.baseVelocity = Vector2.zero();
      targetCoinIndex = null; // Reset target coin index when stopping
    } else {
      parallax?.baseVelocity = backgroundVelocity;
      targetCoinIndex = 0; // Set the target coin index to the first coin
    }
    isMoving = !isMoving;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final chicken = game.world.chicken;

    // Move the chicken towards the target coin
    if (targetCoinIndex != null && targetCoinIndex! < coins.length) {
      final targetCoin = coins[targetCoinIndex!];
      final direction = (targetCoin.position - chicken.position).normalized();
      final movement = direction * chickenSpeed * dt;

      if ((targetCoin.position - chicken.position).length > movement.length) {
        chicken.position += movement;
      } else {
        chicken.position = targetCoin.position;
        targetCoinIndex = null; // Stop moving once the target is reached
      }
    }

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
        fireSurface.position.x -= backgroundVelocity.x / 1 * dt;
        baseSurface.position.x -= backgroundVelocity.x / 2 * dt;

        debugPrint('Fire $i Position: ${fireSurface.position}, Priority: ${fireSurface.priority}');
        debugPrint('Jail $i Position: ${jail.position}, Priority: ${jail.priority}');
      }
      _removeOffscreenCoins();
      _removeOffscreenBaseSurfaces();
      _removeOffscreenJails();
      _removeOffscreenFireSurfaces();
    }

  }

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

  @override
  void onRemove() {
    _fireRepositionTimer?.cancel();
    _fireRepositionTimer = null;
    super.onRemove();
  }
}
