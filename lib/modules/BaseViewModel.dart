import 'package:flutter/cupertino.dart';

class BaseViewModel extends ChangeNotifier {
  bool busy = false;
  BuildContext context;

  BaseViewModel(this.context);

  setBusy(bool isBusy) {
    busy = isBusy;
    notifyListeners();
  }
}