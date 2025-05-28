class AuthModel {
  bool? success;
  String? message;
  int? userId;
  int? status;
  String? name;
  String? email;
  String? phone;
  int? amount;
  String? password;
  String? createdAt;
  String? updatedAt;

  AuthModel(
      {this.success,
        this.message,
        this.userId,
        this.status,
        this.name,
        this.email,
        this.phone,
        this.amount,
        this.password,
        this.createdAt,
        this.updatedAt});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    userId = json['user_id'];
    status = json['status'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    amount = json['amount'];
    password = json['password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['user_id'] = userId;
    data['status'] = status;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['amount'] = amount;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
