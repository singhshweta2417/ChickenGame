class MultiplierModel {
  bool? status;
  String? message;
  List<Data>? data;

  MultiplierModel({this.status, this.message, this.data});

  MultiplierModel.fromJson(Map<String, dynamic> json) {
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
  String? multiplier;
  int? type;
  String? createdAt;
  String? updated;

  Data({this.id, this.multiplier, this.type, this.createdAt, this.updated});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    multiplier = json['multiplier'];
    type = json['type'];
    createdAt = json['created_at'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['multiplier'] = multiplier;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated'] = updated;
    return data;
  }
}
