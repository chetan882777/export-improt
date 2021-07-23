import 'package:agro_worlds/modules/addMeeting/AddMeeting.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ClientProfileViewModel.dart';

class ClientProfileMeetingsTab extends StatelessWidget {

  final ClientProfileViewModel model;
  ClientProfileMeetingsTab(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 0.25,
              color: Colors.black38,
            ),
            Padding(
              padding: EdgeInsets.only( left: 16, top: 16, bottom: 8, right: 16),
              child: MATUtils.elevatedBtn(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  displayText: "Add a meeting",
                  player: () {
                    Navigator.pushNamed(context, AddMeeting.ROUTE_NAME);
                  }),
            ),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, int index) {
                return remarkListItem(context, {
                  "title" : "this is title",
                  "status" : "Scheduled",
                  "date" : "31-May-2021"
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget remarkListItem(BuildContext context, Map<String, dynamic> data) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only( left: 16, top: 8, bottom: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["title"],
                      style: TextStyle(
                        fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text(
                          data["status"],
                          style: TextStyle(
                              fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                              color: Theme.of(context).primaryColor
                          ),
                        ),
                        SizedBox(width: 48,),
                        Text(
                          data["date"],
                          style: TextStyle(
                              fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
                InkWell(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {

                  },
                ),
              ],
            ),
            SizedBox(height: 16,),
            Container(
              height: 0.25,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}