import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../res/exit.dart';
import '../res/view_model/auth_view_model.dart';
import '../res/view_model/user_view_model.dart';
import '../utils/routes/routes_name.dart';
import 'auth/profile_screen.dart';
import 'flutter/chicken_home_screen.dart';

class WelcomeChickenScreen extends StatefulWidget {
  const WelcomeChickenScreen({super.key});

  @override
  State<WelcomeChickenScreen> createState() => _WelcomeChickenScreenState();
}

class _WelcomeChickenScreenState extends State<WelcomeChickenScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        final chicken = Provider.of<AuthViewModel>(context, listen: false);
        chicken.profileApi(context);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final chicken =
        Provider.of<AuthViewModel>(context).userDetailsResponse?.profile;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showBackDialog(
                context: context,
                yes: () {
                  HapticFeedback.vibrate();
                  SystemNavigator.pop();
                }) ??
            false;
        if (context.mounted && shouldPop) {
          HapticFeedback.vibrate();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 20,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(chicken?.profileImage != null
                      ? chicken!.profileImage.toString()
                      : Assets.chickensChickenRoast),
                ),
              ),
            ),
          ),
          title: textWidget(text: 'Chicken Road Game'),
          actions: [
            IconButton(
                onPressed: () {
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
                },
                icon: Icon(Icons.power_settings_new))
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChickenHomeScreen()));
              },
              child: textWidget(text: 'Play'),
            )
          ],
        ),
      ),
    );
  }
}
