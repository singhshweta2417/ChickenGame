import 'dart:async';
import 'package:flutter/material.dart';

class BigFire extends StatefulWidget {
  const BigFire({super.key});

  @override
  State<BigFire> createState() => _BigFireState();
}

class _BigFireState extends State<BigFire> {
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
    _framePaths = List.generate(8, (index) {
      return 'assets/images/big_fire${index + 1}.png';
    });
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
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
        'assets/images/big_fire.gif',
        // _framePaths[_currentFrame],
        width: 150,
        height: 150,
        fit: BoxFit.fill,
      )
    );
  }
}
