import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/login/LoginController.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class OtpViewModel extends BaseViewModel {
  late final FlowDataProvider flowDataProvider;
  late final MATForms matForms;
  bool enableResendOtp = true;
  late Color resendOtpTextColor = Theme.of(context).accentColor;

  late final LoginController _controller;

  OtpViewModel(BuildContext context, this.matForms) : super(context) {
    flowDataProvider = Provider.of(context, listen: false);
    _controller = LoginController();
  }

  void resendOtp() {
    showToast("Sending OTP Again");
    enableResendOtp = false;
    resendOtpTextColor = Colors.grey;
    notifyListeners();
    reLogin();
  }

  void reLogin() async{
    try {
      var response = await _controller.login(flowDataProvider.phone);
      print(response);
      Map<String, dynamic> result = json.decode(response);
      if (result["code"] == "200") {
        flowDataProvider.otp = result["data"]["OTP"];
      } else {
        showToast("Something went Wrong while resending OTP!");
      }
    } catch (e) {
      showToast("Something went Wrong while resending OTP!");
    }
  }


  void submit(String otp) {
    if(otp == flowDataProvider.otp) {
      print("Success");
    }
  }
}