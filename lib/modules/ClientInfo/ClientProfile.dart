import 'package:agro_worlds/modules/ClientInfo/ClientProfileViewModel.dart';
import 'package:agro_worlds/modules/drawer/AgroWorldsDrawer.dart';
import 'package:agro_worlds/utils/Constants.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:agro_worlds/utils/builders/MATUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ClientProfile extends StatelessWidget {
  static final String ROUTE_NAME = "/ClientProfile";

  final GlobalKey<FormBuilderState> dynamicFormKey =
      GlobalKey<FormBuilderState>();
  final Map<String, TextEditingController> mapper = Map();

  void saveVariable(String variable, String data) {
    mapper[variable]!.text = data;
  }

  late final MATForms matForms;

  @override
  Widget build(BuildContext context) {
    matForms = MATForms(
        context: context,
        dynamicFormKey: dynamicFormKey,
        mapper: mapper,
        saveController: saveVariable);

    final title = 'Client profile';

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: AgroWorldsDrawer.drawer(context: context),
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).accentColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  iconTheme:
                      IconThemeData(color: Theme.of(context).accentColor),
                  floating: true,
                  expandedHeight: 156,
                  backgroundColor: Colors.white,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(
                        top: 64, left: 16, right: 16, bottom: 16),
                    child: SingleChildScrollView(
                      child: Container(
                          child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.black,
                              child: Text(
                                "A",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "N S Enterprises",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Constants.FONT_SIZE_BIG_TEXT,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Sunil Grover, Lucknow",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Constants.FONT_SIZE_NORMAL_TEXT,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Prospect",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Constants.FONT_SIZE_SMALL_TEXT,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          text: "Contact",
                        ),
                        Tab(
                          text: "Remarks",
                        ),
                        Tab(
                          text: "Meetings",
                        ),
                        Tab(
                          text: "Deals",
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                Icon(Icons.music_note),
                Icon(Icons.music_video),
                Icon(Icons.camera_alt),
                Icon(Icons.grade),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
