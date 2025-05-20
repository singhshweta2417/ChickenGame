import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import '../flutter/slider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth,
      color: ColorConstant.headerBg,
      child: Row(
        children: [
          Image.asset(Assets.imagesGoldenEgg, height: screenHeight * 0.05),
          textWidget(
              text: 'CHICKEN\nROAD',
              fontSize: Dimensions.fifteen,
              color: ColorConstant.white,
              fontWeight: FontWeight.bold),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            width: screenWidth * 0.4,
            decoration: BoxDecoration(
                color: ColorConstant.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                    text: '0',
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.white),
                Icon(Icons.currency_rupee, size: 18, color: ColorConstant.white)
              ],
            ),
          ),
          // Builder(
          //   builder: (context) => IconButton(
          //     onPressed: () {
          //       Scaffold.of(context).openDrawer();
          //       print('bskjfd');
          //     },
          //     icon: Icon(
          //       Icons.menu,
          //       color: ColorConstant.white,
          //     ),
          //   ),
          // ),
          IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
                showDialog(
                    context: context, builder: (context) => SliderScreen());
              },
              icon: Icon(
                Icons.menu,
                color: ColorConstant.white,
              ))
        ],
      ),
    );
  }
}
