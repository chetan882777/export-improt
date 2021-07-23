import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddRemarkViewModel extends BaseViewModel {
  MATForms matForms;

  Map<String, dynamic> clientDisplayData = {};

  AddRemarkViewModel(BuildContext context, this.matForms) : super(context) {
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
      clientDisplayData =
          MATUtils.getClientDisplayInfo(flowDataProvider.currClient);
    }
  }
}
