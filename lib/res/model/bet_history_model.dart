class HistoryBetModel {
  bool? success;
  String? message;
  int? totalCount;
  List<Data>? data;

  HistoryBetModel({this.success, this.message, this.totalCount, this.data});

  HistoryBetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalCount = json['total_count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['total_count'] = totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? amount;
  int? winAmount;
  dynamic multiplier;
  String? createdAt;

  Data({this.amount, this.winAmount, this.multiplier, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    winAmount = json['win_amount'];
    multiplier = json['multiplier'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['win_amount'] = winAmount;
    data['multiplier'] = multiplier;
    data['created_at'] = createdAt;
    return data;
  }
}
