import 'package:flutter/foundation.dart';
import '../../helper/response/api_response.dart';
import '../model/today_result_model.dart';
import '../repo/today_result_repo.dart';

class TodayResultViewModel with ChangeNotifier {
  final _todayResultRepo = TodayResultApiRepository();

  ApiResponse<TodayResultModel> _todayResultModel = ApiResponse.loading();

  ApiResponse<TodayResultModel> get todayResultModel => _todayResultModel;

  void setTodayResultModelModel(ApiResponse<TodayResultModel> response) {
    if (_todayResultModel != response) {
      _todayResultModel = response;
      notifyListeners();
    }
  }

  Future<void> todayResultApi(context) async {
    setTodayResultModelModel(ApiResponse.loading());
    Map data={
      "game_id":"6",
      "userid":"1"
    };
    _todayResultRepo.todayResultApi(data).then((value) {
      if (value.status == true) {
        setTodayResultModelModel(ApiResponse.completed(value));
      } else {
        setTodayResultModelModel(ApiResponse.completed(value));
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
