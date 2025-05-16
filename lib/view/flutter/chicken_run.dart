import 'dart:async';
import 'package:flutter/material.dart';

class ChickenRun extends StatefulWidget {
  final bool useGif; // Switch between GIF and frame-by-frame
  final double width;
  final double height;
  final BoxFit fit;

  const ChickenRun({
    super.key,
    this.useGif = true,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.fill,
  });

  @override
  State<ChickenRun> createState() => _ChickenRunState();
}

class _ChickenRunState extends State<ChickenRun> {
  late final List<String> _framePaths;
  int _currentFrame = 0;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    if (!widget.useGif) {
      _initializeFrameAnimation();
    }
  }

  void _initializeFrameAnimation() {
    _framePaths = List.generate(4, (index) {
      return 'assets/images/chickens/chicken_run${index + 1}.png';
    });
    _startAnimation();
  }

  void _startAnimation() {
    _animationTimer?.cancel(); // Cancel any existing timer
    _animationTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (mounted) {
        setState(() {
          _currentFrame = (_currentFrame + 1) % _framePaths.length;
        });
      }
    });
  }

  @override
  void didUpdateWidget(ChickenRun oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.useGif != widget.useGif && !widget.useGif) {
      _initializeFrameAnimation();
    } else if (!widget.useGif && _animationTimer == null) {
      _initializeFrameAnimation();
    } else if (widget.useGif) {
      _animationTimer?.cancel();
      _animationTimer = null;
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.useGif
          ? _buildGifAnimation()
          : _buildFrameAnimation(),
    );
  }

  Widget _buildGifAnimation() {
    return Image.asset(
      'assets/images/chicken_gif.gif',
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildFrameAnimation() {
    return Image.asset(
      _framePaths[_currentFrame],
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: const Icon(Icons.error_outline, color: Colors.red),
    );
  }
}