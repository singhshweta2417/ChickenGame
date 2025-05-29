import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../api_url.dart';

class WinLossRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> winLossApi(dynamic data) async {
    try {
      dynamic response =
      await _apiServices.getPostApiResponse(ApiUrl.winLossUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during winLossApi: $e');
      }
      rethrow;
    }
  }
}
