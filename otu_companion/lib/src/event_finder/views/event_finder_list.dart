import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/event_finder/model/notification_utilities.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../model/event_model.dart';
import '../model/event.dart';
import '../model/view.dart';
import '../model/view_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

class EventListWidget extends StatefulWidget {
  EventListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  // List<Event> events;
  List<View> views;
  final _eventModel = EventModel();
  final _viewModel = ViewModel();
  AuthenticationService _authenticationService = AuthenticationService();
  CalendarController _calendarController = CalendarController();
  final _eventNotifications = EventNotifications();

  Event _selectedEvent;
  List<dynamic> _calendarEvents = [];
  DateTime _selectedDate;
  DateTime _currentDate = DateTime.now();
  String _selectedColumn;

  LatLng _centre = LatLng(43.945947115276184, -78.89606283789982);

  bool userView = true;

  User user;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _eventNotifications.init();

    _getViews();
  }

  @override
  Widget build(BuildContext context) {
    user = _authenticationService.getCurrentUser();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
        // If we're in the user view, then these buttons aren't shown
        actions: userView == true
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.insert_chart, color: Colors.white),
                  onPressed: _checkStats,
                ),
              ]
            : <Widget>[
                // Add an event
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addEvent,
                ),
                /* Edit selected event, disabled if no event is selected or this
                   event was not created by the user */
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _selectedEvent == null
                        ? null
                        : _selectedEvent.createdBy != user.uid
                            ? null
                            : () {
                                _editEvent();
                              }),
                /* Delete selected event, disabled if no event is selected or this
                   event was not created by the user */
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _selectedEvent == null
                        ? null
                        : _selectedEvent.createdBy != user.uid
                            ? null
                            : () {
                                _deleteEvent();
                              }),
                // Go to the stat page
                IconButton(
                  icon: Icon(Icons.insert_chart, color: Colors.white),
                  onPressed: _checkStats,
                ),
              ],
      ),
      body: Container(
        child: Column(children: [
          Column(children: [
            _buildEventButtons(),
            _buildViewButtons(),
          ]),
          Expanded(child: _buildEventFinder(), flex: 2),
        ]),
      ),
    );
  }

  Widget _buildEventButtons() {
    return Row(children: [
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: userView == true ? Colors.blue : Colors.grey[350],
            child: Text("Joined Events"),
            onPressed: () {
              setState(() {
                userView = true;
                _selectedEvent = null;
                _selectedDate = null;

                if (this.views != null &&
                    this.views[0].viewType == "Calendar") {
                  _calendarController.setSelectedDay(_currentDate);
                  _showCustomSnackBar("Calendar has been refreshed.");
                }

                _calendarEvents.clear();
              });
            },
          ),
          flex: 2),
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: userView == false ? Colors.blue : Colors.grey[350],
            child: Text("All Events"),
            onPressed: () {
              setState(() {
                userView = false;
                _selectedEvent = null;
                _selectedDate = null;

                if (this.views != null &&
                    this.views[0].viewType == "Calendar") {
                  _calendarController.setSelectedDay(_currentDate);
                  _showCustomSnackBar("Calendar has been refreshed.");
                }

                _calendarEvents.clear();
              });
            },
          ),
          flex: 2),
    ]);
  }

  Widget _buildViewButtons() {
    return Row(children: [
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: this.views != null && this.views[0].viewType == "Calendar"
                ? Colors.blue
                : Colors.grey[350],
            child: Text("Calendar"),
            onPressed: () {
              setState(() {
                this.views[0].viewType = "Calendar";
                _selectedEvent = null;
                _selectedDate = null;
                _calendarEvents.clear();
                _viewModel.updateView(
                    View(id: this.views[0].id, viewType: "Calendar"));
              });
            },
          ),
          flex: 2),
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: this.views != null && this.views[0].viewType == "List"
                ? Colors.blue
                : Colors.grey[350],
            child: Text("List"),
            onPressed: () {
              setState(() {
                this.views[0].viewType = "List";
                _selectedEvent = null;
                _selectedDate = null;
                _calendarEvents.clear();
                _viewModel
                    .updateView(View(id: this.views[0].id, viewType: "List"));
              });
            },
          ),
          flex: 2),
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: this.views != null && this.views[0].viewType == 'Table'
                ? Colors.blue
                : Colors.grey[350],
            child: Text("Table"),
            onPressed: () {
              setState(() {
                this.views[0].viewType = 'Table';
                _selectedEvent = null;
                _selectedDate = null;
                _calendarEvents.clear();
                _viewModel
                    .updateView(View(id: this.views[0].id, viewType: "Table"));
              });
            },
          ),
          flex: 2),
    ]);
  }

  // This function returns the body of the event finder
  Widget _buildEventFinder() {
    return FutureBuilder(
        future: _getViews(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: _buildViewType(),
            ),
          );
        });
  }

  /* This function returns a list of events displayed in a ListView and obtained
     from a cloud storage */
  Widget _buildListView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
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
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
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

  /* This function returns a list of events displayed in a DataTable and obtained
     from a cloud storage */
  Widget _buildTableView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: userView == false,
                    showBottomBorder: true,
                    dataRowHeight: 100.0,
                    columns: <DataColumn>[
                      DataColumn(
                        label: userView == true
                            ? Text('Leave Event?')
                            : Text('Join Event?'),
                      ),
                      DataColumn(
                        label: Text('View Details'),
                      ),
                      DataColumn(
                        label: Text('Event Name'),
                      ),
                      DataColumn(
                        label: Text('Description'),
                      ),
                      DataColumn(
                        label: Text('Start Date'),
                      ),
                      DataColumn(
                        label: Text('End Date'),
                      ),
                      DataColumn(
                        label: Text('Location'),
                      ),
                    ],
                    rows: snapshot.data.docs
                        .map((document) => DataRow(
                              selected: userView == false &&
                                  _selectedColumn == document.id,
                              onSelectChanged: (val) {
                                setState(() {
                                  _selectedEvent = Event.fromMap(
                                      document.data(),
                                      reference: document.reference);
                                  _selectedColumn = document.id;
                                });
                              },
                              cells: <DataCell>[
                                // join or leave event button
                                DataCell(
                                  IconButton(
                                      icon: user.uid ==
                                              Event.fromMap(document.data(),
                                                      reference:
                                                          document.reference)
                                                  .createdBy
                                          ? Icon(
                                              Icons.person,
                                              color: Colors.blue,
                                            )
                                          : userView == true
                                              ? Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                )
                                              : Event.fromMap(document.data(),
                                                          reference: document
                                                              .reference)
                                                      .participants
                                                      .contains(user.uid)
                                                  ? Icon(
                                                      Icons.people,
                                                      color: Colors.blue,
                                                    )
                                                  : Icon(Icons.add,
                                                      color: Colors.green),
                                      onPressed: () {
                                        _manageEvent(Event.fromMap(
                                            document.data(),
                                            reference: document.reference));
                                      }),
                                ),
                                // view icon
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      _showViewDialog(
                                          context,
                                          Event.fromMap(document.data(),
                                              reference: document.reference));
                                    },
                                  ),
                                ),
                                // event name
                                DataCell(
                                  Text(Event.fromMap(document.data(),
                                          reference: document.reference)
                                      .name),
                                  onTap: () {
                                    setState(() {
                                      _selectedColumn = document.id;
                                      _selectedEvent = Event.fromMap(
                                          document.data(),
                                          reference: document.reference);
                                    });
                                  },
                                ),
                                // event description
                                DataCell(
                                  Container(
                                      width: 200.0,
                                      child: Text(Event.fromMap(document.data(),
                                              reference: document.reference)
                                          .description)),
                                  onTap: () {
                                    _selectedEvent = Event.fromMap(
                                        document.data(),
                                        reference: document.reference);
                                  },
                                ),
                                // event start date
                                DataCell(
                                  Text(Event.fromMap(document.data(),
                                          reference: document.reference)
                                      .startDateTime
                                      .toLocal()
                                      .toString()),
                                  onTap: () {
                                    _selectedEvent = Event.fromMap(
                                        document.data(),
                                        reference: document.reference);
                                  },
                                ),
                                // event end date
                                DataCell(
                                  Text(Event.fromMap(document.data(),
                                          reference: document.reference)
                                      .endDateTime
                                      .toLocal()
                                      .toString()),
                                  onTap: () {
                                    _selectedEvent = Event.fromMap(
                                        document.data(),
                                        reference: document.reference);
                                  },
                                ),
                                // event location
                                DataCell(
                                  Text(Event.fromMap(document.data(),
                                          reference: document.reference)
                                      .location),
                                  onTap: () {
                                    _selectedEvent = Event.fromMap(
                                        document.data(),
                                        reference: document.reference);
                                  },
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  // This function returns a calendar of events displayed using Calendar Table Package, obtained from cloud storage
  Widget _buildCalendarView() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // function to map events to their respective date
            Map<DateTime, List<dynamic>> eventDateMap =
                getDateEventMap(snapshot);
            // 3rd party package calendar implementation
            return TableCalendar(
              // list of events that are mapped, places markers on the calendar
              events: eventDateMap,
              calendarController: _calendarController,
              // onTap Day selection for the calendar
              onDaySelected: (day, events, holidays) {
                setState(() {
                  // If we have an event picked and we change to another day, the selected event is deselected
                  if (compareDates(day, _selectedDate) == false) {
                    _selectedEvent = null;
                  }
                  // setting the calendar events for the particular day selected, used to create a scrollable list of elements to select and edit/delete
                  _calendarEvents = events;
                  _selectedDate = day;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  // function that returns a widget list of all the events as buttons to select, edit and delete
  Widget _buildCalendarButtons() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: _calendarEvents
            .map((event) => Container(
                  decoration: BoxDecoration(
                    border:
                        _selectedEvent != null && event.id == _selectedEvent.id
                            ? Border.all(width: 3.0, color: Colors.blue)
                            : Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                      title: _buildTile(context, event),
                      onTap: () {
                        setState(() {
                          print("SELECTED EVENT INITIAL: " +
                              _selectedEvent.toString());
                          _selectedEvent = event;
                          print("SELECTED EVENT FINAL: " +
                              _selectedEvent.toString());
                        });
                      }),
                ))
            .toList(),
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
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: user.uid == event.createdBy
                    ? Icon(
                        Icons.person,
                        color: Colors.blue,
                      )
                    : userView == true
                        ? Icon(
                            Icons.cancel,
                            color: Colors.red,
                          )
                        : event.participants.contains(user.uid)
                            ? Icon(
                                Icons.people,
                                color: Colors.blue,
                              )
                            : Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  _manageEvent(event);
                }),
          ],
        ),
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
    var result =
        await Navigator.pushNamed(context, "/eventForm", arguments: null);

    Event event = result;

    // Check if event is not null, navigating back will keep it null
    if (event != null) {
      event.createdBy = user.uid;
      event.participants = [user.uid];
      setState(() {
        _eventModel.insert(event);
        _showCustomSnackBar("Event has been added.");

        // Refreshing calendar on add
        if (this.views[0].viewType == "Calendar") {
          _selectedDate = null;
          _calendarController.setSelectedDay(_currentDate);
          _calendarEvents.clear();
          _showCustomSnackBar("Calendar has been refreshed.");
        }
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
        _showCustomSnackBar("Event has been deleted.");
        if (this.views[0].viewType == "Calendar") {
          _calendarEvents.remove(_selectedEvent);
        }

        _selectedEvent = null;
      });
    } else {
      // If an event wasn't selected (just in case something goes wrong)
      _showCustomDialog("Error!", "Please select an event first!");
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
        newEvent.createdBy = _selectedEvent.createdBy;
        newEvent.participants = _selectedEvent.participants;
        newEvent.reference = _selectedEvent.reference;
        setState(() {
          _eventModel.update(newEvent);
          _showCustomSnackBar("Event has been edited.");

          // If we're in calendar view
          if (this.views[0].viewType == "Calendar") {
            // If the selected date and the editted event's date are on the same (day, month, year)
            if (compareDates(_selectedDate, newEvent.startDateTime)) {
              // If the selectedEvent exists in calendarEvents (just in case to avoid -1 index)
              if (_calendarEvents.indexOf(_selectedEvent) >= 0) {
                _calendarEvents[_calendarEvents.indexOf(_selectedEvent)] =
                    newEvent;
              }
            } else {
              _calendarEvents.remove(_selectedEvent);
            }
          }

          _selectedEvent = null;
        });
      }
      // If an event wasn't selected (just in case something goes wrong)
    } else {
      _showCustomDialog("Error!", "Please select an event first!");
    }
  }

  // ViewModel to return grades for this view
  Future<List<View>> _getViews() async {
    List<View> views = await _viewModel.getViews();
    for (int i = 0; i < views.length; i++) {
      print("Views: ${views[i].toMap()}");
    }

    if (this.views == null) {
      setState(() {
        this.views = views;
      });
    } else {
      this.views = views;
    }

    return views;
  }

  // Function that shows a dialog that shows quick details about the event selected, pressing dismiss or clicking away will make it disappear
  void _showViewDialog(BuildContext context, Event event) {
    _centre = LatLng(event.geoPoint.latitude, event.geoPoint.longitude);
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
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
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      minZoom: 5.0,
                      zoom: 10.0,
                      maxZoom: 20.0,
                      //center: selectedEvent.location != null ? selectedEvent.location : _centre,
                      center: _centre,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        additionalOptions: {
                          'accessToken':
                              'pk.eyJ1IjoibGVvbi1jaG93MSIsImEiOiJja2hyMGRteWcwNjh0MzBteXh1NXNibHY0In0.nFSqVO-aIMytp_hQWKmXXQ',
                          'id': 'mapbox.mapbox-streets-v8'
                        },
                        subdomains: ['a', 'b', 'c'],
                      ),
                      new MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 70.0,
                            height: 70.0,
                            point: _centre,
                            builder: (context) => Container(
                                child: IconButton(
                              color: Colors.red,
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                print('Clicked icon!');
                              },
                            )),
                          )
                        ],
                      ),
                    ],
                  ),
                  flex: 2,
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

  // function to assess which current view it is and displays that user to the user
  Widget _buildViewType() {
    if (this.views != null) {
      switch (this.views[0].viewType) {
        case 'List':
          return _buildListView();
        case 'Grid':
          return _buildGridView();
        case 'Calendar':
          return Column(
            children: <Widget>[
              _buildCalendarView(),
              Expanded(
                child: _buildCalendarButtons(),
              ),
            ],
          );
        case 'Table':
          return _buildTableView();
      }
    }
    return null;
  }

  // utility function to map the starting event date and time to the list of event names for that day
  Map<DateTime, List<dynamic>> getDateEventMap(AsyncSnapshot snapshot) {
    Map<DateTime, List<dynamic>> eventDateMap = {};
    for (int i = 0; i < snapshot.data.docs.length; i++) {
      var event = Event.fromMap(snapshot.data.docs[i].data(),
          reference: snapshot.data.docs[i].reference);
      DateTime currentDate = DateTime(event.startDateTime.year,
          event.startDateTime.month, event.startDateTime.day, 0, 0);
      if (eventDateMap[currentDate] == null) {
        eventDateMap[currentDate] = [event];
      } else {
        eventDateMap[currentDate].add(event);
      }
    }
    print('eventDateMap: $eventDateMap');
    return eventDateMap;
  }

  void _checkStats() {
    if (userView == true) {
      Navigator.pushNamed(context, "/eventStats", arguments: user.uid);
    } else {
      Navigator.pushNamed(context, "/eventStats", arguments: null);
    }
  }

  // This function calls showDialog inside, created to reduce code
  void _showCustomDialog(String title, String content) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showCustomSnackBar(String content) {
    var snackbar = SnackBar(
        content: Text(content),
        action: SnackBarAction(
            label: "Dismiss",
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            }));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void _manageEvent(Event event) {
    if (user.uid == event.createdBy) {
      _showCustomDialog("Your Event", "You created this event.");
    } else if (userView == true) {
      print("Remove from list");
      setState(() {
        if (this.views[0].viewType == "Calendar") {
          _calendarEvents.remove(event);
        }

        event.participants.remove(user.uid);
        _eventModel.update(event);
        _showCustomSnackBar("You have left the event.");
      });
    } else if (event.participants.contains(user.uid)) {
      _showCustomDialog("Joined Event", "You are in this event.");
    } else {
      print("Add to list");
      print(event);
      setState(() {
        event.participants.add(user.uid);
        _eventModel.update(event);
        _showCustomSnackBar("You have joined the event.");
        sendNotification(event);
      });
    }
  }

  void sendNotification(Event event) {
    var secondsDiff = (event.startDateTime.millisecondsSinceEpoch -
            tz.TZDateTime.now(tz.local).millisecondsSinceEpoch) ~/
        1000;

    // If the start date is greater than one day, send a notification later,
    if (secondsDiff > 0) {
      if (secondsDiff >= 86400) {
        var later = tz.TZDateTime.now(tz.local)
            .add(Duration(seconds: secondsDiff - 86400));
        _eventNotifications.sendNotificationLater(event.name, event.description,
            later, event.reference != null ? event.reference.id : null);
      } else {
        // Otherwise send the notification now
        _eventNotifications.sendNotificationNow(event.name, event.description,
            event.reference != null ? event.reference.id : null);
      }
    }
  }

  bool compareDates(DateTime date1, DateTime date2) {
    if (date1 == null || date2 == null) {
      return false;
    }

    if (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year) {
      return true;
    } else {
      return false;
    }
  }
}
