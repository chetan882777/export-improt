import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientProfileProfileTab extends StatelessWidget {
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
                  displayText: "Convert to Potential",
                  player: () {
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
