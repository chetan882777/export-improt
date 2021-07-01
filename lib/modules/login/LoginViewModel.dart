import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/login/LoginController.dart';
import 'package:agro_worlds/utils/Resource.dart';
import 'package:flutter/cupertino.dart';

class LoginViewModel extends BaseViewModel {

  static const String ERROR_MAINTENANCE = 'maintenance';
  static const String ERROR_NETWORK = 'network error';
  static const String ERROR_UNKNOWN = 'unknown error';
  static const String ERROR_MAINTENANCE_DESC_KEY = 'errorDesc';

  late final LoginController _controller;

  LoginViewModel(BuildContext context) : super(context) {
    _controller = LoginController();
  }

  Future<Resource> login(String phone) async{
    setBusy(true);
    var response = await _controller.login(phone);
    setBusy(false);
    print(response);
    Map<String, dynamic> result = json.decode(response);
    if(result["code"] == "400") {
      if(result["message"] == "Invalid request!")
        return Resource.error(ERROR_NETWORK, response);
      else
        return Resource.error(ERROR_UNKNOWN, response);
    }
    return Resource.success(response);
  }

}