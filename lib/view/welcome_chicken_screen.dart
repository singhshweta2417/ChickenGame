import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';

import '../generated/assets.dart';
import 'flutter/chicken_home_screen.dart';

class WelcomeChickenScreen extends StatelessWidget {
  const WelcomeChickenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.imagesChickenGif))),
          ),
          textWidget(text: 'Welcome to Chicken Road Game'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChickenHomeScreen()));
            },
            child: textWidget(text: 'Play'),
          )
        ],
      ),
    );
  }
}
