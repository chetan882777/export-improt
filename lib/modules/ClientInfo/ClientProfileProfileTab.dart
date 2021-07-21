import 'package:flutter/cupertino.dart';

class ClientProfileProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: 70,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
          return Text("HGelo $index");
        },
      ),
    );
  }
}
