import 'dart:convert';

import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ClientProfileViewModel extends BaseViewModel {
  final GlobalKey<FormBuilderState> dynamicFormKey =
      GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  Map<String, dynamic> clientDisplayData = {};
  List<dynamic> remarksList = [];
  List<dynamic> meetingsList = [];
  List<Item> data = [];

  List<String> countriesNameList;
  List<ListItem> countriesList;
  String selectedCountry;

  List<String> statesNameList;
  List<ListItem> statesList;
  String selectedState;

  List<String> citiesNameList;
  List<ListItem> citiesList;
  String selectedCity;

  List<String> productsCategoryNameList;
  List<ListItem> productsCategoryList;
  String selectedProductCategory;

  List<String> productsNameList;
  List<ListItem> productsList;
  Map<String, bool> selectedProductIds = Map();

  ClientProfileViewModel(BuildContext context) :
        statesList = [],
        statesNameList = [Constants.DROPDOWN_NON_SELECT],
        countriesNameList = [Constants.DROPDOWN_NON_SELECT],
        countriesList = [],
        selectedCountry = Constants.DROPDOWN_NON_SELECT,
        citiesList = [],
        citiesNameList = [Constants.DROPDOWN_NON_SELECT],
        productsCategoryList = [],
        productsCategoryNameList = [Constants.DROPDOWN_NON_SELECT],
        selectedProductCategory = Constants.DROPDOWN_NON_SELECT,
        productsList = [],
        productsNameList = [],
        selectedCity = Constants.DROPDOWN_NON_SELECT,
        selectedState = Constants.DROPDOWN_NON_SELECT,
        super(context) {
    setEditProfileTab();
    asyncInit();
  }

  void setEditProfileTab() {
    data = [];

    List names = [
      "Company Details",
      "Contact person details",
      "Product details",
      "Corporate profile"
    ];
    names.forEach((element) {
      data.add(
        Item(
          headerValue: element,
          matForms: MATForms(
              context: context,
              dynamicFormKey: dynamicFormKey,
              mapper: mapper,
              saveController: saveVariable),
          isExpanded: false,
        ),
      );
    });
  }

  void setExpandedTile(int index, bool isExpanded) {
    data[index].isExpanded = isExpanded;
    notifyListeners();
  }

  void onExpansionTileClick(Item item) {
    data.removeWhere((Item currentItem) => item == currentItem);
    notifyListeners();
  }

  Future<void> asyncInit() async {
    if (flowDataProvider.currClientId == Constants.NA ||
        flowDataProvider.currClientId.isEmpty) {
      MATUtils.showAlertDialog(
          "Something went wrong with this client, please try again!",
          context,
          () => Navigator.pop(context));
    } else {
      setBusy(true);
      await getClientData();
      await getRemarksData();
      await getMeetingsData();


      countriesNameList.clear();
      countriesList = await ApiService.countriesList();
      countriesNameList.add(Constants.DROPDOWN_NON_SELECT);
      countriesList.forEach((element) {
        countriesNameList.add(element.name);
      });
      countriesNameList.sort();
      selectedCountry = countriesNameList[0];

      productsCategoryNameList.clear();
      productsCategoryList = await ApiService.productCategories();
      productsCategoryNameList.add(Constants.DROPDOWN_NON_SELECT);
      productsCategoryList.forEach((element) {
        productsCategoryNameList.add(element.name);
      });
      productsCategoryNameList.sort();
      selectedProductCategory = productsCategoryNameList[0];

      setBusy(false);
    }
  }

  Future<void> getClientData() async {
    Map<String, dynamic> client =
        await ApiService.getClient(flowDataProvider.currClientId);
    print(client);
    if (client.isNotEmpty) {
      if (client["code"] == "200") {
        flowDataProvider.currClient = client["data"];
        clientDisplayData =
            MATUtils.getClientDisplayInfo(flowDataProvider.currClient);
      } else if (client["code"] == "300") {
        showToast(client["message"]);
      } else {
        showToast("Something went Wrong!");
      }
    }
  }

  Future<void> getRemarksData() async {
    var id = await SharedPrefUtils.getUserId();
    var response = await ApiService.dio.post("profile/get_client_remarks",
        queryParameters: {
          "userId": id,
          "clientId": flowDataProvider.currClientId
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      if (data["code"] == "200") {
        remarksList = data["data"];
        try {
          remarksList.sort((a, b) => DateTime.parse(b["date_time"].toString())
              .compareTo(DateTime.parse(a["date_time"].toString())));
        } catch (e) {}
      } else if (data["code"] == "300") {
        if (!data["message"].toString().toLowerCase().contains("result")) {
          showToast(data["message"]);
        }
      } else {
        showToast("Something went Wrong!");
      }
    }
  }

  Future<void> getMeetingsData() async {
    var id = await SharedPrefUtils.getUserId();
    var response = await ApiService.dio.post("profile/get_client_meetings",
        queryParameters: {
          "userId": id,
          "clientId": flowDataProvider.currClientId
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.data);
      print(data);
      if (data["code"] == "200") {
        meetingsList = data["data"];
        try {
          meetingsList.sort((a, b) => DateTime.parse(b["date"].toString())
              .compareTo(DateTime.parse(a["date"].toString())));
        } catch (e) {}
      } else if (data["code"] == "300") {
        if (!data["message"].toString().toLowerCase().contains("result")) {
          showToast(data["message"]);
        }
      } else {
        showToast("Something went Wrong!");
      }
    }
  }


  void setSelectedCountry(dynamic country) async {
    selectedCountry = country;
    print("state $country");
    if (country.toString() != Constants.DROPDOWN_NON_SELECT) {
      setBusy(true);
      await loadStates(country);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadStates(String country) async {
    try {
      ListItem mCountry =
      countriesList.firstWhere((element) => element.name == country);
      statesList = await ApiService.statesList(mCountry.id);
      statesNameList.clear();
      statesNameList.add(Constants.DROPDOWN_NON_SELECT);
      statesList.forEach((element) {
        statesNameList.add(element.name);
      });
      statesNameList.sort();
      selectedState = statesNameList[0];
    } catch (e) {
      print("catch $e");
    }
  }

  void setSelectedState(dynamic state) async {
    selectedState = state;
    print("state $state");
    if (state.toString() != Constants.DROPDOWN_NON_SELECT) {
      setBusy(true);
      await loadCities(state);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadCities(String state) async {
    try {
      ListItem mState =
      statesList.firstWhere((element) => element.name == state);
      citiesList = await ApiService.citiesList(mState.id);
      citiesNameList.clear();
      citiesNameList.add(Constants.DROPDOWN_NON_SELECT);
      citiesList.forEach((element) {
        citiesNameList.add(element.name);
      });
      citiesNameList.sort();
      selectedCity = citiesNameList[0];
    } catch (e) {
      print("catch $e");
    }
  }

  void setSelectedCity(dynamic city) async {
    selectedCity = city;
    notifyListeners();
  }

  void setSelectedProductCategory(dynamic product) async {
    selectedProductCategory = product;
    if (product.toString() != Constants.DROPDOWN_NON_SELECT) {
      setBusy(true);
      await loadProducts(product);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadProducts(String productType) async {
    try {
      ListItem mProduct = productsCategoryList
          .firstWhere((element) => element.name == productType);
      productsList = await ApiService.productsList(mProduct.id);
      productsNameList.clear();
      productsList.forEach((element) {
        productsNameList.add(element.name);
        selectedProductIds.putIfAbsent(element.name, () => false);
      });
      productsNameList.sort();

      print(productsNameList);
    } catch (e) {
      print("catch $e");
    }
  }

  void setSelectedProduct(int index, bool isSelected) {
    if (selectedProductIds.containsKey(productsNameList[index])) {
      selectedProductIds[productsNameList[index]] = isSelected;
      notifyListeners();
    }
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.matForms,
    this.isExpanded = false,
  });

  String headerValue;
  MATForms matForms;
  bool isExpanded;
}
