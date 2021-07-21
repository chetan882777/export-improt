import 'package:agro_worlds/models/User.dart';
import 'package:agro_worlds/modules/allClients/AllClients.dart';
import 'package:agro_worlds/modules/dashboard/DashboardScreen.dart';
import 'package:agro_worlds/modules/login/LoginScreen.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgroWorldsDrawer {
  static Drawer drawer({required BuildContext context, bool listen = false}) {
    FlowDataProvider provider = Provider.of(context, listen: true);
    User user = provider.user;

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 64,
            ),
            Image.asset(
              Constants.AGRO_HEADER_LOGO,
              colorBlendMode: BlendMode.color,
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              color: Color(0xffe4e4e5),
              child: Column(
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(
                        fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${user.userRole}",
                    style:
                        TextStyle(fontSize: Constants.FONT_SIZE_NORMAL_TEXT, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            drawerMenuItem(
                displayName: "Dashboard",
                player: () {
                  Navigator.pushNamed(context, DashboardScreen.ROUTE_NAME);
                }),
            drawerMenuItem(displayName: "Clients", player: () {
              Navigator.pushNamed(context, AllClients.ROUTE_NAME);
            }),
            drawerMenuItem(displayName: "Meetings"),
            drawerMenuItem(displayName: "Deals"),
            drawerMenuItem(
                displayName: "Logout",
                color: Colors.red,
                player: () async {
                  await SharedPrefUtils.deleteUserId();
                  Navigator.pushNamed(context, LoginScreen.ROUTE_NAME);
                }),
          ],
        ),
      ),
    );
  }

  static Widget drawerMenuItem({
    required String displayName,
    void Function()? player,
    Color color = const Color(0xff4c4c4c),
  }) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: player,
        child: Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  displayName,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: Constants.FONT_SIZE_NORMAL_TEXT, color: color),
                ),
              ),
              Container(
                height: 1,
                color: Color(0xffd6d6d6),
              )
            ],
          ),
        ),
      ),
    );
  }
}
