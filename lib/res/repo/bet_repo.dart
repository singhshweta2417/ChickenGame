import 'package:flutter/foundation.dart';
import '../../helper/network/base_api_services.dart';
import '../../helper/network/network_api_services.dart';
import '../api_url.dart';

class BetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> betApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(ApiUrl.betUrl, data);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred during betApi: $e');
      }
      rethrow;
    }
  }
}
