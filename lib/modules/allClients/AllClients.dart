import 'package:agro_worlds/modules/ClientInfo/ClientProfile.dart';
import 'package:agro_worlds/modules/addProspect/AddProspect.dart';
import 'package:agro_worlds/modules/allClients/AllClientsViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AllClients extends StatelessWidget {
  static final String ROUTE_NAME = "/AllClients";

  final GlobalKey<FormBuilderState> dynamicFormKey =
      GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  late final MATForms matForms;

  final searchByNameController = TextEditingController();
  final searchByLocationController = TextEditingController();

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
            Navigator.pushNamed(context, AddProspect.ROUTE_NAME);
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
                                  player: () {
                                    showFilterBottomSheet(context);
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),
                              Text(
                                "Sort:",
                                style: TextStyle(
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.access_time,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Image.asset(
                                Constants.SORT_AZ_ICON,
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(height: 0.5, color: Colors.black12),
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              itemCount: model.clientsList.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                return clientListItem(context, model.clientsList[index], model);
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

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                          color: const Color(0xffd9dadb),
                          border: Border.all(
                              width: 1, color: const Color(0xffd9dadb)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Search by name",
                  style: TextStyle(
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      color: Colors.black),
                ),
                buildTextField("Enter here ..", searchByNameController),
                Text(
                  "Search by location",
                  style: TextStyle(
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      color: Colors.black),
                ),
                buildTextField("Enter state/city", searchByLocationController),
                Text(
                  "Search by stage",
                  style: TextStyle(
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                matForms.borderedDropDown(
                    borderColor: Colors.black54,
                    borderRadius: 8,
                    fontWeight: FontWeight.normal,
                    items: ["Prospect", "Potentials"],
                    displayValue: "Prospect",
                    player: (val) {}),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: double.infinity,
                  child: matForms.elevatedBtn(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      displayText: "Filter",
                      player: () {}),
                )
              ],
            ),
          );
        });
  }

  Widget buildTextField(String labelText, TextEditingController listener) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
      child: SizedBox(
        height: 48,
        child: TextField(
          keyboardType: TextInputType.name,
          controller: listener,
          style: TextStyle(color: Color(0xff313136)),
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  Widget clientListItem(BuildContext context, Map<String, dynamic> data, AllClientsViewModel model) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black,
                child: Text(
                  data["name"].toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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
                    data["name"].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    data["address"].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    data["clientStatus"].toString(),
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
            InkWell(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                if (await canLaunch('tel:${data["contact"]}')) {
                await launch('tel:${data["contact"]}');
                } else {
                  model.showToast("Failed to call ${data["contact"]}");
                }
              },
            ),
            SizedBox(
              width: 16,
            ),
            InkWell(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.chevron_right, color: Colors.white),
              ),
              onTap: () {
                model.flowDataProvider.currClientId = data["id"];
                Navigator.pushNamed(context, ClientProfile.ROUTE_NAME);
              },
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