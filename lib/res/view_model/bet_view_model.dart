import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../repo/bet_repo.dart';

class BetViewModel with ChangeNotifier {
  final _betRepo = BetRepository();
  bool _betLoading = false;

  bool get betLoading => _betLoading;

  setBetLoading(bool value) {
    _betLoading = value;
    notifyListeners();
  }

  Future<void> betApi(dynamic amount, context) async {
    Map data = {"user_id": 1, "game_id": 5, "amount": amount};
    print('$data: amount aa ra');
    _betRepo.betApi(data).then((value) {
      if (value["success"] == true) {
        ShowMessage.show(context, message: value["message"].toString(),boxColor: Colors.green);
      } else {
        ShowMessage.show(context, message: value["message"].toString(),boxColor: Colors.red);
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
