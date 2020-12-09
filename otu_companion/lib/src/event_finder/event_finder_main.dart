import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './views/event_finder_list.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class EventFinderMain extends StatefulWidget {
  EventFinderMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventFinderMainState createState() => _EventFinderMainState();
}

class _EventFinderMainState extends State<EventFinderMain> {
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
            body: EventListWidget(title: "Event Finder"),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
