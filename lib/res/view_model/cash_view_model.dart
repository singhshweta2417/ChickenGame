import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../repo/cash_out_repo.dart';

class CashOutViewModel with ChangeNotifier {
  final _cashOutRepo = CashOutRepository();
  bool _cashOutLoading = false;

  bool get cashOutLoading => _cashOutLoading;

  setCashOutLoading(bool value) {
    _cashOutLoading = value;
    notifyListeners();
  }

  Future<void> cashOutApi(dynamic multiplierId, context) async {
    Map data = {"multiplier_id": multiplierId, "game_id": "5", "userid": "1"};
    _cashOutRepo.cashOutApi(data).then((value) {
      if (value["success"] == true) {
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
