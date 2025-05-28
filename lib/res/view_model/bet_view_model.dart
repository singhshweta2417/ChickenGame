import 'package:chicken_game/res/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../repo/bet_repo.dart';
import 'auth_view_model.dart';

class BetViewModel with ChangeNotifier {
  final _betRepo = BetRepository();
  bool _betLoading = false;

  bool get betLoading => _betLoading;

  setBetLoading(bool value) {
    _betLoading = value;
    notifyListeners();
  }

  Future<void> betApi(dynamic amount, context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId.toString(), "game_id": 5, "amount": amount};
    _betRepo.betApi(data).then((value) {
      if (value["success"] == true) {
        final chicken =Provider.of<AuthViewModel>(context,listen: false);
        chicken.profileApi(context);
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.green);
      } else {
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.red);
        if (kDebugMode) {
          print('value');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }
}
