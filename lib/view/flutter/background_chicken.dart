import 'package:chicken_game/view/flutter/chicken_run.dart';
import 'package:chicken_game/view/flutter/sprite_image_of_chicken.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class BackgroundChicken extends StatefulWidget {
  const BackgroundChicken({super.key});

  @override
  State<BackgroundChicken> createState() => _BackgroundChickenState();
}

class _BackgroundChickenState extends State<BackgroundChicken>
    with SingleTickerProviderStateMixin {
  double redContainerWidth = 100;
  double blueContainerWidth = 200;
  double _blackPosition = 50; // Start in blue
  double _backgroundOffset = 0.0;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  bool _hasReachedRed = false;
  bool _isScrolling = false;

  // Store flipped red container indices
  Set<int> flippedRedIndices = {};

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    if (!_hasReachedRed) {
      // First tap: move black box to red[0]
      setState(() {
        _blackPosition = blueContainerWidth + 4;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _hasReachedRed = true;

          // Flip the red container at index 0
          int chickenIndex = 0;
          print(chickenIndex);
          print('chickenIndex');
          flippedRedIndices.add(chickenIndex);
          print(chickenIndex);
          print('chickenIndexsfas');
        });
      });
    } else {
      // Second tap and onwards: scroll background and flip based on new position
      setState(() {
        _isScrolling = true;
        _backgroundOffset -= 100;

        // Calculate current chicken index after scroll
        double chickenX = _blackPosition - _backgroundOffset - blueContainerWidth - 4;
        int chickenIndex = (chickenX / (redContainerWidth + 8)).floor();

        if (chickenIndex >= 0 && chickenIndex < 50) {
          flippedRedIndices.add(chickenIndex);
          print('snkfwnd${chickenIndex}');
        }
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _isScrolling = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background (scrollable blue and red containers)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 600),
          left: _backgroundOffset,
          top: 0,
          child: Row(
            children: [
              // Static blue area at start
              Container(
                width: blueContainerWidth,
                height: MediaQuery.of(context).size.height,
                color: Colors.blue,
              ),

              // Scrollable red containers using FlipCard
              Row(
                children: List.generate(50, (index) {
                  bool isFlipped = flippedRedIndices.contains(index);

                  return FlipCard(
                    flipOnTouch: false, // Disable flipping on tap
                    direction: FlipDirection.HORIZONTAL, // Flip horizontally
                    front: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: redContainerWidth,
                      height: 100,
                      margin: const EdgeInsets.all(4),
                      color: isFlipped ? Colors.blue : Colors.red,
                    ),
                    back: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: redContainerWidth,
                      height: 100,
                      margin: const EdgeInsets.all(4),
                      color: Colors.blue,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Chicken container with bounce
        AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              left: _blackPosition,
              top: 250 + _bounceAnimation.value,
              child: child!,
            );
          },
          child: Container(
            height: 100,
            width: 100,
            color: Colors.black,
            child: _isScrolling ? const ChickenRun() : const StoppedChicken(),
          ),
        ),

        // Press button
        Positioned(
          bottom: 5,
          left: 20,
          child: ElevatedButton(
            onPressed: _onButtonPressed,
            child: const Text("Press Me"),
          ),
        ),
      ],
    );
  }
}
