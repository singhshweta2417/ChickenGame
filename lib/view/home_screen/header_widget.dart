import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.07,
      width: width,
      color: ColorConstant.headerBg,
      child: Row(
        children: [
          Image.asset(Assets.imagesGoldenEgg, height: height * 0.05),
          textWidget(
              text: 'CHICKEN\nROAD',
              fontSize: Dimensions.fifteen,
              color: ColorConstant.white,
              fontWeight: FontWeight.bold),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            width: width * 0.4,
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
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
                color: ColorConstant.white,
              ))
        ],
      ),
    );
  }
}
