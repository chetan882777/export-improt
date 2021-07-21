import 'package:agro_worlds/modules/ClientInfo/ClientProfile.dart';
import 'package:agro_worlds/modules/addProspect/AddProspect.dart';
import 'package:agro_worlds/modules/addProspect/AddProspectSuccess.dart';
import 'package:agro_worlds/modules/allClients/AllClients.dart';
import 'package:agro_worlds/modules/dashboard/DashboardScreen.dart';
import 'package:agro_worlds/modules/otp/OtpScreen.dart';
import 'package:agro_worlds/modules/register/RegisterScreen.dart';
import 'package:agro_worlds/modules/remark/AddRemark.dart';
import 'package:agro_worlds/providers/ApplicationApiProvider.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/MatKeys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'modules/login/LoginScreen.dart';

void main() {
  runApp(AgroWorld());
}

List<SingleChildWidget> providers = [...independentServices];

List<SingleChildWidget> independentServices = [
  Provider.value(value: ApplicationApiProvider()),
  Provider.value(value: FlowDataProvider())
];

class AgroWorld extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: MATKeys.navKey,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary:  Color.fromARGB(255, 145, 105, 26),
            secondary: Color.fromARGB(255, 231, 211, 142),
          ),
          primaryColor: Color.fromARGB(255, 145, 105, 26),
          secondaryHeaderColor: Color.fromARGB(255, 231, 211, 142),
          accentColor: Color.fromARGB(255, 145, 105, 26),
          fontFamily: 'Lato',
        ),
        initialRoute: LoginScreen.ROUTE_NAME,
        routes: {
          '/': (ctx) => LoginScreen(),
          LoginScreen.ROUTE_NAME : (ctx) => LoginScreen(),
          RegisterScreen.ROUTE_NAME : (ctx) => RegisterScreen(),
          OtpScreen.ROUTE_NAME : (ctx) => OtpScreen(),
          DashboardScreen.ROUTE_NAME: (ctx) => DashboardScreen(),
          AddProspect.ROUTE_NAME: (ctx) => AddProspect(),
          AddProspectSuccess.ROUTE_NAME: (ctx) => AddProspectSuccess(),
          AllClients.ROUTE_NAME: (ctx) => AllClients(),
          ClientProfile.ROUTE_NAME: (ctx) => ClientProfile(),
          AddRemark.ROUTE_NAME: (ctx) => AddRemark(),
        },
      ),
    );
  }
}




/**
*
 *
 *
 *
 *  BDM :
   COntact
    Remark
    Meetings
    Deals

    BDE:
    Contact
    Remark
    Meeting
 *
 *
 *
 *
 *  meeting :
 *  voice call,
 *  video call,
 *  physical
* */
