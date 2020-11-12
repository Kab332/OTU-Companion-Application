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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          // add an event
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvent,
          ),
          // edit selected event
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editEvent,
          ),
          // delete selected event
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
              height: 500.0,
              width: 350.0,
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

  Widget buildEvent(BuildContext context, DocumentSnapshot eventData) {
    final event =
        Event.fromMap(eventData.data(), reference: eventData.reference);

    return Container(
      decoration: BoxDecoration(
        border: _selectedEvent != null && event.id == _selectedEvent.id ? Border.all(
          width: 3.0, color: Colors.blueAccent) : null,
      ),
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

  // Future function of type QuerySnapshot to return all events to the event list, uses instance of eventModel to get events
  Future<QuerySnapshot> getAllEvents() async {
    _eventModel.getAll().then((value) {
      // print events for debugging purposes
      for (int i = 0; i < value.docs.length; i++) {
        print(value.docs[i].data());
      }
    });
    return await _eventModel.getAll();
  }

  // Future function to add an event to the firestore database, also pushes a snackbar indicating if it was successful
  Future<void> _addEvent() async {
    var event = await Navigator.pushNamed(context, "/eventForm", arguments: null);

    // check if event is not null, navigating back will keep it null
    if (event != null) {
      setState(() {
        _eventModel.insert(event);
        var snackbar = SnackBar(content: Text("Event has been added."));
        Scaffold.of(context).showSnackBar(snackbar);
      });

      print("Adding event $event...");
    }
  }

  // Future function to deleting a single event based on the selected event
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
      // if an event wasn't selected, show error dialog
      _showAlertDialog();
    }
  }

  // Future function that will bring up the event form with the currently selected event, shows a snackbar if event was successful
  Future<void> _editEvent() async {
    if (_selectedEvent != null) {
      print('selected Event: $_selectedEvent');
      var event = await Navigator.pushNamed(context, '/eventForm', arguments: _selectedEvent);

      Event newEvent = event;

      if (event != null) {
        newEvent.reference = _selectedEvent.reference;
        setState(() {
          _eventModel.update(newEvent);

          var snackbar = SnackBar(content: Text("Event has been edited."));
          Scaffold.of(context).showSnackBar(snackbar);
        });
      }
      // if an event wasn't selected, show error dialog
    } else {
      _showAlertDialog();
    }
  }

  // function that shows a dialog that shows quick details about the event selected, pressing dismiss or clicking away will make it disappear
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
                // event name form field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                  ),
                  initialValue: event.name,
                ),
                // event description form field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Event Description',
                  ),
                  initialValue: event.description,
                ),
                // start date form field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Start Date and Time',
                  ),
                  initialValue: event.startDateTime.toString(),
                ),
                // end date form field
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

  // function that shows an error dialog if the user did not select an event before clicking edit or delete
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
