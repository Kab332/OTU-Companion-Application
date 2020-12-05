import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
  var _calendarController = CalendarController();

  Event _selectedEvent;
  List<dynamic> _calendarEvents = [];

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
    ViewModel _viewModel = ViewModel();
    return FutureBuilder(
        future: _getViews(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    child: _buildViewType(),
                  ),
                ),
              ),
              FlatButton(
                child: Text("Switch Views"),
                onPressed: () {
                  setState(() {
                    if (this.views[0].viewType == "calendar") {
                      this.views[0].viewType = "list";
                      _viewModel.updateView(
                          View(id: this.views[0].id, viewType: "list"));
                    } else if (this.views[0].viewType == "list") {
                      this.views[0].viewType = "grid";
                      _viewModel.updateView(
                          View(id: this.views[0].id, viewType: "grid"));
                    } else if (this.views[0].viewType == "grid") {
                      this.views[0].viewType = "calendar";
                      _viewModel.updateView(
                          View(id: this.views[0].id, viewType: "calendar"));
                    }
                  });
                },
              )
            ],
          );
        });
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

  // This function returns a calendar of events displayed using Calendar Table Package, obtained from cloud storage
  Widget _buildCalendarView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot> (
      future: _eventModel.getAll(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // function to map events to their respective date 
          Map<DateTime,List<dynamic>> eventDateMap = getDateEventMap(snapshot);  
          // 3rd party package calendar implementation
          return TableCalendar(
            // list of events that are mapped, places markers on the calendar
            events: eventDateMap,
            calendarController: _calendarController,
            // onTap Day selection for the calendar 
            onDaySelected: (day, events, holidays) {
              setState(() {
                // setting the calendar events for the particular day selected, used to create a scrollable list of elements to select and edit/delete
                _calendarEvents = events;
              });
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }

  // function that returns a widget list of all the events as buttons to select, edit and delete
  Widget _buildCalendarButtons() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: _calendarEvents
          .map((event) => Container(
            decoration: BoxDecoration(
              border: _selectedEvent != null && event.id == _selectedEvent.id
              ? Border.all(width: 3.0, color: Colors.blue)
              : Border.all(width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: _buildTile(context, event),
              onTap: () {
                setState(() {
                  _selectedEvent = event;
                }
              );
            }
          ),
        )).toList(),
      ),
    );
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
        var snackbar = SnackBar(
            content: Text("Event has been added."),
            action: SnackBarAction(
                label: "Dismiss",
                onPressed: () {
                  Scaffold.of(context).hideCurrentSnackBar();
                }));
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
        var snackbar = SnackBar(
            content: Text("Event has been deleted."),
            action: SnackBarAction(
                label: "Dismiss",
                onPressed: () {
                  Scaffold.of(context).hideCurrentSnackBar();
                }));
        Scaffold.of(context).showSnackBar(snackbar);
        _calendarController.setSelectedDay(DateTime.now(), isProgrammatic: true, animate: true, runCallback: true);
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
          var snackbar = SnackBar(
              content: Text("Event has been edited."),
              action: SnackBarAction(
                  label: "Dismiss",
                  onPressed: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                  }));
          Scaffold.of(context).showSnackBar(snackbar);
          _calendarController.setSelectedDay(newEvent.startDateTime, isProgrammatic: true, animate: true, runCallback: true);
          _selectedEvent = null;
        });
      }
      setState(() {
        
      });
      // If an event wasn't selected, show error dialog
    } else {
      _showAlertDialog();
    }
  }

  // ViewModel to return grades for this view
  Future<List<View>> _getViews() async {
    List<View> views = await _viewModel.getViews();
    for (int i = 0; i < views.length; i++) {
      print("Views: ${views[i].toMap()}");
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
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                  initialValue: event.location,
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

  // function to assess which current view it is and displays that user to the user
  Widget _buildViewType() {
    if (this.views != null) {
      switch (this.views[0].viewType) {
      case 'list':
        return _buildListView();
      case 'grid':
        return _buildGridView();
      case 'calendar':
        return Column(
          children: <Widget>[
            _buildCalendarView(),
            Expanded(
              child: _buildCalendarButtons(),
            ),
          ],
        );
      }
    }
    return null;
  }

  // utility function to map the starting event date and time to the list of event names for that day
  Map<DateTime, List<dynamic>> getDateEventMap(AsyncSnapshot snapshot) {
    Map<DateTime, List<dynamic>> eventDateMap = {};
    for (int i = 0; i < snapshot.data.docs.length; i++) {
      var event = Event.fromMap(snapshot.data.docs[i].data(), reference: snapshot.data.docs[i].reference);
      DateTime currentDate = DateTime(event.startDateTime.year, event.startDateTime.month, event.startDateTime.day, 0, 0);
      if (eventDateMap[currentDate] == null) {
        eventDateMap[currentDate] = [event];
      } else {
        eventDateMap[currentDate].add(event);
      }
    }
    print('eventDateMap: $eventDateMap');
    return eventDateMap;
  }
}
