import 'dart:convert';

import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/modules/addProspect/AddProspectSuccess.dart';
import 'package:agro_worlds/network/ApiService.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddProspectViewModel extends BaseViewModel {
  bool isNameEntered = false;
  String name;

  List<String> clientTypes;
  String selectedClientType;

  List<String> rolesNameList;
  List<ListItem> rolesList;
  String selectedRole;


  List<String> countriesNameList;
  List<ListItem> countriesList;
  String selectedCountry;


  List<String> statesNameList;
  List<ListItem> statesList;
  String selectedState;


  List<String> citiesNameList;
  List<ListItem> citiesList;
  String selectedCity;

  MATForms matForms;
  bool isContactValid = false;
  bool isStateSelected = false;
  bool isCountrySelected = false;

  AddProspectViewModel(BuildContext context, this.matForms)
      : clientTypes = [],
        statesList = [],
        statesNameList = [Constants.DROPDOWN_NON_SELECT],
        countriesNameList = [Constants.DROPDOWN_NON_SELECT],
        countriesList = [],
        selectedCountry = Constants.DROPDOWN_NON_SELECT,
        citiesList = [],
        citiesNameList = [Constants.DROPDOWN_NON_SELECT],
        rolesList = [],
        rolesNameList = [Constants.DROPDOWN_NON_SELECT],
        selectedRole = Constants.DROPDOWN_NON_SELECT,
        selectedCity = Constants.DROPDOWN_NON_SELECT,
        selectedState = Constants.DROPDOWN_NON_SELECT,
        selectedClientType = 'Prospect',
        name = "",
        super(context) {
    if (flowDataProvider.user.userRole.toString().toLowerCase() ==
        Constants.ROLE_BDE) {
      clientTypes = ['Prospect'];
    } else if (flowDataProvider.user.userRole.toString().toLowerCase() ==
        Constants.ROLE_BDM) {
      clientTypes = ['Prospect', 'Potential'];
    }
    asyncInit();
  }

  Future<void> asyncInit() async {
    try {
      setBusy(true);

      countriesNameList.clear();

      countriesList = await ApiService.countriesList();
      countriesNameList.add(Constants.DROPDOWN_NON_SELECT);
      countriesList.forEach((element) {
        countriesNameList.add(element.name);
      });
      countriesNameList.sort();
      selectedCountry = countriesNameList[0];

      rolesList = await ApiService.rolesList();
      print(rolesList.length);
      rolesNameList.add(Constants.DROPDOWN_NON_SELECT);
      rolesList.forEach((element) {
        print(element.name);
        if(element.name.toString().toLowerCase().contains("importer") || element.name.toString().toLowerCase().contains("exporter"))
          rolesNameList.add(element.name);
      });
      selectedRole = rolesNameList[0];

      setBusy(false);
    } catch (e) {
      setBusy(false);
    }
  }

  void setSelectedRole(dynamic role) async {
    selectedRole = role;
    notifyListeners();
  }

  void setSelectedCountry(dynamic country) async {
    selectedCountry = country;
    print("state $country");
    if(country.toString() == Constants.DROPDOWN_NON_SELECT) {
      isCountrySelected = false;
    } else {
      isCountrySelected = true;
      setBusy(true);
      await loadStates(country);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadStates(String country) async {
    try{
      ListItem mCountry = countriesList.firstWhere((element) => element.name == country);
      statesList = await ApiService.statesList(mCountry.id);
      statesNameList.clear();
      statesList.forEach((element) {
        statesNameList.add(element.name);
      });
      statesNameList.sort();
      selectedState = statesNameList[0];
    } catch(e) {
      print("catch $e");
    }
  }

  void setSelectedState(dynamic state) async {
    selectedState = state;
    print("state $state");
    if(state.toString() == Constants.DROPDOWN_NON_SELECT) {
      isStateSelected = false;
    } else {
      isStateSelected = true;
      setBusy(true);
      await loadCities(state);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> loadCities(String state) async {
    try{
      ListItem mState = statesList.firstWhere((element) => element.name == state);
      citiesList = await ApiService.citiesList(mState.id);
      citiesNameList.clear();
      citiesList.forEach((element) {
        citiesNameList.add(element.name);
      });
      citiesNameList.sort();
      selectedCity = citiesNameList[0];
    } catch(e) {
      print("catch $e");
    }
  }

  void setSelectedCity(dynamic city) async {
    selectedCity = city;
    notifyListeners();
  }

  void submit() async {
    if (!isContactValid) {
      showToast("Enter valid Contact");
      return;
    }
    if(selectedRole == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select a role");
      return;
    }
    if(selectedState == Constants.DROPDOWN_NON_SELECT) {
      showToast("Select a state");
      return;
    }
    if (matForms.dynamicFormKey.currentState != null) {
      try {
        setBusy(true);
        var formData = matForms.dynamicFormKey.currentState!.value;
        var reqData = Map();
        formData.forEach((key, value) {
          reqData[key] = value;
        });
        reqData.putIfAbsent("clientType", () {
          return clientTypes
              .firstWhere((element) => element == selectedClientType);
        });
        String? id = await SharedPrefUtils.getUserId();
        reqData.putIfAbsent("id", () => id);

        ListItem mRole = rolesList.firstWhere((element) => element.name == selectedRole);
        ListItem mState = statesList.firstWhere((element) => element.name == selectedState);
        ListItem mCity = citiesList.firstWhere((element) => element.name == selectedCity);

        reqData.putIfAbsent("state", () => mState.id);
        reqData.putIfAbsent("city", () => mCity.id);
        reqData.putIfAbsent("role", () => mRole.id);

        print(reqData);

        await addClientApiCall(formData);

        setBusy(false);
      } catch (e) {
        showToast("Something went wrong!");
        print("error => $e");
        setBusy(false);
      }
    }
  }

  void setSelectedClientType(val) {
    selectedClientType = val;
    notifyListeners();
  }

  void setName(String name) {
    bool shouldNotify = false;
    if ((this.name.isEmpty && name.isNotEmpty) ||
        (this.name.isNotEmpty && name.isEmpty)) shouldNotify = true;

    this.name = name;

    if (name.isNotEmpty)
      isNameEntered = true;
    else if (name.isEmpty) isNameEntered = false;
    if (shouldNotify) notifyListeners();
  }

  Future<void> addClientApiCall(Map<String, dynamic> formData) async {
    var response = await ApiService.dio
        .post("profile/add_prospect", queryParameters: formData);

    if (response.statusCode == 200) {
      var result = json.decode(response.data);
      if (result["code"] == "300")
        showToast(result["code"]);
      else if (result["code"] == "200")
        Navigator.pushReplacementNamed(context, AddProspectSuccess.ROUTE_NAME);
      else
        showToast("Something went Wrong!");
    } else {
      showToast("Something went Wrong!");
    }
  }
}
