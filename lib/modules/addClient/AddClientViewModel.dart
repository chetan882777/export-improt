import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/addClient/AddClientSuccess.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddClientViewModel extends BaseViewModel {
  bool isNameEntered = false;
  String name;
  List<String> clientTypes;
  String selectedClientType;
  MATForms matForms;
  bool isContactValid = false;

  AddClientViewModel(BuildContext context, this.matForms)
      : clientTypes = [],
        selectedClientType = 'Prospect',
        name = "",
        super(context) {
    if(flowDataProvider.user.userRole.toString().toLowerCase() == Constants.ROLE_BDE) {
      clientTypes = ['Prospect'];
    } else if (flowDataProvider.user.userRole.toString().toLowerCase() == Constants.ROLE_BDM) {
      clientTypes = ['Prospect', 'Potential'];
    }
  }


  void submit() async {
    if(!isContactValid) {
      showToast("Enter valid Contact");
      return;
    }
    if (matForms.dynamicFormKey.currentState != null) {
      try {
        setBusy(true);
        var formData = matForms.dynamicFormKey.currentState!.value;
        var reqData = Map();
        formData.forEach((key, value) {
          reqData[key] = value;
        });
        reqData.putIfAbsent("clientType", () {
          return clientTypes.firstWhere((element) =>
          element == selectedClientType);
        });
        String? id = await SharedPrefUtils.getUserId();
        reqData.putIfAbsent("id", () => id);
        print(reqData);

        await addClientApiCall(formData);

        setBusy(false);
      } catch(e) {
        setBusy(false);
      }
    }
  }

  void setSelectedClientType(val) {
    selectedClientType = val;
    notifyListeners();
  }

  void setName(String name) {
    bool shouldNotify = false;
    if ((this.name.isEmpty && name.isNotEmpty) ||
        (this.name.isNotEmpty && name.isEmpty)) shouldNotify = true;

    this.name = name;

    if (name.isNotEmpty)
      isNameEntered = true;
    else if (name.isEmpty) isNameEntered = false;
    if (shouldNotify) notifyListeners();
  }

  Future<void> addClientApiCall(Map<String, dynamic> formData) async {
    var response = await ApiService.dio.post("profile/add_client", queryParameters: formData);

    if(response.statusCode == 200) {
      var result = json.decode(response.data);
      if(result["code"] == "300")
        showToast(result["code"]);
      else if (result["code"] == "200")
        Navigator.pushReplacementNamed(context, AddClientSuccess.ROUTE_NAME);
      else
        showToast("Something went Wrong!");
    } else {
      showToast("Something went Wrong!");
    }
  }
}
