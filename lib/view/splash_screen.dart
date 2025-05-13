import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    // splashServices.checkAuthentication(context);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesName.signUp);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: screenHeight * 0.25,
            width: screenWidth * 0.5,
            child: const Image(image: AssetImage(Assets.imagesChickenLogo))),
      ),
    );
  }
}
