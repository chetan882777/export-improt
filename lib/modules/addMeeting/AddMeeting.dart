import 'package:agro_worlds/modules/addMeeting/AddMeetingViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AddMeeting extends StatelessWidget {
  static final String ROUTE_NAME = "/AddMeeting";

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

    return ChangeNotifierProvider<AddMeetingViewModel>(
      create: (context) => AddMeetingViewModel(context, matForms),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Add a meeting",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        endDrawer: AgroWorldsDrawer.drawer(context: context),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0),
              child: SingleChildScrollView(
                child: Consumer(
                  builder: (context, AddMeetingViewModel model, child) =>
                      Column(
                    children: [
                      clientInfoWidget(
                          context,
                          model.clientDisplayData,
                          model),
                      SizedBox(
                        height: 8,
                      ),
                      matForms.matEditable(
                        variable: "meetingTitle",
                        displayText: "Meeting title",
                        validator: FormBuilderValidators.compose([]),
                      ),
                      matForms.matDatePicker(
                        variable: "date",
                        displayText: "Meeting date",
                        lastDate: DateTime.now(),
                        player: (val) {},
                        validator: FormBuilderValidators.compose([]),
                      ),
                      matForms.matDatePicker(
                        variable: "time",
                        displayText: "Meeting time",
                        inputType: InputType.time,
                        lastDate: DateTime.now(),
                        player: (val) {},
                        validator: FormBuilderValidators.compose([]),
                      ),
                      matForms.matEditable(
                        variable: "place",
                        displayText: "Meeting place",
                        validator: FormBuilderValidators.compose([]),
                      ),
                      matForms.matEditable(
                        variable: "address",
                        displayText: "Meeting address",
                        validator: FormBuilderValidators.compose([]),
                      ),
                      matForms.matEditable(
                        variable: "agenda",
                        displayText: "Meeting agenda",
                        validator: FormBuilderValidators.compose([]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: matForms.elevatedBtn(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          displayText: "Submit",
                          player: () {
                            if (dynamicFormKey.currentState!
                                .saveAndValidate()) {
                            } else {
                              model.showToast("Fill up all valid data");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, AddMeetingViewModel model, child) =>
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

  Widget clientInfoWidget(BuildContext context, Map<String, dynamic> data,
      AddMeetingViewModel model) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).primaryColor,
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.black,
                child: Text(
                  data["name"].toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
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
                      fontSize: Constants.FONT_SIZE_BIG_TEXT,
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
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    data["clientStatus"].toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
