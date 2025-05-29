class WinLossModel {
  bool? status;
  String? message;
  Data? data;

  WinLossModel({this.status, this.message, this.data});

  WinLossModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? gameId;
  int? userId;
  int? amount;
  int? multiplier;
  int? winAmount;
  String? status;

  Data(
      {this.gameId,
        this.userId,
        this.amount,
        this.multiplier,
        this.winAmount,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    userId = json['user_id'];
    amount = json['amount'];
    multiplier = json['multiplier'];
    winAmount = json['win_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['game_id'] = gameId;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['multiplier'] = multiplier;
    data['win_amount'] = winAmount;
    data['status'] = status;
    return data;
  }
}
