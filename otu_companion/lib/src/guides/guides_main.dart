import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'views/guides_list.dart';

class GuidesMain extends StatefulWidget {
  GuidesMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GuidesMainState createState() => _GuidesMainState();
}

class _GuidesMainState extends State<GuidesMain> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error initializing firebase');
          return Text('Error initializing Firebase');
        }

        if (snapshot.hasData == true &&
            snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            drawer: MainSideDrawer(),
            body: GuidesListWidget(title: "Guides"),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
