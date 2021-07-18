import 'package:agro_worlds/modules/addClient/AddClient.dart';
import 'package:agro_worlds/modules/allClients/AllClients.dart';
import 'package:agro_worlds/modules/dashboard/DashboardScreen.dart';
import 'package:agro_worlds/modules/otp/OtpScreen.dart';
import 'package:agro_worlds/modules/register/RegisterScreen.dart';
import 'package:agro_worlds/providers/ApplicationApiProvider.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/MatKeys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'modules/addClient/AddClientSuccess.dart';
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
          AddClient.ROUTE_NAME: (ctx) => AddClient(),
          AddClientSuccess.ROUTE_NAME: (ctx) => AddClientSuccess(),
          AllClients.ROUTE_NAME: (ctx) => AllClients()
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
