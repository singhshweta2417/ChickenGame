import 'package:chicken_game/res/app_constant.dart';
import 'package:chicken_game/view/flutter/controller_chicken.dart';
import 'package:chicken_game/view/welcome_chicken_screen.dart' show WelcomeChickenScreen;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ChickenController()),

          ],
      child: MaterialApp(
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
        home:WelcomeChickenScreen()
        // ChickenHomeScreen()
        // MainPage(),
      ),
    );
  }
}


