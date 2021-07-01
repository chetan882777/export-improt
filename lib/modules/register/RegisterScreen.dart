import 'package:agro_worlds/modules/register/RegisterViewModel.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static final String ROUTE_NAME = "/register";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => RegisterViewModel(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Register",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        endDrawer: Drawer(
            child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Checkout'),
                    onTap: (){
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text('Transactions'),
                    onTap: (){
                      Navigator.pushNamed(context, '/transactionsList');
                    },
                  ),
                ]
            )
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[],
            ),
            Consumer(
              builder: (context, RegisterViewModel model, child) =>
                  MATUtils.showLoader(
                context: context,
                isLoadingVar: false,
                size: 20,
                opacity: 0.95,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
