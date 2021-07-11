import 'package:agro_worlds/modules/addClient/AddClient.dart';
import 'package:agro_worlds/modules/addClient/AddClientViewModel.dart';
import 'package:agro_worlds/modules/allClients/AllClientsViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AllClients extends StatelessWidget {
  static final String ROUTE_NAME = "/AllClients";

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

    return ChangeNotifierProvider<AllClientsViewModel>(
      create: (context) => AllClientsViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "All Clients",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddClient.ROUTE_NAME);
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Colors.white,
        ),
        endDrawer: AgroWorldsDrawer.drawer(context: context),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0),
              child: Consumer(
                  builder: (context, AllClientsViewModel model, child) =>
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 48,
                                child: matForms.matOutlineButton(
                                  leading: Icon(Icons.tune_rounded,
                                      color: Colors.black54),
                                  textColor: Colors.black54,
                                  borderColor: Colors.black54,
                                  displayText: "Filter",
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  player: () {},
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Row(
                                    children: [],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              itemCount: 15,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return clientListItem(context);
                              },
                            ),
                          )
                        ],
                      )),
            ),
            Consumer(
              builder: (context, AllClientsViewModel model, child) =>
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

  Widget clientListItem(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.black,
                child: Text(
                  "A",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "N S Enterprises",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Sunil Grover, Lucknow",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Prospect",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 16,
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.call,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.chevron_right, color: Colors.white),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          height: .25,
          color: Colors.black54,
        )
      ],
    );
  }
}
