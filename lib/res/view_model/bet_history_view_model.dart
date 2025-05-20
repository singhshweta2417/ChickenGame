import 'package:flutter/foundation.dart';
import '../../helper/response/api_response.dart';
import '../model/bet_history_model.dart';
import '../repo/bet_history_repo.dart';

class BetHistoryViewModel with ChangeNotifier {
  final _betHistoryRepo = BetHistoryRepository();

  ApiResponse<HistoryBetModel> _betHistoryModel = ApiResponse.loading();

  ApiResponse<HistoryBetModel> get betHistoryModel => _betHistoryModel;

  void setBetHistoryModel(ApiResponse<HistoryBetModel> response) {
    if (_betHistoryModel != response) {
      _betHistoryModel = response;
      notifyListeners();
    }
  }

  Future<void> betHistoryApi(context) async {
    setBetHistoryModel(ApiResponse.loading());
    Map data = {"user_id": "1", "limit": "1", "offset": 0};
    _betHistoryRepo.betHistoryApi(data).then((value) {
      if (value.success == true) {
        setBetHistoryModel(ApiResponse.completed(value));
      } else {
        setBetHistoryModel(ApiResponse.completed(value));
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
