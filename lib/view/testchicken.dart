// import 'package:chicken_game/generated/assets.dart';
// import 'package:flutter/material.dart';
//
// class HenWalking extends StatefulWidget {
//   const HenWalking({super.key});
//
//   @override
//   _HenWalkingState createState() => _HenWalkingState();
// }
//
// class _HenWalkingState extends State<HenWalking>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _animation = Tween<double>(begin: 0, end: 0.1).animate(_controller);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           left: 50,
//           top: 100,
//           child: AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, _animation.value * 20),
//                 child: Image.asset(Assets.imagesHenImage), // Change to your image path
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';

class DynamicPyramid extends StatelessWidget {
  final int levels = 5; // number of pyramid levels

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Pyramid')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(levels, (levelIndex) {
            int itemCount = levelIndex + 1; // 1 item in 1st row, 2 in 2nd, etc.
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(itemCount, (itemIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.primaries[itemIndex % Colors.primaries.length],
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
