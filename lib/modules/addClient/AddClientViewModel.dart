import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddClientViewModel extends BaseViewModel {

  bool isNameEntered = false;
  late String name;

  AddClientViewModel(BuildContext context) : super(context) {
    name = "";
  }

  void submit() async {}

  void setName(String name) {
    bool shouldNotify = false;
    if ((this.name.isEmpty && name.isNotEmpty) ||
        (this.name.isNotEmpty && name.isEmpty))
      shouldNotify = true;

    this.name = name;

    if (name.isNotEmpty)
      isNameEntered = true;
    else if (name.isEmpty)
      isNameEntered = false;
    if (shouldNotify)
      notifyListeners();
  }

}