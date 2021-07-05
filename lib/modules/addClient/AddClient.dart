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
            context: context, displayName: "Saksham Arora"),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(32),
              child: Consumer(
                builder: (context, AddClientViewModel model, child) => Column(
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
                              child: Image.asset(Constants.AGRO_HEADER_LOGO, fit: BoxFit.contain,),
                              alignment: Alignment.center,
                            ),
                            Align(
                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                              alignment: Alignment(0.65, 0.0),
                            ),
                          ],
                        )),
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
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
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
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              );
                            }).toList(),
                            value: 'Business stage',
                            onChanged: (_) {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    matForms.matEditable(
                      variable: "busienssName",
                      displayText: "Business name",
                      player: () {},
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.max(context, 70),
                      ]),
                    )
                  ],
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
