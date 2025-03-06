// // lib/view/components/interactive_elements_manager.dart
// import 'package:flame/components.dart';
// import 'package:flame/text.dart';
// import 'package:flutter/material.dart';
//
// import 'background_jail.dart';
// import 'base_background.dart';
// import 'coin.dart';
// import 'fire.dart';
//
// class InteractiveElementsManager {
//   final List<Coin> coins = [];
//   final List<BackgroundJailDash> jails = [];
//   final List<BaseBackGroundDash> baseSurfaces = [];
//   final List<FireDash> fireSurfaces = [];
//   final List<TextComponent> coinTexts = [];
//   static const double textOffsetY = -190;
//   void addElements(Vector2 position, Component parent) {
//     final jail = BackgroundJailDash(position: position + Vector2(-15, -120));
//     jails.add(jail);
//     parent.add(jail);
//
//     final coin = Coin(position: position);
//     coins.add(coin);
//     parent.add(coin);
//
//     final baseSurface = BaseBackGroundDash(position: position + Vector2(-8, 220));
//     baseSurfaces.add(baseSurface);
//     parent.add(baseSurface);
//
//     final fireSurface = FireDash(position: position + Vector2(100, 480));
//     fireSurfaces.add(fireSurface);
//     parent.add(fireSurface);
//
//     final text = TextComponent(
//       text: '${coins.length}',
//       position: position + Vector2(coin.size.x / 0.8, -textOffsetY),
//       anchor: Anchor.center,
//       textRenderer: TextPaint(
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 30,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//     coinTexts.add(text);
//     parent.add(text);
//   }
//
//   void removeOffscreenElements(double screenLeftEdge) {
//     _removeOffscreen(coins, screenLeftEdge);
//     _removeOffscreen(jails, screenLeftEdge);
//     _removeOffscreen(baseSurfaces, screenLeftEdge);
//     _removeOffscreen(fireSurfaces, screenLeftEdge);
//   }
//
//   void _removeOffscreen(List<PositionComponent> elements, double screenLeftEdge) {
//     for (int i = elements.length - 1; i >= 0; i--) {
//       if (elements[i].position.x + elements[i].size.x < screenLeftEdge) {
//         elements[i].removeFromParent();
//         elements.removeAt(i);
//       }
//     }
//   }
// }