import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/login/LoginController.dart';
import 'package:agro_worlds/modules/otp/OtpScreen.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/Resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends BaseViewModel {

  static const String ERROR_MAINTENANCE = 'maintenance';
  static const String ERROR_NETWORK = 'network error';
  static const String ERROR_UNKNOWN = 'unknown error';
  static const String ERROR_MAINTENANCE_DESC_KEY = 'errorDesc';

  late final LoginController _controller;
  late final FlowDataProvider flowDataProvider;

  LoginViewModel(BuildContext context) : super(context) {
    flowDataProvider = Provider.of(context, listen: false);
    _controller = LoginController();
  }

  void login(String phone) async{
    print(" releaseLogs123 ====> login");
    setBusy(true);
    print(" releaseLogs123  ====> busy ");
    try {
      print(" releaseLogs123  ====> try");
      var response = await _controller.login(phone);
      print(" releaseLogs123  ====> respoonse");
      setBusy(false);
      print(response);
      Map<String, dynamic> result = json.decode(response);
      if (result["code"] == "400") {
        if (result["message"] == "Invalid request!")
          showToast("Invalid Phone number");
        else
          showToast("Network Error");
      }
      else if (result["code"] == "200") {
        flowDataProvider.otp = result["data"]["OTP"];
        flowDataProvider.phone = phone;
        showToast(result["message"]);
        Navigator.pushNamed(context, OtpScreen.ROUTE_NAME);
      } else {
        showToast("Something went Wrong!");
      }
    } catch (e) {
      print(" releaseLogs123  ===> error $e");
      showToast("Something went Wrong!");
    }
  }

}