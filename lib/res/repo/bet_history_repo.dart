import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../api_url.dart';
import '../model/bet_history_model.dart';

class BetHistoryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<HistoryBetModel> betHistoryApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(ApiUrl.betHistoryUrl, data);
      return HistoryBetModel.fromJson(response);
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during betHistoryApi: $e');
      }
      rethrow;
    }
  }
}
