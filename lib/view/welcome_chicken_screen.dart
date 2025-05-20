import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../res/exit.dart';
import '../res/view_model/user_view_model.dart';
import '../utils/routes/routes_name.dart';
import 'auth/profile_screen.dart';
import 'flutter/chicken_home_screen.dart';

class WelcomeChickenScreen extends StatelessWidget {
  const WelcomeChickenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 20,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(Assets.chickensChickenRoast),
            ),
          ),
        ),
        title: textWidget(text: 'Chicken Road Game'),
        actions: [
          IconButton(onPressed: (){
            showBackDialog(
              message: 'Are You Sure want to Exit?',
              context: context,
              yes: () {
                final userPref =
                Provider.of<UserViewModel>(context, listen: false);
                userPref.remove();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.login,
                      (Route<dynamic> route) => false,
                );
                SystemNavigator.pop();
                HapticFeedback.vibrate();
              },
            );
          }, icon: Icon(Icons.power_settings_new))
        ],
      ),
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
