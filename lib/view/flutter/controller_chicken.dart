import 'dart:async';
import 'dart:math';
import 'package:chicken_game/res/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../res/color_constant.dart';
import '../../res/text_widget.dart';
import '../../res/view_model/multiplier_view_model.dart';
import '../../res/view_model/win_loss_view_model.dart';
import '../welcome_chicken_screen.dart';

class ChickenController extends ChangeNotifier {
  // Game layout properties
  double _backgroundOffset = 0.0;

  // Game state properties
  final bool _hasReachedRed = false;
  bool _isScrolling = false;
  int _currentChickenIndex = -1;
  Set<int> flippedRedIndices = {};
  Set<int> fireIndices = {};
  Set<int> safeIndices = {};

  // Fire animation states
  bool _showBigFire = false;
  bool _showSmallFire = false;
  int? _currentFireIndex;
  bool hasUserPlacedBet = false;
  bool _isGameOver = false;

  // Game settings
  List<String> coinList = ['50', '100', '250', '500'];
  List<String> levelList = ['Easy', 'Medium', 'Hard'];
  String? selectedCoin;
  String? dropdownValue = 'Easy';

  // Timer
  late Timer _fireTimer;
  Random random = Random();

  // Constants
  static const Duration fireUpdateInterval = Duration(milliseconds: 500);
  static const Duration scrollDirection = Duration(milliseconds: 1500);
  static const Duration redDelay = Duration(milliseconds: 2000);
  static const Duration smallFireDirection = Duration(milliseconds: 800);
  static const Duration bigFireDuration = Duration(milliseconds: 300);

  void chickenControllerStart() {
    _startFireTimer();
    _generateFireIndices();
  }

  void placeBet() {
    hasUserPlacedBet = true;
    notifyListeners();
  }

  void resetBet() {
    hasUserPlacedBet = false;
    notifyListeners();
  }

  void _startFireTimer() {
    _fireTimer = Timer.periodic(fireUpdateInterval, (_) {
      print('fire updated continuously');
      _generateFireIndices();
      notifyListeners();
    });
  }

  void _generateFireIndices() {
    fireIndices.clear();

    // Ek hi index choose karo jo safe na ho
    int index;
    do {
      index = random.nextInt(10);
    } while (safeIndices.contains(index));

    fireIndices.add(index); // Bas ek hi index add hoga
  }

  void onButtonPressed(BuildContext context) {
    if (_isScrolling) return;
    if (selectedCoin == null) {
      _showMessage(context, message: 'Please select a coin amount first!');
      return;
    }
    _continueGame(context);
  }
  void _continueGame(BuildContext context) {
    final multiplierModel = Provider.of<MultiplierViewModel>(context, listen: false).multiplierModel;
    final multiplierData = multiplierModel.data?.data;
    final multiplierLength = multiplierData?.length ?? 0;

    if (_currentChickenIndex < multiplierLength) {
      _currentChickenIndex++;

      // Calculate container width based on whether it's the last index or not
      double containerWidth;
      if (_currentChickenIndex == multiplierLength) {
        // Last index (golden egg wall) has different width
        containerWidth = screenWidth * 0.5;
        print('this is movement');
      } else {
        // Regular red containers
        containerWidth = screenWidth * 0.4;
        print('this is ok');
      }

      _backgroundOffset -= containerWidth;
      _isScrolling = true;
      _resetFireAnimations();
      notifyListeners();

      Future.delayed(redDelay, () {
        _isScrolling = false;
        Provider.of<AuthViewModel>(context, listen: false).profileApi(context);
        // Check if we reached the last index
        if (_currentChickenIndex == multiplierLength) {
          _showWinDialog(context);
        } else {
          _checkForFire(context, _currentChickenIndex);
        }
      });
    }
  }
  // void _continueGame(BuildContext context) {
  //   final multiplierModel =
  //       Provider.of<MultiplierViewModel>(context,listen: false).multiplierModel;
  //   final multiplierData = multiplierModel.data?.data;
  //
  //   // Safely get the multiplier length or default to 0
  //   final multiplierLength = multiplierData?.length ?? 0;
  //
  //   // Determine if this is the last index
  //   final isLast =  multiplierLength + 1;
  //   if (_currentChickenIndex < multiplierLength) {
  //     _currentChickenIndex++;
  //
  //     // Calculate the offset based on the current container width
  //     double containerWidth = _currentChickenIndex == isLast
  //         ? screenWidth * 0.45
  //         : screenWidth * 0.3;
  //
  //     _backgroundOffset -= containerWidth + screenWidth * 0.05;
  //     _isScrolling = true;
  //     _resetFireAnimations();
  //     notifyListeners();
  //     Future.delayed(redDelay, () {
  //       _isScrolling = false;
  //       Provider.of<AuthViewModel>(context, listen: false).profileApi(context);
  //       // Check if we reached the last index
  //       if (_currentChickenIndex == multiplierLength) {
  //         _showWinDialog(context);
  //       } else {
  //         _checkForFire(context, _currentChickenIndex);
  //       }
  //     });
  //   }
  // }

  void _checkForFire(BuildContext context, int index) {
    if (_showSmallFire || _showBigFire) {
      return; // Agar fire already chal rahi hai to skip karo
    }

    if (fireIndices.contains(index)) {
      _triggerFireAnimation(context, index);
    } else {
      _safeMove(index);
    }
  }

  void _showWinDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              insetPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.35),
              backgroundColor: ColorConstant.grey.withValues(alpha: 0.4),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage('assets/images/party_pomper.gif'),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: screenHeight * 0.15,
                      width: screenWidth * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.imagesWinChicken),
                            fit: BoxFit.fill),
                      ),
                    ),
                    textWidget(
                        text: "You Win!",
                        color: ColorConstant.black,
                        fontSize: Dimensions.fifteen,
                        fontWeight: FontWeight.w700),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeChickenScreen()));
                      },
                      child: textWidget(
                          text: "Ok",
                          color: ColorConstant.black,
                          fontSize: Dimensions.fifteen,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            ));
  }

  void _triggerFireAnimation(BuildContext context, int index) {
    _currentFireIndex = index;
    _showSmallFire = true;
    _isGameOver = true; // Mark game as over immediately
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _showSmallFire = false;
      _showBigFire = true;
      notifyListeners();

      // Show big fire for 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        // Remove chicken and show blue container
        flippedRedIndices.add(index); // Mark this container as flipped
        _showBigFire = false; // Hide the big fire after 2 seconds
        notifyListeners();

        Provider.of<WinLossViewModel>(context, listen: false)
            .winLossApi(context);
        _showGameOverDialog(context);
      });
    });
  }

  void _safeMove(int index) {
    flippedRedIndices.add(index);
    fireIndices.remove(index);
    safeIndices.add(index);
    notifyListeners();
  }

  void _resetFireAnimations() {
    _showBigFire = false;
    _showSmallFire = false;
    _currentFireIndex = null;
  }

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
                            image: AssetImage(Assets.chickensChickenRoast),
                            fit: BoxFit.fill)),
                  ),
                  textWidget(
                      text: "Game Over!",
                      color: ColorConstant.white,
                      fontSize: Dimensions.fifteen,
                      fontWeight: FontWeight.w700),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeChickenScreen()));
                      // Navigator.of(context).pop();
                      // _restartGame();
                    },
                    child: textWidget(
                        text: "Ok",
                        color: ColorConstant.white,
                        fontSize: Dimensions.fifteen,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ));
  }

  @override
  void dispose() {
    _fireTimer.cancel();
    super.dispose();
  }

  // Getters
  double get backgroundOffset => _backgroundOffset;
  bool get isGameOver => _isGameOver;
  bool get hasReachedRed => _hasReachedRed;
  bool get isScrolling => _isScrolling;
  int get currentChickenIndex => _currentChickenIndex;
  bool get showBigFire => _showBigFire;
  bool get showSmallFire => _showSmallFire;
  int? get currentFireIndex => _currentFireIndex;
}

///
//  void _restartGame() {
//     _blackPosition = 50;
//     _backgroundOffset = 0.0;
//     _hasReachedRed = false;
//     _isScrolling = false;
//     _currentChickenIndex = 0;
//     _resetFireAnimations();
//     flippedRedIndices.clear();
//     fireIndices.clear();
//     safeIndices.clear();
//     _generateFireIndices();
//     notifyListeners();
//   }
