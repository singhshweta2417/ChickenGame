import 'dart:async';
import 'package:flutter/material.dart';

class FireGif extends StatefulWidget {
  const FireGif({super.key});

  @override
  State<FireGif> createState() => _FireGifState();
}

class _FireGifState extends State<FireGif> {
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
      return 'assets/images/fire${index + 1}.png'; // match your asset path
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
        'assets/images/small_fire.gif',
        // _framePaths[_currentFrame],
        width: 150,
        height: 150,
      ),
    );
  }
}
