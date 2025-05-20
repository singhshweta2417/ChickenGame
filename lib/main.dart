import 'package:chicken_game/res/app_constant.dart';
import 'package:chicken_game/res/view_model/auth_view_model.dart';
import 'package:chicken_game/res/view_model/bet_history_view_model.dart';
import 'package:chicken_game/res/view_model/bet_view_model.dart';
import 'package:chicken_game/res/view_model/cash_view_model.dart';
import 'package:chicken_game/res/view_model/multiplier_view_model.dart';
import 'package:chicken_game/res/view_model/today_result_view_model.dart';
import 'package:chicken_game/res/view_model/user_view_model.dart';
import 'package:chicken_game/utils/routes/routes.dart';
import 'package:chicken_game/utils/routes/routes_name.dart';
import 'package:chicken_game/view/flutter/controller_chicken.dart';
import 'package:chicken_game/view/welcome_chicken_screen.dart'
    show WelcomeChickenScreen;
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
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ChickenController()),
        ChangeNotifierProvider(create: (context) => MultiplierViewModel()),
        ChangeNotifierProvider(create: (context) => BetViewModel()),
        ChangeNotifierProvider(create: (context) => CashOutViewModel()),
        ChangeNotifierProvider(create: (context) => BetHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => TodayResultViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstant.appName,
        initialRoute: RoutesName.splash,
        onGenerateRoute: (settings) {
          if (settings.name != null) {
            return MaterialPageRoute(
                builder: Routers.generateRoute(settings.name!),
                settings: settings);
          }
          return null;
        },
      ),
    );
  }
}
