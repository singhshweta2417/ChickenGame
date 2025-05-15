import 'dart:async';
import 'dart:math';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../welcome_chicken_screen.dart';

class ChickenController extends ChangeNotifier {
  double redContainerWidth = 100;
  double blueContainerWidth = 150;
  double _blackPosition = 50;
  double _backgroundOffset = 0.0;

  bool _hasReachedRed = false;
  bool _isScrolling = false;
  Random random = Random();
  int _currentChickenIndex = 0;
  Set<int> flippedRedIndices = {};
  Set<int> fireIndices = {};
  late Timer _fireTimer;
  Set<int> safeIndices = {};
  bool _showBigFire = false;

  List<String> coinList = ['50', '100', '250', '500'];
  List<String> levelList = ['Easy', 'Medium', 'Hard'];

  String? selectedCoin;
  String? dropdownValue;

  chickenControllerStart() {
    _startFireTimer();
    _generateFireIndices();
  }

  void _startFireTimer() {
    _fireTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _generateFireIndices();
      notifyListeners();
    });
  }

  void _generateFireIndices() {
    fireIndices.clear();
    Random random = Random();
    while (fireIndices.length < 5) {
      int index = random.nextInt(10);
      if (!safeIndices.contains(index)) {
        fireIndices.add(index);
      }
    }
  }

  void onButtonPressed(BuildContext context) {
    if (selectedCoin == null) {
      // User must select a coin before starting
      _showMessage(context, message: 'Please select a coin amount first!');
      return;
    }

    if (!_hasReachedRed) {
      // First time reaching the red container zone
      _blackPosition = blueContainerWidth + screenWidth * 0.08;
      _isScrolling = true;
      _showBigFire = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 5), () {
        _hasReachedRed = true;
        _currentChickenIndex = 0;
        _isScrolling = false;

        print(
            'Checking fireIndices at index $_currentChickenIndex: ${fireIndices.contains(_currentChickenIndex)}');

        if (fireIndices.contains(_currentChickenIndex)) {
          _showBigFire = true;
          notifyListeners();

          Future.delayed(const Duration(milliseconds: 500), () {
            _showGameOverDialog(context);
          });
        } else {
          flippedRedIndices.add(_currentChickenIndex);
          fireIndices.remove(_currentChickenIndex);
          safeIndices.add(_currentChickenIndex);
          notifyListeners();
        }
      });
    } else {
      // After first red, move to next chickens up to index 4
      if (_currentChickenIndex < 4) {
        _isScrolling = true;
        _currentChickenIndex++;
        _backgroundOffset -= redContainerWidth + screenWidth * 0.15;
        _showBigFire = false;
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 600), () {
          _isScrolling = false;

          print(
              'Checking fireIndices at index $_currentChickenIndex: ${fireIndices.contains(_currentChickenIndex)}');

          if (fireIndices.contains(_currentChickenIndex)) {
            _showBigFire = true;
            notifyListeners();

            Future.delayed(const Duration(milliseconds: 500), () {
              _showGameOverDialog(context);
            });
          } else {
            flippedRedIndices.add(_currentChickenIndex);
            fireIndices.remove(_currentChickenIndex);
            safeIndices.add(_currentChickenIndex);
            notifyListeners();
          }
        });
      }
    }
  }

  // Simple message display - replace with your own UI method
  void _showMessage(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showGameOverDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              insetPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.35),
              backgroundColor: ColorConstant.grey.withValues(alpha: 0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.chickensChickenRoast),fit: BoxFit.fill)),
                  ),
                  textWidget(
                      text: "Game Over!",
                      color: ColorConstant.white,
                      fontSize: Dimensions.fifteen,
                      fontWeight: FontWeight.w700),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeChickenScreen()));
                      // Navigator.of(context).pop();
                      // _restartGame();
                    },
                    child:textWidget(
                        text: "Ok",
                        color: ColorConstant.white,
                        fontSize: Dimensions.fifteen,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            )
        );
  }

  void _restartGame() {
    _blackPosition = 50;
    _backgroundOffset = 0.0;
    _hasReachedRed = false;
    _isScrolling = false;
    _currentChickenIndex = 0;
    _showBigFire = false;
    flippedRedIndices.clear();
    fireIndices.clear();
    safeIndices.clear();
    _generateFireIndices();
    notifyListeners();
  }

  @override
  void dispose() {
    _fireTimer.cancel();
    super.dispose();
  }

  // Getters for private variables
  double get blackPosition => _blackPosition;
  double get backgroundOffset => _backgroundOffset;
  bool get hasReachedRed => _hasReachedRed;
  bool get isScrolling => _isScrolling;
  int get currentChickenIndex => _currentChickenIndex;
  bool get showBigFire => _showBigFire;
}
