import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/Resource.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'LoginViewModel.dart';

class LoginScreen extends StatelessWidget {
  final phoneNumberController = TextEditingController();
  late BuildContext _ctx;

  Future<void> _login(LoginViewModel model) async {
    Map<String, dynamic> loginDetails = {
      "phoneNumber": phoneNumberController.text
    };

    Resource resource = await model.login(loginDetails);

    switch (resource.status) {
      case Status.SUCCESS:
        Navigator.pushReplacement(
            _ctx, MaterialPageRoute(builder: (context) => Text("")));
        break;
      case Status.ERROR:
        _failedLogin(resource);
        break;
    }
  }

  void _failedLogin(Resource resource) {
    switch (resource.message) {
      case LoginViewModel.ERROR_MAINTENANCE:
        MATUtils.showAlertDialog(
            resource.data, _ctx, () => Navigator.pop(_ctx));
        break;
      case LoginViewModel.ERROR_NETWORK:
        showToast('Network Error');
        break;
      case LoginViewModel.ERROR_UNKNOWN:
        showToast('Incorrect Credentials');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                Image.asset(
                  Constants.AGRO_HEADER_LOGO,
                  colorBlendMode: BlendMode.color,
                ),
                Spacer(
                  flex: 1,
                ),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        buildTextField("text", "Phone number", phoneNumberController),
                        SizedBox(
                          width: double.infinity,
                          height: 70.0,
                          child: Consumer(
                            builder: (context, LoginViewModel model, child) =>
                                Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).accentColor),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(
                                            color: Colors.black38,
                                            fontSize: 20)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)))),
                                child: progressButton(model.busy),
                                onPressed: () {
                                  if (phoneNumberController.text.length != 10) {
                                    if (!model.busy) {
                                      _login(model);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Required fields are missing!",
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        TextButton(onPressed: () {
                          print(" Register here");
                        }, child: Text("Register here", style: TextStyle(color: Colors.black, fontSize: 20),))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Consumer(
              builder: (context, LoginViewModel model, child) =>
                  MATUtils.showLoader(
                context: context,
                isLoadingVar: model.busy,
                size: 20,
                opacity: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String type, String labelText, TextEditingController listener) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Consumer(
          builder: (context, LoginViewModel model, child) => TextField(
            controller: listener,
            style: TextStyle(fontSize: 20.0, color: Color(0xff313136)),
            cursorColor: Theme.of(context).accentColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: labelText,
              hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            obscureText: false,
          ),
        ),
    );
  }

  Widget progressButton(bool busy) {
    if (busy) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Text("LOGIN");
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(_ctx).accentColor,
        textColor: Colors.white);
  }
}
