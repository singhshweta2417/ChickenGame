import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/primary_button.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> coinList = ['50', '100', '250', '500'];
  List<String> levelList = ['Easy', 'Medium', 'Hard', 'HardCore'];
  String? selectedCoin;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.015, horizontal: width * 0.03),
      margin: EdgeInsets.symmetric(
          vertical: height * 0.015, horizontal: width * 0.03),
      height: height * 0.3,
      decoration: BoxDecoration(
        color: ColorConstant.footerBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 5),
            decoration: BoxDecoration(
              color: ColorConstant.headerBg,
              borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(
                  color: ColorConstant.black.withValues(alpha: 0.5),
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  height: height * 0.04,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    color: ColorConstant.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: textWidget(
                      text: 'MIN',
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.ten),
                ),
                textWidget(
                    text: selectedCoin ?? 'Amount', // Display selected coin or 'Amount'
                    fontSize: Dimensions.fifteen,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.white),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  height: height * 0.04,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    color: ColorConstant.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: textWidget(
                      text: 'MAX',
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.ten),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(coinList.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCoin = coinList[index];
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.01, vertical: height * 0.015),
                  height: height * 0.05,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    color: selectedCoin == coinList[index]
                        ? Colors.blue // Highlight selected coin
                        : ColorConstant.headerBg,
                    borderRadius: BorderRadius.circular(5),
                    border: Border(
                      bottom: BorderSide(
                        color: ColorConstant.black.withValues(alpha: 0.5),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                          text: coinList[index],
                          color: ColorConstant.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fifteen),
                      Icon(Icons.currency_rupee,
                          size: 15, color: ColorConstant.white),
                    ],
                  ),
                ),
              );
            }),
          ),
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 5),
            decoration: BoxDecoration(
              color: ColorConstant.headerBg,
              borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(
                  color: ColorConstant.black.withValues(alpha: 0.5),
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  height: height * 0.04,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    color: ColorConstant.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: textWidget(
                      text: 'MIN',
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.ten),
                ),
                // Dropdown Button
                PopupMenuButton<String>(
                    color:ColorConstant.grey,
                  icon: Icon(Icons.keyboard_arrow_down, color: ColorConstant.white),
                  onSelected: (String value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return levelList.map((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: textWidget(
                            text: value,
                            color: ColorConstant.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fifteen),
                      );
                    }).toList();
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  height: height * 0.04,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    color: ColorConstant.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: textWidget(
                      text: 'MAX',
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.ten),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          PrimaryButton(
            height: height * 0.05,
            label: 'Play',
          ),
        ],
      ),
    );
  }
}