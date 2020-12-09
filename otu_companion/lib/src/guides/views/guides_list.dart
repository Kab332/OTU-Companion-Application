import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class GuidesListWidget extends StatefulWidget {
  GuidesListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  GuidesListWidgetState createState() => GuidesListWidgetState();
}

class GuidesListWidgetState extends State<GuidesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: MainSideDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text("Hello World"),
    );
  }
}
