import 'package:agro_worlds/modules/addClient/AddClient.dart';
import 'package:agro_worlds/modules/dashboard/DashboardViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static final String ROUTE_NAME = "/dashboard";

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

    return ChangeNotifierProvider<DashboardViewModel>(
      create: (context) => DashboardViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Dashboard",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => SystemNavigator.pop(),
          ),
        ),
        endDrawer: Consumer(builder: (context, DashboardViewModel model, child) => AgroWorldsDrawer.drawer(
            context: context),),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Consumer(
                builder: (context, DashboardViewModel model, child) =>
                    SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          infoWidget(
                              context: context,
                              largeText: "38",
                              smallText: "Prospects active",
                              bgColor: const Color(0xffaf8b46),
                              player: () {}),
                          infoWidget(
                              context: context,
                              largeText: "21",
                              smallText: "Meetings inline",
                              bgColor: const Color(0xffbd9b5b),
                              player: () {})
                        ],
                      ),
                      Row(
                        children: [
                          infoWidget(
                              context: context,
                              largeText: "20%",
                              smallText: "Conversion rate",
                              bgColor: const Color(0xffa07a30),
                              player: () {}),
                          infoWidget(
                              context: context,
                              largeText: "4",
                              smallText: "Deals this month",
                              bgColor: const Color(0xff91691a),
                              player: () {})
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, AddClient.ROUTE_NAME),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Add a client",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              IconButton(
                                iconSize: 36.0,
                                icon:
                                    Icon(Icons.person_add, color: Colors.white),
                                onPressed: () => Navigator.pushNamed(
                                    context, AddClient.ROUTE_NAME),
                              ),
                            ],
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: AssetImage(""),
                        //     fit: BoxFit.cover
                        //   )
                        // ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      belowClickWidgets(
                          context: context,
                          icon: CupertinoIcons.clock,
                          displayText: "Recent clients"),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        color: Color(0xffd6d6d6),
                      ),
                      belowClickWidgets(
                          context: context,
                          icon: CupertinoIcons.doc_chart,
                          displayText: "Activity logs"),
                      Container(
                        height: 1,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        color: Color(0xffd6d6d6),
                      ),
                      belowClickWidgets(
                          context: context,
                          icon: CupertinoIcons.rectangle_stack_person_crop,
                          displayText: "Meetings",
                          player: () {
                            print("meetings");
                          }),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, DashboardViewModel model, child) =>
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

  Widget belowClickWidgets(
      {required BuildContext context,
      required IconData icon,
      required String displayText,
      void Function()? player}) {
    return InkWell(
      onTap: player,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xff946d20),
              size: 32,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Icon(
              CupertinoIcons.right_chevron,
              color: Color(0xff946d20),
            )
          ],
        ),
      ),
    );
  }

  Widget infoWidget(
      {required BuildContext context,
      required String largeText,
      required String smallText,
      required Color bgColor,
      void Function()? player}) {
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(25, 20, 20, 20),
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: bgColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
          onTap: player,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                largeText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                smallText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
