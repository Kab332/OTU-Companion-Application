import 'package:flutter/material.dart';

import './views/event_finder_list.dart';

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
      body: EventListWidget(),
    );
  }
}
