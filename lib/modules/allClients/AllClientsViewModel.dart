import 'dart:convert';

import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/src/widgets/framework.dart';

class AllClientsViewModel extends BaseViewModel {
  MATForms matForms;
  List<Map<String, dynamic>> clientsList = [];

  AllClientsViewModel(BuildContext context, this.matForms) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    setBusy(true);
    await loadClients();
    setBusy(false);
  }

  Future<void> loadClients() async {
    var response = await ApiService.dio.post("/profile/user_clients",
        queryParameters: {"id": await SharedPrefUtils.getUserId()});

    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "200") {
        List list = result["data"];
        list.forEach((element) {
          clientsList.add(MATUtils.getClientDisplayInfo(element, "client_status"));
        });
        print(clientsList);

      } else if (result["code"] == "300") {
        showToast(result["message"]);
      } else {
        showToast("Something went wrong!");
      }
    } else
      showToast("Something went wrong!");
  }
}
