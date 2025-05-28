import 'package:chicken_game/res/model/auth_model.dart';
import 'package:chicken_game/res/view_model/user_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../model/profile_model.dart';
import '../repo/auth_repo.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();

  ///Register
  bool _registerLoading = false;

  bool get registerLoading => _registerLoading;

  setRegisterLoading(bool value) {
    _registerLoading = value;
    notifyListeners();
  }

  Future<void> registerApi(
      dynamic email, dynamic phone, dynamic password, context) async {
    final userPref = Provider.of<UserViewModel>(context, listen: false);
    Map data = {"email": email, "phone": phone, "password": password};
    _authRepo.registerApi(data).then((value) {
      if (value["success"] == true) {
        userPref.saveUser(value['user_id'].toString());
        print('userId${value['user_id']}');
        setRegisterLoading(false);
        Navigator.pushReplacementNamed(
            context, RoutesName.welcomeChickenScreen);
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.green);
      } else {
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.red);
        if (kDebugMode) {
          print('value');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }

  ///Login
  bool _loginLoading = false;

  bool get loginLoading => _loginLoading;

  setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }
  AuthModel? _loginResponse;

  AuthModel? get loginResponse => _loginResponse;
  Future<void> loginApi(
      dynamic email, dynamic phone, dynamic password, context) async {
    final userPref = Provider.of<UserViewModel>(context, listen: false);
    Map data = {"mobile": phone, "password": password, "email": email};
    _authRepo.loginApi(data).then((value) {
      if (value.success == true && value.status==1) {
        print(value.success);
        print('jsbdbk');
        ShowMessage.show(context,
            message: value.message.toString(), boxColor: Colors.green);
        userPref.saveUser(value.userId.toString());
        print('userId${value.userId}');
        setRegisterLoading(false);
        Navigator.pushReplacementNamed(
            context, RoutesName.welcomeChickenScreen);

      } else {
        if (value.success == false) {
          ShowMessage.show(context,
              message: value.message.toString(), boxColor: Colors.red);
          Navigator.pushReplacementNamed(
              context, RoutesName.signUp);
      }}
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }

  ///Profile Update
  bool _updateLoading = false;

  bool get updateLoading => _updateLoading;

  setUpdateLoading(bool value) {
    _updateLoading = value;
    notifyListeners();
  }

  Future<void> updateProfileApi(dynamic name,
      dynamic email, dynamic phone,dynamic profileImage, context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    Map data = {
      "id":userId,
      "name":name,
      "email":email,
      "profile_image":profileImage
    };
    _authRepo.updateProfileApi(data).then((value) {
      if (value["status"] == true) {
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.green);
      } else {
        ShowMessage.show(context,
            message: value["message"].toString(), boxColor: Colors.red);
        if (kDebugMode) {
          print('value');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }



  ProfileModel? _userDetailsResponse;
  ProfileModel? get userDetailsResponse => _userDetailsResponse;
  setUserDetailsModel(ProfileModel shweta) {
    _userDetailsResponse = shweta;
    notifyListeners();
  }

  Future<void> profileApi(context) async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();
    _authRepo.profileApi(userId).then((value) {
      if (value["status"] == true) {
        final userDetails = ProfileModel.fromJson(value);
        setUserDetailsModel(userDetails);
      } else {
        if (kDebugMode) {
          print('value');
        }
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('error: $error');
      }
    });
  }

}
