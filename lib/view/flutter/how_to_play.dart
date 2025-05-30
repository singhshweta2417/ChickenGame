import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        height: screenHeight * 0.6,
        width: screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorConstant.footerBg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.clear, color: ColorConstant.white))),
            textWidget(
                text: 'How TO Play',
                fontSize: Dimensions.twenty,
                color: ColorConstant.white,
                fontWeight: FontWeight.w700),
            textWidget(
                text: '1. Specify the amount of your bet.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.center),
            textWidget(
                text: '2. Choose a difficulty level in game.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.center),
            textWidget(
                text:
                    'The number of manhole covers and the chance to be fried hard varies depending on the level of difficulty.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.start),
            textWidget(
                text: 'The game has 3 difficulty levels:',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.center),
            textWidget(
                text: '• The game has 3 difficulty levels:',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.center),
            textWidget(
                text:
                    '• Easy-there are 24 lines at this level. The probability of losing is 1 In 25 lines.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.start),
            textWidget(
                text:
                    '• Medium-there are 22 lines at this level. The probability of losing is 3 on 25 lines.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.start),
            textWidget(
                text:
                    '• Hard-there are 20 lines at this level. The probability of losing is 5 on 25 lines.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.start),
            textWidget(
                text: '3. Press "Play" button.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white),
            textWidget(
                text:
                    '4. Your goal is to get through as many manhole covers as possible without getting fried. You can withdraw your winnings at any stage of the game.',
                fontSize: Dimensions.thirteen,
                color: ColorConstant.white,
                textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }
}
