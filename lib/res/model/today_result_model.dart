class TodayResultModel {
  bool? status;
  String? message;
  List<Data>? data;

  TodayResultModel({this.status, this.message, this.data});

  TodayResultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? gameId;
  int? userId;
  int? amount;
  int? winAmount;
  int? multiplier;
  int? cashoutStatus;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.gameId,
        this.userId,
        this.amount,
        this.winAmount,
        this.multiplier,
        this.cashoutStatus,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameId = json['game_id'];
    userId = json['user_id'];
    amount = json['amount'];
    winAmount = json['win_amount'];
    multiplier = json['multiplier'];
    cashoutStatus = json['cashout_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['game_id'] = gameId;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['win_amount'] = winAmount;
    data['multiplier'] = multiplier;
    data['cashout_status'] = cashoutStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
