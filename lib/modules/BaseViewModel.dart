import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BaseViewModel extends ChangeNotifier {
  bool busy = false;
  BuildContext context;

  BaseViewModel(this.context);

  setBusy(bool isBusy) {
    busy = isBusy;
    notifyListeners();
  }

    void showToast(String msg) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white);
    }
}