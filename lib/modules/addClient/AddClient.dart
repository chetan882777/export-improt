import 'dart:ffi';

import 'package:agro_worlds/modules/addClient/AddClientViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AddClient extends StatelessWidget {
  static final String ROUTE_NAME = "/AddClient";

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

    return ChangeNotifierProvider<AddClientViewModel>(
      create: (context) => AddClientViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Add a Client",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        endDrawer: AgroWorldsDrawer.drawer(
            context: context),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 8),
              child: Consumer(
                builder: (context, AddClientViewModel model, child) =>
                    SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Offstage(
                        offstage: model.isNameEntered,
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !model.isNameEntered,
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              model.name.isNotEmpty
                                  ? model.name[0].toUpperCase()
                                  : "A".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 56),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: DropdownButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              items: <String>[
                                'Business stage',
                                'Prospect',
                                "Client"
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                );
                              }).toList(),
                              value: 'Business stage',
                              onChanged: (val) {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      matForms.matEditable(
                        variable: "busienssName",
                        displayText: "Business name",
                        player: (val) {
                          model.setName(val);
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 70),
                        ]),
                      ),
                      matForms.matEditable(
                        variable: "firstName",
                        displayText: "First name",
                        player: () {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 40),
                        ]),
                      ),
                      matForms.matEditable(
                        variable: "lastName",
                        displayText: "Last name",
                        player: () {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 40),
                        ]),
                      ),
                      matForms.matEditable(
                        variable: "email",
                        displayText: "Email Address",
                        player: () {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 40),
                        ]),
                      ),
                      matForms.matEditable(
                        variable: "contact",
                        displayText: "Contact number",
                        player: () {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 40),
                        ]),
                      ),
                      matForms.matEditable(
                        variable: "addressLine1",
                        displayText: "Address (line 1)",
                        player: () {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.max(context, 40),
                        ]),
                      ),
                      SizedBox(height: 10,),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: matForms.elevatedBtn(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          displayText: "Submit",
                          player: () {
                            model.submit();
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, AddClientViewModel model, child) =>
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
}
