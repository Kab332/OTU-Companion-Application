import 'package:flutter/material.dart';
import 'package:otu_companion/event_finder/views/add_event.dart';

import './views/event_finder_list.dart';
import './views/add_event.dart';
import 'model/event.dart';
import 'model/event_model.dart';

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
  EventModel _eventModel = EventModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: EventListWidget(),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            RaisedButton(
              onPressed: _addEvent,
              child: Text("Add Event"),
            ),
            RaisedButton(
              onPressed: _delete,
              child: Text("Delete All Events"),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _addEvent() async {
    var event = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new AddEventPage(title: 'Add an Event')),
    );

    if (event != null) {
      setState(() {
        _eventModel.insert(event);
      });

      print("Adding event $event...");
    }
  }

  Future<void> _delete() async {
    setState(() {
      _eventModel.deleteAll();
    });
  }
}
