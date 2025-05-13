import 'package:chicken_game/res/app_constant.dart';
import 'package:chicken_game/view/flutter/chicken_home_screen.dart';
import 'package:chicken_game/view/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


double screenHeight = 0;
double screenWidth = 0;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstant.appName,
      // initialRoute: RoutesName.splash,
      // onGenerateRoute: (settings) {
      //   if (settings.name != null) {
      //     return MaterialPageRoute(
      //         builder: Routers.generateRoute(settings.name!),
      //         settings: settings);
      //   }
      //   return null;
      // },
      home:
      // ChickenHomeScreen()
      MainPage(),
    );
  }
}


