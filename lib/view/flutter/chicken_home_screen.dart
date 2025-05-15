import 'package:flutter/material.dart';
import '../../res/color_constant.dart';
import '../home_screen/header_widget.dart';
import 'background_chicken.dart';

class ChickenHomeScreen extends StatefulWidget {
  const ChickenHomeScreen({super.key});

  @override
  State<ChickenHomeScreen> createState() => _ChickenHomeScreenState();
}

class _ChickenHomeScreenState extends State<ChickenHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.fieldBg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HeaderWidget(),
          BackgroundChicken(),
          // FooterWidget()
        ],
      ),
    );
  }
}
