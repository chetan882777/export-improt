import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/addClient/AddClientSuccess.dart';
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
    if (matForms.dynamicFormKey.currentState != null) {
      var formData = matForms.dynamicFormKey.currentState!.value;
      var reqData = Map();
      formData.forEach((key, value) {
        reqData[key] = value;
      });
      reqData.putIfAbsent("clientType", ()
      {
        return clientTypes.firstWhere((element) => element == selectedClientType);
      });
      String? id = await SharedPrefUtils.getUserId();
      reqData.putIfAbsent("id", () => id);
      print(reqData);
      Navigator.pushReplacementNamed(context, AddClientSuccess.ROUTE_NAME);
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
}
