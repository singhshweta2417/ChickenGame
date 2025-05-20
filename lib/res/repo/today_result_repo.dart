import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../api_url.dart';
import '../model/today_result_model.dart';

class TodayResultApiRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<TodayResultModel> todayResultApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(ApiUrl.todayResultUrl, data);
      return TodayResultModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during todayResultApi: $e');
      }
      rethrow;
    }
  }
}
