import 'package:agro_worlds/modules/addClient/AddClientViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddClient extends StatelessWidget {
  static final String ROUTE_NAME = "/AddClient";

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.all(10),
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
                              child: Image.asset(Constants.AGRO_HEADER_LOGO),
                              alignment: Alignment.center,
                            ),
                            Align(
                              child: Icon(Icons.edit, color: Theme.of(context).primaryColor,),
                              alignment: Alignment(0.65, 0.0),
                            ),
                          ],
                        )),
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
