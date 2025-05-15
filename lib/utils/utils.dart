import 'package:chicken_game/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../res/color_constant.dart';
import '../res/text_widget.dart';

class ShowMessage {
  static OverlayEntry? _currentOverlay;

  /// Show the animated overlay with the provided message and customizations
  static void show(
      BuildContext context, {
        required String message,
        Color boxColor = ColorConstant.green,
        double? width,
        double? height,
        Duration displayDuration = const Duration(seconds: 1),
        VoidCallback? onDismiss,
      }) {
    final overlay = Overlay.of(context);

    // Remove any existing overlay before adding a new one
    _currentOverlay?.remove();

    final overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedBox(
        message: message,
        boxColor: boxColor,
        width: width ?? 300,
        height: height ?? MediaQuery.of(context).size.height * 0.1,
        displayDuration: displayDuration,
        onDismiss: () {
          _currentOverlay?.remove();
          _currentOverlay = null;
        },
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);
  }
}

class _AnimatedBox extends StatefulWidget {
  final String message;
  final Color boxColor;
  final double width;
  final double height;
  final Duration displayDuration;
  final VoidCallback onDismiss;

  const _AnimatedBox({
    required this.message,
    required this.boxColor,
    required this.width,
    required this.height,
    required this.displayDuration,
    required this.onDismiss,
  });

  @override
  State<_AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<_AnimatedBox>
    with SingleTickerProviderStateMixin {
  final random = Random();
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late String displayText;

  double boxHeight = 0;
  double boxWidth = 200;
  Color boxColor = ColorConstant.grey;
  BorderRadius _borderRadius = BorderRadius.circular(8);
  double topPosition = -200; // Initial off-screen position

  @override
  void initState() {
    super.initState();
    displayText = widget.message;
    boxWidth = widget.width;
    boxHeight = widget.height;
    boxColor = widget.boxColor;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Create the animation to move the box down and then up
    _positionAnimation = Tween<double>(begin: -200, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // Start the slide-down animation

    Future.delayed(widget.displayDuration, () {
      // Trigger the slide-up animation after the display duration
      _controller.reverse();
      Future.delayed(const Duration(seconds: 1), widget.onDismiss);
    });
  }

  // Function to change the border radius to a random value
  void _changeRadius() {
    setState(() {
      _borderRadius = BorderRadius.circular(random.nextInt(50).toDouble());
    });
  }

  // Function to change the box size to random width and height
  void _changeBoxSize() {
    setState(() {
      boxWidth = random.nextInt(200).toDouble();
      boxHeight = random.nextInt(200).toDouble();
    });
  }

  // Function to change the text to "Bye Bye" and change the box size and border radius
  void _changeTextToByeBye() {
    _changeBoxSize();
    _changeRadius();
    setState(() {
      displayText = "Bye Bye 👋👋";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedPositioned(
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
          top: _positionAnimation.value,
          right: screenWidth * 0.05,
          left: screenWidth * 0.05,
          child: Material(
            type: MaterialType.transparency,
            child: AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              alignment: Alignment.center,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              height: boxHeight,
              width: boxWidth,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: _borderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(
                      text: displayText,
                      color: Colors.white,
                      fontSize: Dimensions.thirteen),
                  IconButton(
                    onPressed: () {
                      _changeTextToByeBye();
                      Future.delayed(
                          const Duration(seconds: 1), widget.onDismiss);
                      _controller.reverse();
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
