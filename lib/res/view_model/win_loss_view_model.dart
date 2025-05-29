import 'package:chicken_game/res/model/win_loss_model.dart';
import 'package:chicken_game/res/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../repo/win_loss_repo.dart';

class WinLossViewModel with ChangeNotifier {
  final _winLossRepo = WinLossRepository();

  WinLossModel?_winLossModel;
  WinLossModel? get winLossModel => _winLossModel;

  void setMultiplierModel(WinLossModel response) {
    _winLossModel = response;
    notifyListeners();
    }

  Future<void> winLossApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {"user_id": userId.toString(), "game_id": 5, "status": "0"};
    _winLossRepo.winLossApi(data).then((value) {
      if (value["status"] == true) {
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.green);
        print('ihihib');
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
