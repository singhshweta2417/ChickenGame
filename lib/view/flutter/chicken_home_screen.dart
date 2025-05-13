import 'package:chicken_game/main.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Container(
          width: screenWidth,
            height: screenHeight*0.5,
            color: Colors.green,
            child: BackgroundChicken()),
      ),
    );
  }
}
