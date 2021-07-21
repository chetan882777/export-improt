import 'package:agro_worlds/modules/remark/AddRemark.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientProfileActionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            belowClickWidgets(
              context: context,
              displayText: "Edit profile",
              player: () {
                DefaultTabController.of(context)!.animateTo(1);
              },
            ),
            belowClickWidgets(
              context: context,
              displayText: "Convert to potential",
              player: () {},
            ),
            belowClickWidgets(
              context: context,
              displayText: "Add a remark",
              player: () {
                Navigator.pushNamed(context, AddRemark.ROUTE_NAME);
              },
            ),
            belowClickWidgets(
              context: context,
              displayText: "Add a meeting",
              player: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget belowClickWidgets(
      {required BuildContext context,
      required String displayText,
      void Function()? player}) {
    return InkWell(
      onTap: player,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.right_chevron,
                color: Color(0xff946d20),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Color(0xffd6d6d6),
          ),
        ]),
      ),
    );
  }
}
