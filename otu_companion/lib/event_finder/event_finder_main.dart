import 'package:flutter/material.dart';
import 'package:otu_companion/event_finder/views/add_event.dart';

import './views/event_finder_list.dart';

class EventPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListWidget(title: 'Event Finder'),
      routes: <String, WidgetBuilder>{
        '/addEvent': (BuildContext context) =>
            AddEventPage(title: 'Add an Event'),
      },
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
      body: EventListWidget(),
    );
  }
}
