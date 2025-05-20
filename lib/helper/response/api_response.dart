import 'package:chicken_game/helper/response/status.dart';

class ApiResponse<T> {
  Success? success;
  T? data;
  String? message;

  ApiResponse(this.success, this.data, this.message);

  ApiResponse.loading() : success = Success.LOADING;

  ApiResponse.completed(this.data) : success = Success.COMPLETED;

  ApiResponse.error(this.message) : success = Success.ERROR;

  @override
  String toString() {
    return "Status : $success \n Message : $message \n Data : $data";
  }
}
