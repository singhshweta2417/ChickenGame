import 'package:chicken_game/utils/routes/routes_name.dart';
import 'package:chicken_game/view/auth/login_screen.dart';
import 'package:chicken_game/view/auth/sign_up_screen.dart';
import 'package:chicken_game/view/home_screen/home_screen.dart';
import 'package:chicken_game/view/splash_screen.dart';
import 'package:flutter/material.dart';

class Routers {
  static WidgetBuilder generateRoute(String routeName) {
    switch (routeName) {
      case RoutesName.splash:
        return (context) => const SplashScreen();
      case RoutesName.signUp:
        return (context) => const SignUpScreen();
      case RoutesName.login:
        return (context) => const LoginScreen();
      case RoutesName.homeScreen:
        return (context) => const HomeScreen();
      default:
        return (context) => const Scaffold(
              body: Center(
                child: Text(
                  'No Route Found!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            );
    }
  }
}
