class AuthModel {
  bool? success;
  String? message;
  int? userId;
  String? email;
  String? phone;
  String? password;
  String? createdAt;
  String? updatedAt;

  AuthModel(
      {this.success,
        this.message,
        this.userId,
        this.email,
        this.phone,
        this.password,
        this.createdAt,
        this.updatedAt});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    userId = json['user_id'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['user_id'] = userId;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
