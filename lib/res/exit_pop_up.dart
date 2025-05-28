import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/primary_button.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_constant.dart';

Future<bool?> showBackDialog({
  required BuildContext context,
  String message = 'Are You Sure You want to Exit?',
  required VoidCallback yes,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          height: screenHeight * 0.2,
          decoration: BoxDecoration(
            color: ColorConstant.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              textWidget(text: message, fontSize: Dimensions.eighteen),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                      height: screenHeight * 0.05,
                      border: Border.all(color: ColorConstant.black),
                      color: ColorConstant.transparent,
                      onTap: yes,
                      width: screenWidth * 0.25,
                      label: 'Yes',
                      textColor: ColorConstant.black),
                  PrimaryButton(
                    height: screenHeight * 0.05,
                    color: ColorConstant.black,
                    width: screenWidth * 0.25,
                    label: 'No',
                    onTap: () {
                      HapticFeedback.vibrate();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
