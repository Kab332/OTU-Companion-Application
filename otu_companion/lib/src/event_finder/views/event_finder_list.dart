import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'package:otu_companion/src/event_finder/model/notification_utilities.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
  List<View> views;
  EventModel _eventModel = EventModel();
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
    // initializing time zones, notification and getting views
    tz.initializeTimeZones();
    _eventNotifications.init();
    _getViews();
  }

  @override
  Widget build(BuildContext context) {
    // authenticate and get current user 
    user = _authenticationService.getCurrentUser();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: MainSideDrawer(),
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

  // Building the buttons to switch between joined and all events views
  Widget _buildEventButtons() {
    return Row(children: [
      // The joined events button
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // Removing circular border
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            // If we're in user view (so this button is selected) the colour is blue otherwise it is grey
            color: userView == true ? Colors.blue : Colors.grey[350],
            child: Text(FlutterI18n.translate(
                context, "eventFinderList.buttonLabels.joinedEvents")),
            onPressed: () {
              setState(() {
                // Setting user view and deselecting event and date
                userView = true;
                _selectedEvent = null;
                _selectedDate = null;
                _selectedColumn = null;

                // Refreshing Calendar if we were in calendar view
                if (this.views != null &&
                    this.views[0].viewType == "Calendar") {
                  _calendarController.setSelectedDay(_currentDate);
                  _showCustomSnackBar(FlutterI18n.translate(context,
                      "eventFinderList.snackBarLabels.refreshCalendar"));
                }
                _calendarEvents.clear();
              });
            },
          ),
          flex: 2),
      // Same as above but for all events
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: userView == false ? Colors.blue : Colors.grey[350],
            child: Text(FlutterI18n.translate(
                context, "eventFinderList.buttonLabels.allEvents")),
            onPressed: () {
              setState(() {
                userView = false;
                _selectedEvent = null;
                _selectedDate = null;
                _selectedColumn = null;

                // if current view is calendar view, refresh calendar and set selected day
                if (this.views != null &&
                    this.views[0].viewType == "Calendar") {
                  _calendarController.setSelectedDay(_currentDate);
                  _showCustomSnackBar(FlutterI18n.translate(context,
                      "eventFinderList.snackBarLabels.refreshCalendar"));
                }
                // clear calendar buttons array
                _calendarEvents.clear();
              });
            },
          ),
          flex: 2),
    ]);
  }

  // Building the buttons to switch to Calendar/List/Table views
  Widget _buildViewButtons() {
    return Row(children: [
      // Calendar button
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // Removing circular border
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            // If the views is calendar (so this button is selected), it's blue otherwise it's grey
            color: this.views != null && this.views[0].viewType == "Calendar"
                ? Colors.blue
                : Colors.grey[350],
            child: Text(FlutterI18n.translate(
                context, "eventFinderList.buttonLabels.calendarView")),
            onPressed: () {
              setState(() {
                // Setting view type to calendar and resetting it Calendar selection and events shown
                this.views[0].viewType = "Calendar";
                _selectedEvent = null;
                _selectedDate = null;
                _selectedColumn = null;
                _calendarEvents.clear();
                _viewModel.updateView(
                    View(id: this.views[0].id, viewType: "Calendar"));
              });
            },
          ),
          flex: 2),
      // List button, works similarly to above but for list
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: this.views != null && this.views[0].viewType == "List"
                ? Colors.blue
                : Colors.grey[350],
            child: Text(FlutterI18n.translate(
                context, "eventFinderList.buttonLabels.listView")),
            onPressed: () {
              // set view to list view and clear variables, 
              setState(() {
                this.views[0].viewType = "List";
                _selectedEvent = null;
                _selectedDate = null;
                _selectedColumn = null;
                _calendarEvents.clear();
                _viewModel
                    .updateView(View(id: this.views[0].id, viewType: "List"));
              });
            },
          ),
          flex: 2),
      // Table button, works similarly to above but for table
      Expanded(
          child: RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0)),
            color: this.views != null && this.views[0].viewType == 'Table'
                ? Colors.blue
                : Colors.grey[350],
            child: Text(FlutterI18n.translate(
                context, "eventFinderList.buttonLabels.tableView")),
            onPressed: () {
              // set view to table and clear variables
              setState(() {
                this.views[0].viewType = 'Table';
                _selectedEvent = null;
                _selectedDate = null;
                _selectedColumn = null;
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
    return FutureBuilder<QuerySnapshot>(
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty) {
              return ListView(
                children: snapshot.data.docs
                    .map((DocumentSnapshot document) =>
                        _buildEvent(context, document))
                    .toList(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    FlutterI18n.translate(
                      context, "eventFinderList.messages.noEvents"
                    ),
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  /* This function returns a list of events displayed in a DataTable and obtained
     from a cloud storage */
  Widget _buildTableView() {
    return FutureBuilder<QuerySnapshot>(
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty) {
              return Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: userView == false,
                      dataRowHeight: 100.0,
                      columns: <DataColumn>[
                        DataColumn(
                          label: userView == true
                              ? Text(
                                  FlutterI18n.translate(context,
                                      "eventFinderList.tableLabels.leaveEvent"),
                                )
                              : Text(
                                  FlutterI18n.translate(context,
                                      "eventFinderList.tableLabels.joinEvent"),
                                ),
                        ),
                        DataColumn(
                          label: Text(
                            FlutterI18n.translate(context,
                                "eventFinderList.tableLabels.viewDetails"),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            FlutterI18n.translate(
                                context, "eventFinderList.tableLabels.name"),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            FlutterI18n.translate(context,
                                "eventFinderList.tableLabels.description"),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            FlutterI18n.translate(
                                context, "eventFinderList.tableLabels.startDate"),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            FlutterI18n.translate(
                                context, "eventFinderList.tableLabels.endDate"),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            FlutterI18n.translate(
                                context, "eventFinderList.tableLabels.location"),
                          ),
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
                                  // Join or leave event button
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
                                  // View icon
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
                                  // Event name
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
                                  // Event description
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
                                  // Event start date
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
                                  // Event end date
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
                                  // Event location
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
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    FlutterI18n.translate(
                      context, "eventFinderList.messages.noEvents"
                    ),
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  // This function returns a calendar of events displayed using Calendar Table Package, obtained from cloud storage
  Widget _buildCalendarView() {
    return FutureBuilder<QuerySnapshot>(
        future: userView == true
            ? _eventModel.getUserEvents(user.uid)
            : _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            // Function to map events to their respective date
            Map<DateTime, List<dynamic>> eventDateMap =
                getDateEventMap(snapshot);
            // 3rd party package calendar implementation
            return TableCalendar(
              // List of events that are mapped, places markers on the calendar
              events: eventDateMap,
              calendarController: _calendarController,
              // onTap Day selection for the calendar
              onDaySelected: (day, events, holidays) {
                setState(() {
                  // If we have an event picked and we change to another day, the selected event is deselected
                  if (compareDates(day, _selectedDate) == false) {
                    _selectedEvent = null;
                  }
                  // Setting the calendar events for the particular day selected, used to create a scrollable list of elements to select and edit/delete
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

  // Function that returns a widget list of all the events as buttons to select, edit and delete
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
                          _selectedEvent = event;
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
        _showCustomSnackBar(FlutterI18n.translate(
            context, "eventFinderList.snackBarLabels.eventAdded"));

        // Refreshing calendar on add
        if (this.views[0].viewType == "Calendar") {
          _selectedDate = null;
          _calendarController.setSelectedDay(_currentDate);
          _calendarEvents.clear();
          _showCustomSnackBar(FlutterI18n.translate(
              context, "eventFinderList.snackBarLabels.refreshCalendar"));
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
        _showCustomSnackBar(FlutterI18n.translate(
            context, "eventFinderList.snackBarLabels.eventDeleted"));
        if (this.views[0].viewType == "Calendar") {
          _calendarEvents.remove(_selectedEvent);
        }

        _selectedEvent = null;
      });
    } else {
      // If an event wasn't selected (just in case something goes wrong)
      _showCustomDialog(
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.selectTitle"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.selectDescription"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.dismissButton"));
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
          _showCustomSnackBar(FlutterI18n.translate(
              context, "eventFinderList.snackBarLabels.eventEdited"));

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
          _selectedColumn = null;
        });
      }
    }
    // If an event wasn't selected (just in case something goes wrong)
    else {
      _showCustomDialog(
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.selectTitle"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.selectDescription"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.dismissButton"));
    }
  }

  // ViewModel to return grades for this view
  Future<List<View>> _getViews() async {
    List<View> views = await _viewModel.getViews();
    for (int i = 0; i < views.length; i++) {
      print("Views: ${views[i].toMap()}");
    }

    // refresh and assign to global variable
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
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(
                        context, "eventFinderList.formLabels.name"),
                  ),
                  initialValue: event.name,
                ),
                // Event description form field
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(
                        context, "eventFinderList.formLabels.description"),
                  ),
                  maxLines: 5,
                  initialValue: event.description,
                ),
                // Start date form field
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(
                        context, "eventFinderList.formLabels.startDate"),
                  ),
                  initialValue: event.startDateTime.toString(),
                ),
                // End date form field
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(
                        context, "eventFinderList.formLabels.endDate"),
                  ),
                  initialValue: event.endDateTime.toString(),
                ),
                // Location form field
                TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: FlutterI18n.translate(
                        context, "eventFinderList.formLabels.location"),
                  ),
                  initialValue: event.location,
                ),
                // Showing map based on location
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      minZoom: 5.0,
                      zoom: 10.0,
                      maxZoom: 20.0,
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

  // Function to assess which current view it is and displays that user to the user
  Widget _buildViewType() {
    if (this.views != null) {
      switch (this.views[0].viewType) {
        case 'List':
          return _buildListView();
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

  // Utility function to map the starting event date and time to the list of event names for that day
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

  /* This function navigates to event stats page and passes an argument based on
     whether or not the app is in user view */
  void _checkStats() {
    if (userView == true) {
      Navigator.pushNamed(context, "/eventStats", arguments: user.uid);
    } else {
      Navigator.pushNamed(context, "/eventStats", arguments: null);
    }
  }

  // This function calls showDialog inside, created to reduce code
  void _showCustomDialog(String title, String content, String button) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text(button),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // This creates a custom snackbar with its content based on the argument
  void _showCustomSnackBar(String content) {
    var snackbar = SnackBar(
        content: Text(content),
        action: SnackBarAction(
            label: FlutterI18n.translate(
                context, "eventFinderList.snackBarLabels.dismissButton"),
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            }));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  /* This function handles the leading button in the event tile which will have
     different functionality based on what view the user is in and their relationship
     with the event */
  void _manageEvent(Event event) {
    /* If the user created this event then we tell them they did because they
       should not be able to join or leave it */
    if (user.uid == event.createdBy) {
      _showCustomDialog(
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.yourEventTitle"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.yourEventDescription"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.dismissButton"));
    }
    // If we're in user view then the button will have the remove functionality
    else if (userView == true) {
      print("Remove from list");
      setState(() {
        if (this.views[0].viewType == "Calendar") {
          _calendarEvents.remove(event);
        }

        event.participants.remove(user.uid);
        _eventModel.update(event);
        _showCustomSnackBar(FlutterI18n.translate(
            context, "eventFinderList.snackBarLabels.eventLeft"));
      });
    }
    /* If we're in all events view and the user is a part of the event then we 
       let them know, they can leave the event in joined events view */
    else if (event.participants.contains(user.uid)) {
      _showCustomDialog(
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.joinedEventTitle"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.joinedEventDescription"),
          FlutterI18n.translate(
              context, "eventFinderList.dialogLabels.dismissButton"));
    }
    /* If the user is not in event and we're in all events view, then the only
       option left is to join the event */
    else {
      print("Add to list");
      print(event);
      setState(() {
        event.participants.add(user.uid);
        _eventModel.update(event);
        _showCustomSnackBar(FlutterI18n.translate(
            context, "eventFinderList.snackBarLabels.eventJoined"));
        sendNotification(event);
      });
    }
  }

  // void function to send a notification now or later, depending on the start date 
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

  // A function to compare dates based on only day, month, and year
  bool compareDates(DateTime date1, DateTime date2) {
    if (date1 == null || date2 == null) {
      return false;
    } else if (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year) {
      return true;
    } else {
      return false;
    }
  }
}
