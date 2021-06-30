import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MATUtils {
  static Widget showLoader(
      {required BuildContext context,
        double size = 30.0,
        double opacity = 0.7,
        required bool isLoadingVar}) {
    return Visibility(
      visible: isLoadingVar,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(opacity),
        child: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
          size: size,
        ),
      ),
    );
  }

  static void showAlertDialog(
      String message, BuildContext context, Function()? callback) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: null,
          child: AlertDialog(
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                  textColor: Theme.of(context).copyWith().accentColor,
                  child: Text("Ok"),
                  onPressed: callback),
            ],
          ),
        );
      },
    );
  }

}