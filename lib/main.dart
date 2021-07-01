import 'package:agro_worlds/modules/register/RegisterScreen.dart';
import 'package:agro_worlds/providers/ApplicationApiProvider.dart';
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
  Provider.value(value: ApplicationApiProvider())
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
          ),
          primaryColor: Color.fromARGB(255, 231, 211, 142),
          accentColor: Color.fromARGB(255, 145, 105, 26),
          fontFamily: 'Lato',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => LoginScreen(),
          RegisterScreen.ROUTE_NAME : (ctx) => RegisterScreen()
        },
      ),
    );
  }
}
