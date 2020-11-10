import 'package:cloud_firestore/cloud_firestore.dart';
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

  int _selectedIndex;
  Event _selectedEvent;

  @override
  void initState() {
    super.initState();

    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildEventFinder(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
        tooltip: "Add an event",
      ),
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
    return FutureBuilder<QuerySnapshot>(
        future: _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.hasData == null) {
            return LinearProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data != null ? snapshot.data.docs.length : 0,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  decoration: BoxDecoration(
                      color: i == _selectedIndex ? Colors.blue : Colors.white),
                  child: GestureDetector(
                      child: buildTile(context, Event.fromMap(snapshot.data.docs[i].data(), reference: snapshot.data.docs[i].reference)),
                      onTap: () {
                        setState(() {
                          _selectedIndex = i;
                          _selectedEvent = Event.fromMap(snapshot.data.docs[i].data());
                          print("Selected ID: $_selectedEvent");
                        });
                      }),
                );
              });
        });
  }

  // Future function to add an event to the firestore database
  Future<void> _addEvent() async {
    var event = await Navigator.pushNamed(context, "/addEvent");

    if (event != null) {
      setState(() {
        _eventModel.insert(event);
      });

      print("Adding event $event...");
    }
  }

  // Deleting a single event based on event object
  Future<void> _deleteEvent(Event event) async {
    setState(() {
      _eventModel.delete(event);
    });
  }

  // Building a tile representing a single event in the event list
  Widget buildTile(BuildContext context, Event event) {
    return ListTile(
      title: Text(event.name),
      subtitle: Text(event.description),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteEvent(event);
        },
      ),
      leading: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _showEditDialog(context, event);
        },
      ),
    );
  }

  Future<QuerySnapshot> getAllEvents() async {
    _eventModel.getAll().then((value) {
      // print events for debugging purposes
      for (int i = 0; i < value.docs.length; i++) {
        print(value.docs[i].data());
      }
    });
    return await _eventModel.getAll();
  }

  void _showEditDialog(BuildContext context, Event event) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 300,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                  ),
                  initialValue: event.name,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Description',
                  ),
                  initialValue: event.description,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Start Date and Time',
                  ),
                  initialValue: event.startDateTime.toString(),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'End Date and Time',
                  ),
                  initialValue: event.endDateTime.toString(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text('Dismiss'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
