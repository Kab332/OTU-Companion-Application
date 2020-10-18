import 'package:flutter/material.dart';

class Event {
  String name;
  String description;
  DateTime startDateTime;
  DateTime endDateTime; 

  Event({this.name, this.description, this.startDateTime, this.endDateTime});

  String toString() {
    return '$name: ($startDateTime) ($endDateTime)';
  }
}

class EventPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Finder Main',
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
    );
  }
}