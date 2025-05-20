import 'package:chicken_game/res/repo/multiplier_repo.dart';
import 'package:flutter/foundation.dart';
import '../../helper/response/api_response.dart';
import '../model/multiplier_model.dart';

class MultiplierViewModel with ChangeNotifier {
  final _multiplierRepo = MultiplierRepository();

  ApiResponse<MultiplierModel> _multiplierModel = ApiResponse.loading();

  ApiResponse<MultiplierModel> get multiplierModel => _multiplierModel;

  void setMultiplierModel(ApiResponse<MultiplierModel> response) {
    if (_multiplierModel != response) {
      _multiplierModel = response;
      notifyListeners();
    }
  }

  Future<void> multiplierApi(dynamic data, context) async {
    _multiplierRepo.multiplierApi(data).then((value) {
      if (value.status == true) {
        setMultiplierModel(ApiResponse.completed(value));
      } else {
        setMultiplierModel(ApiResponse.completed(value));
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
