import 'dart:async';
import 'package:chicken_game/main.dart';
import 'package:flutter/material.dart';

class StoppedChicken extends StatefulWidget {
  const StoppedChicken({super.key});

  @override
  State<StoppedChicken> createState() => _StoppedChickenState();
}

class _StoppedChickenState extends State<StoppedChicken> {
  late final List<String> _framePaths;
  int _currentFrame = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateFramePaths();
    _startAnimation();
  }

  void _generateFramePaths() {
    _framePaths = List.generate(30, (index) {
      // Assuming Assets.imagesFire1 to Assets.imagesFire100 are all generated
      return 'assets/images/chickens/chicken${index + 1}.png'; // match your asset path
    });
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % _framePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth*0.2,
      height: screenHeight*0.05,
      decoration: BoxDecoration(
          // color: Colors.blue,
          image: DecorationImage(
              image:
                  AssetImage('assets/images/chickens/shivering_chicken.gif'),fit: BoxFit.cover)),
    );
  }
}
