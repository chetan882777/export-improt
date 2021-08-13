import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/addMeeting/AddMeeting.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyMeetingsViewModel extends BaseViewModel {
  var userId;
  List<Map<String, dynamic>> clientsList = [];
  List<Map<String, dynamic>> meetingsList = [];

  MyMeetingsViewModel(BuildContext context) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    try {
      setBusy(true);
      userId = await SharedPrefUtils.getUserId();

      //await getUserMeetings();

      await loadClients();
      await Future.forEach(clientsList, (element) async {
        if (element != null) {
          Map curr = element as Map<String, dynamic>;
          var list = await getMeetingsData(userId, curr["id"]);
          list.forEach((element) {
            Map t = element as Map<String, dynamic>;
            t.putIfAbsent("companyName", () => curr["name"]);
            meetingsList.add(element);
          });
        }
      });
      if(meetingsList.isEmpty) {
        showToast("No Meetings found");
      }
      setBusy(false);
    }catch(e) {
      setBusy(false);
      showToast("Something went Wrong!");
    }
  }

  Future<void> fetchAllMeetings() async {}

  Future<void> loadClients() async {
    var response = await ApiService.dio.post("/profile/user_clients",
        queryParameters: {"id": await SharedPrefUtils.getUserId()});

    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "200") {
        List list = result["data"];
        list.forEach((element) {
          clientsList
              .add(MATUtils.getClientDisplayInfo(element, "client_status"));
        });
      } else
        showToast("Something went wrong!");
    } else
      showToast("Something went wrong!");
  }

  Future<List<dynamic>> getMeetingsData(String id, String clientId) async {
    var response = await ApiService.dio.post("meetings/get_client_meetings",
        queryParameters: {"userId": id, "clientId": clientId});
    print(response.requestOptions.uri);
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      if (data["code"] == "200") {
        return data["data"];
      }
    }
    return [];
  }

  void viewMeetingData(int index) async {
    flowDataProvider.currMeeting = meetingsList[index];
    flowDataProvider.currClientId = meetingsList[index]["client_id"];
    try {
      setBusy(true);
      Map<String, dynamic> client =
          await ApiService.getClient(flowDataProvider.currClientId);
      flowDataProvider.currClient = client["data"];
      Navigator.pushNamed(context, AddMeeting.ROUTE_NAME);
      setBusy(false);
    } catch(e) {
      showToast("Something went wrong!");
      setBusy(false);
    }
  }

  Future<void> getUserMeetings() async {
    var response = await ApiService.dio.post("profile/get_user_meetings",
        queryParameters: {"userId":  await SharedPrefUtils.getUserId()});
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      if (data["code"] == "200") {
        List<dynamic> list = data["data"];
        list.forEach((element) {
          meetingsList.add(element);
        });
      }
    }
  }
}
