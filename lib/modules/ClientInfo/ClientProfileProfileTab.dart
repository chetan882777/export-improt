import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'ClientProfileViewModel.dart';

class ClientProfileProfileTab extends StatelessWidget {
  final ClientProfileViewModel model;

  ClientProfileProfileTab(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 0.25,
              color: Colors.black12,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 16, bottom: 8, right: 16),
              child: MATUtils.elevatedBtn(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  displayText: "Convert to Potential",
                  player: () {}),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
              child: ExpansionPanelList(
                  animationDuration: Duration(seconds: 1),
                  elevation: 0,
                  dividerColor: Colors.black12,
                  expansionCallback: (int index, bool isExpanded) {
                    model.setExpandedTile(index, !isExpanded);
                  },
                  children: [
                    createExpansionTile(
                      model.data[0],
                      Column(children: [
                        model.data[0].matForms.matEditable(
                          variable: "email",
                          displayText: "Email Address",
                          textInputType: TextInputType.emailAddress,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.email(context)
                          ]),
                        ),
                        model.data[0].matForms.matEditable(
                          variable: "contact",
                          displayText: "Contact number",
                          textInputType: TextInputType.phone,
                          player: (val) {
                            if (val.toString().length >= 10 &&
                                val.toString().length < 15) {
                              //model.isContactValid = true;
                            } else {
                              // model.isContactValid = false;
                            }
                          },
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        model.data[0].matForms.matEditable(
                          variable: "addressLine1",
                          displayText: "Address (line 1)",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Country",
                              style: TextStyle(
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        model.data[0].matForms.borderedDropDown(
                            borderColor: Theme.of(context).primaryColor,
                            items: model.countriesNameList,
                            displayValue: model.selectedCountry,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: model.setSelectedCountry),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "State",
                              style: TextStyle(
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        model.data[0].matForms.borderedDropDown(
                            borderColor: Theme.of(context).primaryColor,
                            items: model.statesNameList,
                            displayValue: model.selectedState,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: model.setSelectedState),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "City",
                              style: TextStyle(
                                  fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        model.data[0].matForms.borderedDropDown(
                          borderColor: Theme.of(context).primaryColor,
                          items: model.citiesNameList,
                          displayValue: model.selectedCity,
                          menuColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                          borderRadius: 8,
                          player: model.setSelectedCity,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        model.data[0].matForms.matEditable(
                          variable: "pincode",
                          displayText: "Pin code",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([]),
                        ),
                        model.data[0].matForms.matEditable(
                          variable: "landLineNumber",
                          displayText: "Landline Number",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([]),
                        ),
                        model.data[0].matForms.matEditable(
                          variable: "website",
                          displayText: "Website",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([]),
                        ),
                        model.data[0].matForms.matEditable(
                          variable: "socialHandles",
                          displayText: "Social handles",
                          textInputType: TextInputType.name,
                          player: (val) {},
                          validator: FormBuilderValidators.compose([]),
                        ),
                      ]),
                    ),
                    createExpansionTile(
                      model.data[1],
                      Column(
                        children: [
                          model.data[1].matForms.matEditable(
                            variable: "contactPersonName",
                            displayText: "Name",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                          ),
                          model.data[1].matForms.matEditable(
                            variable: "contactPersonDesignation",
                            displayText: "Designation",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    createExpansionTile(
                      model.data[2],
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Product Category",
                                style: TextStyle(
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.data[2].matForms.borderedDropDown(
                            borderColor: Theme.of(context).primaryColor,
                            items: model.productsCategoryNameList,
                            displayValue: model.selectedProductCategory,
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: model.setSelectedProductCategory,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ListView.builder(
                            itemCount: model.productsNameList.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, int index) {
                              return Row(children: [
                                Checkbox(
                                  value: model.selectedProductIds.containsKey(
                                          model.productsNameList[index])
                                      ? model.selectedProductIds[
                                          model.productsNameList[index]]
                                      : false,
                                  onChanged: (val) {
                                    if (val != null) {
                                      model.setSelectedProduct(index, val);
                                    }
                                  },
                                ),
                                Text(model.productsNameList[index])
                              ]);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    createExpansionTile(
                      model.data[3],
                      Column(
                        children: [
                          model.data[3].matForms.matEditable(
                            variable: "keyManagementPersonal",
                            displayText: "Key Management personnel",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Client Business Type",
                                style: TextStyle(
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.data[3].matForms.borderedDropDown(
                            borderColor: Theme.of(context).primaryColor,
                            items: ["Importer", "Exporter"],
                            displayValue: "Importer",
                            menuColor: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                            borderRadius: 8,
                            player: (val) {}
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Business Size",
                                style: TextStyle(
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.data[3].matForms.borderedDropDown(
                              borderColor: Theme.of(context).primaryColor,
                              items: ["Small", "Medium", "Large"],
                              displayValue: "Small",
                              menuColor: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                              fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                              borderRadius: 8,
                              player: (val) {}
                          ),
                          model.data[3].matForms.matEditable(
                            variable: "teamSize",
                            displayText: "Team Size",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                            ]),
                          ),
                          model.data[3].matForms.matEditable(
                            variable: "businessTurnoverApprx",
                            displayText: "Business Turnover Apprx",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                            ]),
                          ),
                          model.data[3].matForms.matEditable(
                            variable: "companyIncorporationDetail",
                            displayText: "Company Incorporation Detail",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                            ]),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Business Set up's /Demographic details",
                                style: TextStyle(
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.data[3].matForms.borderedDropDown(
                              borderColor: Theme.of(context).primaryColor,
                              items: ["India", "Foreign"],
                              displayValue: "India",
                              menuColor: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                              fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                              borderRadius: 8,
                              player: (val) {}
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Business Interest (High, moderate, low)",
                                style: TextStyle(
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.data[3].matForms.borderedDropDown(
                              borderColor: Theme.of(context).primaryColor,
                              items: ["High", "Moderate", "Low"],
                              displayValue: "High",
                              menuColor: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                              fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                              borderRadius: 8,
                              player: (val) {}
                          ),
                          model.data[3].matForms.matEditable(
                            variable: "businessReferences",
                            displayText: "Business References",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                            ]),
                          ),
                          model.data[3].matForms.matEditable(
                            variable: "additionalDetails",
                            displayText: "Additional details",
                            textInputType: TextInputType.name,
                            player: (val) {},
                            validator: FormBuilderValidators.compose([
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionPanel createExpansionTile(Item item, Widget body) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(
            item.headerValue,
            style: TextStyle(color: Theme.of(model.context).primaryColor),
          ),
        );
      },
      body: body,
      isExpanded: item.isExpanded,
    );
  }
}
