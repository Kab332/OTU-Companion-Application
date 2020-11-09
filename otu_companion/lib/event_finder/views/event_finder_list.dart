import 'package:flutter/material.dart';

import '../model/event_model.dart';
import '../model/event.dart';

class EventListWidget extends StatefulWidget {
  EventListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  List<Event> events;
  final _eventModel = EventModel();

  @override
  void initState() {
    super.initState();

    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildEventFinder(),
    );
  }

  Widget buildEventFinder() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              height: 550.0,
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: _buildListView(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder(
        future: _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.hasData == null) {
            return LinearProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data != null ? snapshot.data.length : 0,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  child: buildTile(snapshot.data[i]),
                );
              });
        });
  }

  // Building a tile representing a single event in the event list
  Widget buildTile(Event event) {
    return ListTile(
      title: Text(event.name),
      subtitle: Text(event.description),
    );
  }

  Future<List<Event>> getAllEvents() async {
    List<Event> events = await _eventModel.getAll();
    this.events = events;
    return events;
  }
}
