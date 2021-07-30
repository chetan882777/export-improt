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
  static const String COMPANY_DETAIL_EMAIL = "email";
  static const String COMPANY_DETAIL_CONTACT = "contact";
  static const String COMPANY_DETAIL_ADD_LINE_1 = "addressLine1";
  static const String COMPANY_DETAIL_PINCODE = "pincode";
  static const String COMPANY_DETAIL_LANDLINE_NUMBER = "land_line_number";
  static const String COMPANY_DETAIL_WEBSITE = "website";
  static const String COMPANY_DETAIL_COUNTRY = "country";
  static const String COMPANY_DETAIL_STATE = "state";
  static const String COMPANY_DETAIL_CITY = "city";
  static const String COMPANY_DETAIL_SOCIAL_HANDLES = "socialHandles";
  static const String COMPANY_DETAIL_BUSINESS_EMAIL = "businessEmailAddress";
  static const String COMPANY_DETAIL_BUSINESS_POC_1 = "businessPOCName1";
  static const String COMPANY_DETAIL_BUSINESS_POC_2 = "businessPOCName2";
  static const String COMPANY_DETAIL_BUSINESS_NUMBER = "pocBusinessNumber";

  static const String CONTACT_PERSON_NAME = "contactPersonName";
  static const String CONTACT_PERSON_DESIGNATION = "contactPersonDesignation";

  static const String CORPORATE_KEY_MANAGEMENT_PERSONAL =
      "keyManagementPersonal";
  static const String CORPORATE_TEAM_SIZE = "teamSize";
  static const String CORPORATE_BUSINESS_TURNOVER_APX = "businessTurnoverApprx";
  static const String CORPORATE_COMPANY_INCORP_DETAILS =
      "companyIncorporationDetail";
  static const String CORPORATE_BUSINESS_REF = "businessReferences";
  static const String CORPORATE_ADDITIONAL_DETAILS = "additionalDetails";

  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  Map<String, dynamic> clientDisplayData = {};
  Map<String, dynamic> clientData = {};

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

  bool isContactValid = false;
  bool isBusinessContactValid = false;

  ClientProfileViewModel(BuildContext context)
      : statesList = [],
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
              dynamicFormKey: GlobalKey(debugLabel: element),
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
    if (index == 0) {
      setCompanyDetails();
    }
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
    if (client.isNotEmpty) {
      if (client["code"] == "200") {
        flowDataProvider.currClient = client["data"];
        clientDisplayData =
            MATUtils.getClientDisplayInfo(flowDataProvider.currClient);

        clientData = flowDataProvider.currClient;

        data[0].matForms.setVariableData("email", clientData["email"]);
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

  Future<void> setSelectedCountry(dynamic country) async {
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

  Future<void> setSelectedState(dynamic state) async {
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

  void setCompanyDetails() async {
    await Future.delayed(Duration(milliseconds: 300));
    print(clientData);
    data[0].matForms.setVariableData(
        COMPANY_DETAIL_EMAIL, clientData[COMPANY_DETAIL_EMAIL]);
    data[0].matForms.setVariableData(
        COMPANY_DETAIL_CONTACT, clientData[COMPANY_DETAIL_CONTACT]);

    if (clientData["address_line1"] != null &&
        clientData["address_line1"].toString().isNotEmpty)
      data[0].matForms.setVariableData(
          COMPANY_DETAIL_ADD_LINE_1, clientData["address_line1"]);

    if (clientData[COMPANY_DETAIL_PINCODE] != null &&
        clientData[COMPANY_DETAIL_PINCODE].toString().isNotEmpty)
      data[0].matForms.setVariableData(
          COMPANY_DETAIL_PINCODE, clientData[COMPANY_DETAIL_PINCODE]);

    if (clientData["landLineNumber"] != null &&
        clientData["landLineNumber"].toString().isNotEmpty)
      data[0].matForms.setVariableData(
          COMPANY_DETAIL_LANDLINE_NUMBER, clientData["landLineNumber"]);

    if (clientData[COMPANY_DETAIL_WEBSITE] != null &&
        clientData[COMPANY_DETAIL_WEBSITE].toString().isNotEmpty)
      data[0].matForms.setVariableData(
          COMPANY_DETAIL_WEBSITE, clientData[COMPANY_DETAIL_WEBSITE]);

    if (clientData[COMPANY_DETAIL_SOCIAL_HANDLES] != null &&
        clientData[COMPANY_DETAIL_SOCIAL_HANDLES].toString().isNotEmpty)
      data[0].matForms.setVariableData(COMPANY_DETAIL_SOCIAL_HANDLES,
          clientData[COMPANY_DETAIL_SOCIAL_HANDLES]);

    if (clientData[COMPANY_DETAIL_BUSINESS_EMAIL] != null &&
        clientData[COMPANY_DETAIL_BUSINESS_EMAIL].toString().isNotEmpty)
      data[0].matForms.setVariableData(COMPANY_DETAIL_BUSINESS_EMAIL,
          clientData[COMPANY_DETAIL_BUSINESS_EMAIL]);

    if (clientData[COMPANY_DETAIL_BUSINESS_POC_1] != null &&
        clientData[COMPANY_DETAIL_BUSINESS_POC_1].toString().isNotEmpty)
      data[0].matForms.setVariableData(COMPANY_DETAIL_BUSINESS_POC_1,
          clientData[COMPANY_DETAIL_BUSINESS_POC_1]);

    if (clientData[COMPANY_DETAIL_BUSINESS_POC_2] != null &&
        clientData[COMPANY_DETAIL_BUSINESS_POC_2].toString().isNotEmpty)
      data[0].matForms.setVariableData(COMPANY_DETAIL_BUSINESS_POC_2,
          clientData[COMPANY_DETAIL_BUSINESS_POC_2]);

    if (clientData[COMPANY_DETAIL_BUSINESS_NUMBER] != null &&
        clientData[COMPANY_DETAIL_BUSINESS_NUMBER].toString().isNotEmpty)
      data[0].matForms.setVariableData(COMPANY_DETAIL_BUSINESS_NUMBER,
          clientData[COMPANY_DETAIL_BUSINESS_NUMBER]);

    if (clientData[COMPANY_DETAIL_COUNTRY] != null &&
        clientData[COMPANY_DETAIL_COUNTRY].toString().isNotEmpty)
      await setSelectedCountry(clientData[COMPANY_DETAIL_COUNTRY]);

    if (clientData[COMPANY_DETAIL_STATE] != null &&
        clientData[COMPANY_DETAIL_STATE].toString().isNotEmpty)
      await setSelectedState(clientData[COMPANY_DETAIL_STATE]);

    if (clientData[COMPANY_DETAIL_CITY] != null &&
        clientData[COMPANY_DETAIL_CITY].toString().isNotEmpty)
      setSelectedCity(clientData[COMPANY_DETAIL_CITY]);
  }

  Future<void> saveCompanyDetails() async {
    if (!isContactValid) {
      showToast("Enter Valid Contact");
      return;
    }
    if (!isBusinessContactValid) {
      showToast("Enter Valid Business Contact");
      return;
    }
    if (data[0].matForms.dynamicFormKey.currentState != null) {
      try {
        setBusy(true);
        var formData = data[0].matForms.dynamicFormKey.currentState!.value;
        var reqData = Map<String, dynamic>();
        formData.forEach((key, value) {
          reqData[key] = value;
        });
        reqData.putIfAbsent("clientId", () => flowDataProvider.currClientId);
        ListItem mCountry = countriesList
            .firstWhere((element) => element.name == selectedCountry);
        ListItem mState =
            statesList.firstWhere((element) => element.name == selectedState);
        ListItem mCity =
            citiesList.firstWhere((element) => element.name == selectedCity);
        reqData.putIfAbsent("country", () => mCountry.id);
        reqData.putIfAbsent("state", () => mState.id);
        reqData.putIfAbsent("city", () => mCity.id);
        reqData.putIfAbsent("companyName", () => clientData["companyName"]);

        var response = await ApiService.dio
            .post("profile/update_company_details", queryParameters: reqData);
        if (response.statusCode == 200) {
          var result = json.decode(response.data);
          if (result["code"] == "300")
            showToast(result["message"]);
          else if (result["code"] == "200")
            showToast("Successfully Updated Company details");
          else
            showToast("Something went Wrong!");
        } else {
          showToast("Something went Wrong!");
        }
        setBusy(false);
      } catch (e) {
        showToast("Something went wrong!");
        print("error => $e");
        setBusy(false);
      }
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
