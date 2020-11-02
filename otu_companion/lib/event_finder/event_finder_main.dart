import 'package:flutter/material.dart';

import './views/event_finder_list.dart';
import 'model/event.dart';

class EventPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class EventFinderMain extends StatefulWidget {
  EventFinderMain({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _EventFinderMainState createState() => _EventFinderMainState();
}

class _EventFinderMainState extends State<EventFinderMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildEventFinder(),
    );
  }
}