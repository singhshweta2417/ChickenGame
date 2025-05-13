// import 'dart:async' as dart_async;
//
// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';
//
// import '../view/components/background_door.dart';
// import '../view/components/background_jail.dart';
// import '../view/components/base_background.dart';
// import '../view/components/coin.dart';
// import '../view/components/fire.dart';
//
// class ChickenController extends ChangeNotifier{
//   bool isMoving = false;
//   final List<Coin> coins = [];
//   late final Function(List<Coin>) onCoinsReady;
//   final List<BackgroundJailDash> jails = [];
//   final List<BaseBackGroundDash> baseSurfaces = [];
//   final List<FireDash> fireSurfaces = [];
//   final List<TextComponent> coinTexts = [];
//   final List<Vector2> _originalFirePositions = [];
//   static const double coinSpacing = 100;
//   static const double coinStartX = 110;
//   static const int numberOfCoins = 10;
//   static Vector2 backgroundVelocity = Vector2(40, 0);
//   static const double textOffsetY = -190;
//   List<Vector2> get coinPositions =>
//       coins.map((coin) => coin.position.clone()).toList();
//   dart_async.Timer? _fireRepositionTimer;
//   late BackgroundDoorDash backgroundDoorDash;
//
//
// }