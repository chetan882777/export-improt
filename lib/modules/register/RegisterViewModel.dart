import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterViewModel extends BaseViewModel {

  MATForms matForms;

  RegisterViewModel(BuildContext context, this.matForms) : super(context) {
    name = "";
  }

  bool isNameEntered = false;
  late String name;

  void submit() {
    if(matForms.dynamicFormKey.currentState != null) {
      var formData = matForms.dynamicFormKey.currentState!.value;
      var reqData = Map();
      formData.forEach((key, value) {
        reqData[key] = value;
      });
      reqData.putIfAbsent("image", () => "");
    }
  }

  void setName(String name) {
    bool shouldNotify = false;
    if((this.name.isEmpty && name.isNotEmpty) || (this.name.isNotEmpty && name.isEmpty))
      shouldNotify = true;

    this.name = name;

    if(name.isNotEmpty)
      isNameEntered = true;
    else if(name.isEmpty)
      isNameEntered = false;
    if(shouldNotify)
      notifyListeners();
  }
}