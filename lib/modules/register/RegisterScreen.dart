import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/modules/register/RegisterViewModel.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static final String ROUTE_NAME = "/register";

  final GlobalKey<FormBuilderState> dynamicFormKey =
      GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  late final MATForms matForms;

  @override
  Widget build(BuildContext context) {
    matForms = MATForms(
        context: context,
        dynamicFormKey: dynamicFormKey,
        mapper: mapper,
        saveController: saveVariable);
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Register",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Align(
                                child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 2,
                                      color: Theme.of(context).primaryColor)),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            )),
                            Align(
                              child: InkWell(
                                onTap: () {

                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              alignment: Alignment(0.65, 0.0),
                            ),
                          ],
                        )),
                    matForms.matEditable(
                      variable: "first_name",
                      displayText: "First Name",
                      player: (val) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.max(context, 70),
                      ]),
                    ),
                    matForms.matEditable(
                      variable: "last_name",
                      displayText: "Last Name",
                      player: (val) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.max(context, 70),
                      ]),
                    ),
                    matForms.matEditable(
                      variable: "email_address",
                      displayText: "Email Address",
                      player: (val) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.max(context, 70),
                      ]),
                    ),
                    matForms.matEditable(
                      variable: "contact",
                      displayText: "Contact",
                      player: (val) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.max(context, 70),
                      ]),
                    ),
                    matForms.matEditable(
                      variable: "department",
                      displayText: "Department",
                      player: (val) {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.max(context, 70),
                      ]),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 70.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: matForms.elevatedBtn(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            displayText: "Submit",
                            player: () {
                              print(" ==== Submit");
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer(
              builder: (context, RegisterViewModel model, child) =>
                  MATUtils.showLoader(
                context: context,
                isLoadingVar: false,
                size: 20,
                opacity: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
