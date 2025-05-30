import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import '../generated/assets.dart';
import '../res/exit.dart';
import '../utils/routes/routes_name.dart';

class WelcomeChickenScreen extends StatefulWidget {
  const WelcomeChickenScreen({super.key});

  @override
  State<WelcomeChickenScreen> createState() => _WelcomeChickenScreenState();
}

class _WelcomeChickenScreenState extends State<WelcomeChickenScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showBackDialog(
                context: context,
                yes: () {
                  HapticFeedback.vibrate();
                  SystemNavigator.pop();
                }) ??
            false;
        if (context.mounted && shouldPop) {
          HapticFeedback.vibrate();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          backgroundColor: ColorConstant.footerBg,
          body: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.imagesWelcomeBg),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.6),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RoutesName.chickenHomeScreen);
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Assets.imagesPlayButton))),
                    ),
                  ),
                  Spacer(),
                  Container(
                    color: Colors.red,
                    height: screenHeight * 0.03,
                    width: screenWidth,
                    child: Marquee(
                      text:
                          'Welcome to Chicken Road Game... This game is intended for entertainment purposes only. It is strictly for players aged 18 and above.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15,
                      ).merge(GoogleFonts.abyssinicaSil()),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 80.0,
                      velocity: 70.0,
                      pauseAfterRound: Duration(seconds: 1),
                      startPadding: 10.0,
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 300),
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ))),
    );
  }
}


