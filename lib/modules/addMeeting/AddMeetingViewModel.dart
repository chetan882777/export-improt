import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddMeetingViewModel extends BaseViewModel {
  MATForms matForms;

  Map<String, dynamic> clientDisplayData = {};


  List<String> meetingModeNameList;
  String selectedMeetingMode;

  List<String> meetingStatusNameList = [ "Scheduled", "Delayed", "Cancelled", "Completed"];
  String selectedMeetingStatus = "Scheduled";
  bool showMeetingStatus = false;

  AddMeetingViewModel(BuildContext context, this.matForms) :
        meetingModeNameList = [Constants.DROPDOWN_NON_SELECT, "Voice call", "Video call", "Physical"],
        selectedMeetingMode = Constants.DROPDOWN_NON_SELECT,
        super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    if (flowDataProvider.currClientId == Constants.NA ||
        flowDataProvider.currClientId.isEmpty) {
      MATUtils.showAlertDialog(
          "Something went wrong with this client, please try again!",
          context,
          () => Navigator.pop(context));
    } else {
      clientDisplayData =
          MATUtils.getClientDisplayInfo(flowDataProvider.currClient, "clientStatus");
      showMeetingStatus = false;
      if(flowDataProvider.currMeeting.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 300));
        matForms.setVariableData("title", flowDataProvider.currMeeting["title"]);
        matForms.setVariableData("agenda", flowDataProvider.currMeeting["agenda"]);
        matForms.setVariableData("address", flowDataProvider.currMeeting["address"]);
        matForms.setVariableData("place", flowDataProvider.currMeeting["place"]);
        matForms.setVariableData("time", flowDataProvider.currMeeting["time"].toString().substring(11, 16));
        matForms.setVariableData("date", flowDataProvider.currMeeting["date"].toString().substring(0, 10));
        selectedMeetingMode = flowDataProvider.currMeeting["mode"];
        showMeetingStatus = true;
        notifyListeners();
      }
    }
  }

  void setSelectedMode(dynamic val) {
    selectedMeetingMode = val;
    notifyListeners();
  }

  void setSelectedStatus(dynamic val) {
    selectedMeetingStatus = val;
    notifyListeners();
  }

  Future<void> submit() async {
    print("Submit CALLED");
   if(selectedMeetingMode == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select meeting mode");
     return;
   }
   if(matForms.dynamicFormKey.currentState != null) {
     print("in");
     try{
       setBusy(true);
       var formData = matForms.dynamicFormKey.currentState!.value;
       var reqData = Map<String, dynamic>();
       formData.forEach((key, value) {
         reqData[key] = value;
       });
       String? id = await SharedPrefUtils.getUserId();
       reqData.putIfAbsent("userId", () => id);
       reqData.putIfAbsent("clientId", () => flowDataProvider.currClient["id"]);
       reqData.putIfAbsent("mode", () => selectedMeetingMode);

       await addMeetingApiCall(reqData);
       setBusy(false);

     } catch(e) {
       showToast("Something went Wrong!");
       setBusy(false);
     }
   }
  }


  Future<void> addMeetingApiCall(Map<String, dynamic> formData) async {
    var response = await ApiService.dio.post("profile/add_meeting", queryParameters: formData);

    print(response.requestOptions.uri);
    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "300")
        showToast(result["message"]);
      else if (result["code"] == "200")
        MATUtils.showAlertDialog(
          "Added meeting with ${clientDisplayData["name"]}", context, () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
      else
        showToast("Something went Wrong!");
    } else {
      showToast("Something went Wrong!");
    }
  }
}
