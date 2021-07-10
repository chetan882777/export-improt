
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/login/LoginScreen.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardViewModel extends BaseViewModel {
  late final FlowDataProvider flowDataProvider;
  late final MATForms matForms;
  DashboardViewModel(BuildContext context, this.matForms) : super(context) {
    flowDataProvider = Provider.of(context, listen: false);
    asyncInit();
  }

  void asyncInit() async {
    setBusy(true);
    String? userId = await SharedPrefUtils.getUserId();
    if(userId == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
    }
    await getUserData(userId!);
    setBusy(false);
  }

  Future<void> getUserData(String uId) async {
    try{
      var user = await ApiService.getUser();
      if(user.isError) {
        SharedPrefUtils.deleteUserId();
        Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
        return;
      }
      flowDataProvider.user = user;
    } catch(e) {
      SharedPrefUtils.deleteUserId();
      Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
    }
  }
}