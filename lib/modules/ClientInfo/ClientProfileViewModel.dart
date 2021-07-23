import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class ClientProfileViewModel extends BaseViewModel {
  MATForms matForms;

  Map<String, dynamic> clientDisplayData = {};
  List<dynamic> remarksList = [];

  ClientProfileViewModel(BuildContext context, this.matForms) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    if (flowDataProvider.currClientId == Constants.NA ||
        flowDataProvider.currClientId.isEmpty) {
      MATUtils.showAlertDialog(
          "Something went wrong with this client, please try again!",
          context,
          () => Navigator.pop(context));
    } else {
      setBusy(true);
      await getClientData();
      await getRemarksData();
      setBusy(false);
    }
  }
  
  Future<void> getClientData() async{
    Map<String, dynamic> client = await ApiService.getClient(flowDataProvider.currClientId);
    print(client);
    if(client.isNotEmpty) {
      if(client["code"] == "200") {
        flowDataProvider.currClient = client["data"];
        print("flow => ${flowDataProvider.currClient}");
        clientDisplayData = MATUtils.getClientDisplayInfo(flowDataProvider.currClient);
      } else if(client["code"] == "300"){
        showToast(client["message"]);
      } else {
        showToast("Something went Wrong!");
      }
    }
  }

  Future<void> getRemarksData() async {
    var id = await SharedPrefUtils.getUserId();
    var response = await ApiService.dio.post("profile/get_client_remarks", queryParameters: {
      "userId" : id,
      "clientId" : flowDataProvider.currClientId
    });
    if(response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      if(data["code"] == "200") {
        remarksList = data["data"];
      } else if(data["code"] == "300"){
        showToast(data["message"]);
      } else {
        showToast("Something went Wrong!");
      }
    }
  }
}
