import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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

  Event _selectedEvent;

  @override
  void initState() {
    super.initState();

    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvent,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editEvent,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteEvent,
          ),
        ],
      ),
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
    return FutureBuilder<QuerySnapshot>(
        future: _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // NEW: Modified if statement and changed ListView.Builder to ListView
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) =>
                      buildEvent(context, document))
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  // NEW: bulidEvent Randy style
  Widget buildEvent(BuildContext context, DocumentSnapshot eventData) {
    final event =
        Event.fromMap(eventData.data(), reference: eventData.reference);

    return Container(
      decoration: BoxDecoration(
          color: _selectedEvent != null && event.id == _selectedEvent.id
              ? Colors.blue
              : Colors.white),
      child: GestureDetector(
          child: buildTile(context, event),
          onTap: () {
            setState(() {
              _selectedEvent = event;
              print("Selected Event: $_selectedEvent");
            });
          }),
    );
  }

  // Building a tile representing a single event in the event list
  Widget buildTile(BuildContext context, Event event) {
    return ListTile(
      title: Text(event.name),
      subtitle: Text(event.description),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.visibility),
            onPressed: () {
              _showViewDialog(context, event);
            },
          ),
        ],
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

  // Future function to add an event to the firestore database
  Future<void> _addEvent() async {
    var event = await Navigator.pushNamed(context, "/eventForm");

    if (event != null) {
      setState(() {
        _eventModel.insert(event);
        var snackbar = SnackBar(content: Text("Event has been added."));
        Scaffold.of(context).showSnackBar(snackbar);
      });

      print("Adding event $event...");
    }
  }

  // Deleting a single event based on event object
  Future<void> _deleteEvent() async {
    print('deleting event: $_selectedEvent');
    if (_selectedEvent != null) {
      setState(() {
        _eventModel.delete(_selectedEvent);

        var snackbar = SnackBar(content: Text("Event has been deleted."));
        Scaffold.of(context).showSnackBar(snackbar);
        _selectedEvent = null;
      });
    } else {
      _showAlertDialog();
    }
  }

  // Editting the currently selected event
  Future<void> _editEvent() async {
    if (_selectedEvent != null) {
      print('selected Event: $_selectedEvent');
      var event = await Navigator.pushNamed(context, "/eventForm",
          arguments: _selectedEvent);

      Event newEvent = event;

      if (event != null) {
        newEvent.reference = _selectedEvent.reference;
        setState(() {
          _eventModel.update(newEvent);

          var snackbar = SnackBar(content: Text("Event has been edited."));
          Scaffold.of(context).showSnackBar(snackbar);
        });
      }
    } else {
      _showAlertDialog();
    }
  }

  void _showViewDialog(BuildContext context, Event event) {
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

  void _showAlertDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: Text('Please select an event first!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
