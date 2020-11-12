import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../model/event_model.dart';
import '../model/event.dart';
import '../model/view.dart';
import '../model/view_model.dart';

class EventListWidget extends StatefulWidget {
  EventListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  List<Event> events;
  List<View> views;
  final _eventModel = EventModel();
  final _viewModel = ViewModel();

  Event _selectedEvent;

  String viewType = "list";

  @override
  void initState() {
    super.initState();

    _getViews();
    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          // Add an event
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvent,
          ),
          // Edit selected event
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editEvent,
          ),
          // Delete selected event
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteEvent,
          ),
        ],
      ),
      body: _buildEventFinder(),
    );
  }

  // This function returns the body of the event finder
  Widget _buildEventFinder() {
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
              child: viewType == "list" ? _buildListView() : _buildGridView(),
            ),
          ),
        ),
        FlatButton(
          child: Text("Switch View"),
          onPressed: () {
            setState(() {
              if (viewType == "list") {
                viewType = "grid";
              } else if (viewType == "grid") {
                viewType = "list";
              }
            });
          },
        )
      ],
    );
  }

  /* This function returns a list of events displayed in a ListView and obtained
     from a cloud storage */
  Widget _buildListView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) =>
                      _buildEvent(context, document))
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  /* This function returns a grid of events displayed in a GridView with 2 columns
     and obtained from a cloud storage */
  Widget _buildGridView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) =>
                      _buildEvent(context, document))
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  /* This function returns the container of a list tile and handles the selection
     functionality. */
  Widget _buildEvent(BuildContext context, DocumentSnapshot eventData) {
    final event =
        Event.fromMap(eventData.data(), reference: eventData.reference);

    return Container(
      decoration: BoxDecoration(
        border: _selectedEvent != null && event.id == _selectedEvent.id
            ? Border.all(width: 3.0, color: Colors.blueAccent)
            : null,
      ),
      child: GestureDetector(
          child: _buildTile(context, event),
          onTap: () {
            setState(() {
              _selectedEvent = event;
              print("Selected Event: $_selectedEvent");
            });
          }),
    );
  }

  // This function returns the tile representing a single event in the event list
  Widget _buildTile(BuildContext context, Event event) {
    return Card(
      child: ListTile(
        title: Text(event.name),
        subtitle: Text(event.description),
        trailing: Row(
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
      ),
    );
  }

  // Future function of type QuerySnapshot to return all events to the event list, uses instance of eventModel to get events
  Future<QuerySnapshot> getAllEvents() async {
    _eventModel.getAll().then((value) {
      // Print events for debugging purposes
      for (int i = 0; i < value.docs.length; i++) {
        print(value.docs[i].data());
      }
    });
    return await _eventModel.getAll();
  }

  // Future function to add an event to the firestore database, also pushes a snackbar indicating if it was successful
  Future<void> _addEvent() async {
    var event =
        await Navigator.pushNamed(context, "/eventForm", arguments: null);

    // Check if event is not null, navigating back will keep it null
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
      // If an event wasn't selected, show error dialog
      _showAlertDialog();
    }
  }

  // Future function that will bring up the event form with the currently selected event, shows a snackbar if event was successful
  Future<void> _editEvent() async {
    if (_selectedEvent != null) {
      print('selected Event: $_selectedEvent');
      var event = await Navigator.pushNamed(context, '/eventForm',
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
      // If an event wasn't selected, show error dialog
    } else {
      _showAlertDialog();
    }
  }

  // ViewModel to return grades for this view
  Future<List<View>> _getViews() async {
    List<View> views = await _viewModel.getView();
    for (int i = 0; i < views.length; i++) {
      print("Views: ${views[i].viewType}");
    }
    this.views = views;
    return views;
  }

  // Function that shows a dialog that shows quick details about the event selected, pressing dismiss or clicking away will make it disappear
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
                // Event name form field
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                  ),
                  initialValue: event.name,
                ),
                // Event description form field
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Event Description',
                  ),
                  initialValue: event.description,
                ),
                // Start date form field
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Start Date and Time',
                  ),
                  initialValue: event.startDateTime.toString(),
                ),
                // End date form field
                TextFormField(
                  enabled: false,
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

  // Function that shows an error dialog if the user did not select an event before clicking edit or delete
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
