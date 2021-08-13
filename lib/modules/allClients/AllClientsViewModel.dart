import 'dart:convert';

import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/src/widgets/framework.dart';

class AllClientsViewModel extends BaseViewModel {
  MATForms matForms;
  List<Map<String, dynamic>> clientsList = [];
  List<ListItem> allProductsList = [];
  List<String> allProductsNameList = [];
  String selectedProduct = Constants.DROPDOWN_NON_SELECT;
  List<String> stageNameList = [Constants.DROPDOWN_NON_SELECT, "Prospect", "Potential", "Client"];
  String selectedStage = Constants.DROPDOWN_NON_SELECT;

  AllClientsViewModel(BuildContext context, this.matForms) : super(context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    setBusy(true);
    await loadClients();
    await loadProducts();
    setBusy(false);
  }

  Future<void> loadClients() async {
    try {
      var response = await ApiService.dio.post("/profile/user_clients",
          queryParameters: {"id": await SharedPrefUtils.getUserId()});

      if (response.statusCode == 200) {
        var result = json.decode(response.data);
        if (result["code"] == "200") {
          clientsList.clear();
          List list = result["data"];
          list.forEach((element) {
            clientsList.add(
                MATUtils.getClientDisplayInfo(element, "clientStatus"));
          });
          print(clientsList);
        } else if (result["code"] == "300") {
          showToast(result["message"]);
        } else {
          showToast("Something went wrong!");
        }
      } else
        showToast("Something went wrong!");
    } catch(e) {
      showToast("Something went wrong!");
    }
  }
  
  Future<void> loadProducts() async {
    try{
      List<ListItem> productCategories = await ApiService.productCategories();
      List<ListItem> allProducts = [];
      await Future.forEach(productCategories, (ListItem element) async {
        List<ListItem> products = await ApiService.productsList(element.id);
        allProducts.addAll(products);
      });

      allProductsList = allProducts;
      allProductsNameList = [Constants.DROPDOWN_NON_SELECT];
      allProductsList.forEach((element) {
        allProductsNameList.add(element.name);
      });
    } catch(e) {}
  }

  void setSelectedProduct (dynamic val) {
    selectedProduct = val;
    notifyListeners();
  }


  void setSelectedStage (dynamic val) {
    selectedStage = val;
    notifyListeners();
  }

  Future<void> filterList(String name) async {
    setBusy(true);
    try{
      Map<String, String> map = {};
      map["companyName"] = name;

      if(selectedProduct != Constants.DROPDOWN_NON_SELECT)
        map["product"] = allProductsList.firstWhere((element) => element.name == selectedProduct).id;
      else
        map["product"] = "";

      if(selectedStage != Constants.DROPDOWN_NON_SELECT)
        map["clientStatus"] = selectedStage;
      else
        map["clientStatus"] = "";

      String? userId = await SharedPrefUtils.getUserId();
      map["userId"] = userId!;

      print(map);
      var response = await ApiService.dio.request("/profile/filter_user_clients", queryParameters: map);

      print(response);
      if (response.statusCode == 200) {
        var result = json.decode(response.data);
        if (result["code"] == "200") {
          clientsList.clear();
          List list = result["data"];
          list.forEach((element) {
            clientsList.add(
                MATUtils.getClientDisplayInfo(element, "client_status"));
          });
          print(clientsList);
        } else if (result["code"] == "300") {
          showToast(result["message"]);
        } else {
          showToast("Something went wrong!");
        }
      } else
        showToast("Something went wrong!");
    } catch(e) {
      showToast("Failed To apply filters");
    }
    setBusy(false);
  }
}
