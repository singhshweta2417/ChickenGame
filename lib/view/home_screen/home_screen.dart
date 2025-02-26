import 'package:chicken_game/main.dart';
import 'package:chicken_game/view/home_screen/footer_widget.dart';
import 'package:chicken_game/view/home_screen/header_widget.dart';
import 'package:chicken_game/view/main_page.dart';
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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: height * 0.05),
          HeaderWidget(),
          SizedBox(height: height * 0.02),
          // SizedBox(
          //     height: height*0.45,
          //     child: MainPage()),
          SizedBox(height: height * 0.05),
          FooterWidget()
        ],
      ),
    );
  }
}
