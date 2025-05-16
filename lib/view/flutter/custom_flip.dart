import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class CustomFlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Duration duration;
  final Function(AnimationController)? onControllerCreated;
  final VoidCallback? onTap;
  final bool animateFlip; // Add this to control automatic flipping
  final int index; // Add this to identify the card

  const CustomFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 1500),
    this.onControllerCreated,
    this.onTap,
    this.animateFlip = false, // Default to false
    this.index = 0, // Default index
  });

  @override
  State<CustomFlipCard> createState() => _CustomFlipCardState();
}

class _CustomFlipCardState extends State<CustomFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFlipped = false; // Track if the card is flipped

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    widget.onControllerCreated?.call(_controller);

    // Automatically flip the card if animateFlip is true
    if (widget.animateFlip) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _flipCard();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.isAnimating) return;
    if (_controller.isCompleted) {
      _controller.reverse();
      setState(() {
        isFlipped = false;
      });
    } else {
      if (mounted) {
        _controller.forward();
        setState(() {
          isFlipped = true;
        });
      }
    }
  }

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        _flipCard();
        SystemSound.play(SystemSoundType.click);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value;
          final isFront = angle <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront
                ? widget.front
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: widget.back,
            ),
          );
        },
      ),
    );
  }
}
