import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class ClientProfileViewModel extends BaseViewModel {
  MATForms matForms;

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
      Map<String, dynamic> client = await ApiService.getClient(flowDataProvider.currClientId);
      print(client);
      if(client.isNotEmpty) {
        if(client["code"] == "200") {
          flowDataProvider.currClient = client["data"];
          print("flow => ${flowDataProvider.currClient}");
        } else if(client["code"] == "300"){
          showToast(client["message"]);
        } else {
          showToast("Something went Wrong!");
        }
      }
      setBusy(false);
    }
  }
}
