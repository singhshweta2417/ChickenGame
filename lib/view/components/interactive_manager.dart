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
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';


class ScrollingBackground extends StatefulWidget {
  const ScrollingBackground({super.key});

  @override
  State<ScrollingBackground> createState() => _ScrollingBackgroundState();
}

class _ScrollingBackgroundState extends State<ScrollingBackground>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _offset = 0.0;
  final double _speed = 50.0; // Pixels per second
  late double screenWidth;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _offset -= _speed / 80; // Approx. 60 FPS
      if (_offset <= -screenWidth) {
        _offset += screenWidth;
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // First background image
          Transform.translate(
            offset: Offset(_offset, 0),
            child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){

              return Center(
                child: Text('dfbjk${index+1}'),
              );
            }),
          ),
        ],
      ),
    );
  }
}

