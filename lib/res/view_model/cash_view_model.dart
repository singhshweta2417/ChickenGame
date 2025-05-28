import 'package:chicken_game/res/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../repo/cash_out_repo.dart';
import 'auth_view_model.dart';

class CashOutViewModel with ChangeNotifier {
  final _cashOutRepo = CashOutRepository();
  bool _cashOutLoading = false;

  bool get cashOutLoading => _cashOutLoading;

  setCashOutLoading(bool value) {
    _cashOutLoading = value;
    notifyListeners();
  }

  Future<void> cashOutApi(dynamic multiplierId, context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "multiplier_id": multiplierId,
      "game_id": "5",
      "userid": userId.toString()
    };
    _cashOutRepo.cashOutApi(data).then((value) {
      if (value["status"] == true) {
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
