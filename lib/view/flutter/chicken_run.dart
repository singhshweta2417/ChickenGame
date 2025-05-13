import 'dart:async';
import 'package:flutter/material.dart';

class ChickenRun extends StatefulWidget {
  const ChickenRun({super.key});

  @override
  State<ChickenRun> createState() => _ChickenRunState();
}

class _ChickenRunState extends State<ChickenRun> {
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
    _framePaths = List.generate(4, (index) {//assets/images/chickens/chicken_run1.png
      // Assuming Assets.imagesFire1 to Assets.imagesFire100 are all generated
      return 'assets/images/chickens/chicken_run${index + 1}.png'; // match your asset path
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
    return Center(
      child: Image.asset(
        _framePaths[_currentFrame],
        width: 150,
        height: 150,
      ),
    );
  }
}
