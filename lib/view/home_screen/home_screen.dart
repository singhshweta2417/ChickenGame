import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/view/home_screen/footer_widget.dart';
import 'package:chicken_game/view/home_screen/header_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          SizedBox(height: height * 0.02),
          HeaderWidget(),
          Spacer(),
          Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.01),
              color: ColorConstant.textFieldBg,
              child: FooterWidget())
        ],
      ),
    );
  }
}
