import 'package:flutter/material.dart';
import 'package:otu_companion/event_finder/views/add_event.dart';

import './views/event_finder_list.dart';
import './views/add_event.dart';
import 'model/event.dart';

class EventPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventFinderMain(title: 'Event Finder'),
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
      body: buildEventFinder(),
      floatingActionButton: RaisedButton(
        child: Text("Add Event"),
        onPressed: _addEvent,
      ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _addEvent() async{
    var event = await Navigator.push(context, new MaterialPageRoute(
      builder: (context) => new AddEventPage(title: 'Add an Event')),
    );
    print("Adding event...");
  }
}