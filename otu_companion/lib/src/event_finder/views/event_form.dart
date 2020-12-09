import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

import '../model/event.dart';
import '../model/notification_utilities.dart';

class EventFormPage extends StatefulWidget {
  EventFormPage({Key key, this.title, this.event}) : super(key: key);

  final Event event;
  final String title;

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventNotifications = EventNotifications();

  String _name = '';
  String _description = '';
  String _location = '';
  GeoPoint _geoPoint;
  TextEditingController _locationController;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  bool _startSet = false;
  bool _endSet = false;

  bool locationException = true;

  double _zoom = 10.0;
  Marker marker;
  LatLng _centre = LatLng(43.945947115276184, -78.89606283789982);
  var geocoder = GeocodingPlatform.instance;
  MapController mapController = new MapController();

  Event selectedEvent;

  @override
  void initState() {
    super.initState();

    selectedEvent = widget.event != null ? widget.event : null;
    tz.initializeTimeZones();
    _eventNotifications.init();

    if (selectedEvent != null) {
      _locationController =
          new TextEditingController(text: selectedEvent.location);
      // getPosition(false);
    } else {
      _locationController = new TextEditingController();
      // getPosition(true);
    }

    getPosition(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        // Some UI design for the form
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  _buildTextFormField("Event Name"),
                  _buildTextFormField("Description"),
                  _buildDate("Start Date"),
                  _buildTime("Start Time"),
                  _buildDate("End Date"),
                  _buildTime("End Time"),
                  _buildLocationFormField(),
                  _buildLocationFormButton(),
                  Row(children: [_buildMapButtons(), _buildLocation()]),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handling validation here, also sending the event back to the function that invoked this
          if (_formKey.currentState.validate()) {
            Event event = Event(
              name: _name != "" ? _name : selectedEvent.name,
              description:
                  _description != "" ? _description : selectedEvent.description,
              startDateTime: _startSet == false && selectedEvent != null
                  ? selectedEvent.startDateTime
                  : _startDate,
              endDateTime: _endSet == false && selectedEvent != null
                  ? selectedEvent.endDateTime
                  : _endDate,
              location: _location != "" ? _location : '',
              geoPoint: _geoPoint != null ? _geoPoint : GeoPoint(0, 0),
            );
            // Calculating the difference in milliseconds between the event start date and the time it is not
            var secondsDiff = (event.startDateTime.millisecondsSinceEpoch -
                    tz.TZDateTime.now(tz.local).millisecondsSinceEpoch) ~/
                1000;

            // If the start date is greater than one day, send a notification later,
            if (secondsDiff > 0) {
              if (secondsDiff >= 86400) {
                var later = tz.TZDateTime.now(tz.local)
                    .add(Duration(seconds: secondsDiff - 86400));
                _eventNotifications.sendNotificationLater(
                    event.name,
                    event.description,
                    later,
                    event.reference != null ? event.reference.id : null);
              } else {
                // Otherwise send the notification now
                _eventNotifications.sendNotificationNow(
                    event.name,
                    event.description,
                    event.reference != null ? event.reference.id : null);
              }
            }

            // Go back to event list
            Navigator.pop(context, event);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  /*  This function returns a TextFormField based on the argument provided. At 
      the moment this function can cover the event name, description, and 
      imageURL fields (although the imageURL component of the event class has
      not been fully implemented yet). The label, initial value, and the value
      changed are all based on the argument.  */
  Widget _buildTextFormField(String type) {
    String typeVal = "";

    if (type == "Event Name" && selectedEvent != null) {
      typeVal = selectedEvent.name;
    } else if (type == "Description" && selectedEvent != null) {
      typeVal = selectedEvent.description;
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: type,
      ),
      autovalidateMode: AutovalidateMode.always,
      initialValue: selectedEvent != null ? typeVal : '',
      // Validation to check if empty or not 9 numbers
      validator: (String value) {
        if (value.isEmpty) {
          return 'Error: Please enter ' + type + '!';
        }
        return null;
      },
      onChanged: (String newValue) {
        if (type == "Event Name") {
          _name = newValue;
        } else if (type == "Description") {
          _description = newValue;
        }
      },
    );
  }

  /*  This function returns a container consisting of the date related 
      components. The function is designed to handle both the start and
      end dates based on the argument entered.  */
  Widget _buildDate(String type) {
    DateTime _date = DateTime.now();

    // If this function is supposed to build the start date...
    if (type == "Start Date") {
      /* If this form is an edit request (there's a selected event), and a 
         value for the start date has not been picked yet... */
      if (selectedEvent != null && _startSet == false) {
        _date = selectedEvent.startDateTime;
        _startDate = _date;
      } else {
        _date = _startDate;
      }
    }
    /* Otherwise if this function is supposed to build end date, similar 
       logic to above... */
    else if (type == "End Date") {
      if (selectedEvent != null && _endSet == false) {
        _date = selectedEvent.endDateTime;
        _endDate = _date;
      } else {
        _date = _endDate;
      }
    }

    return Container(
      child: Row(
        children: [
          Text(
            type + ": ",
            style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
          ),
          Text(_date.day.toString() +
              "/" +
              _date.month.toString() +
              "/" +
              _date.year.toString()),
          FlatButton(
            child: Text("Select"),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2150))
                  .then((value) {
                setState(() {
                  _date = DateTime(
                    value != null ? value.year : _date.year,
                    value != null ? value.month : _date.month,
                    value != null ? value.day : _date.day,
                    _date.hour,
                    _date.minute,
                    0,
                  );
                  // Setting values based on whether this is a start or end date picker
                  if (type == "Start Date") {
                    _startDate = _date;
                    _startSet = true;
                  } else if (type == "End Date") {
                    _endDate = _date;
                    _endSet = true;
                  }
                  print(type + ": " + _date.toString());
                });
              });
            },
          ),
        ],
      ),
    );
  }

  /* This function is similar to the previous function but is for time related
     components instead. It handles both start and end times based on argument. */
  Widget _buildTime(String type) {
    DateTime _date = DateTime.now();
    TimeOfDay _time = TimeOfDay.now();

    if (type == "Start Time") {
      if (selectedEvent != null && _startSet == false) {
        _date = selectedEvent.startDateTime;
        _startDate = _date;
      } else {
        _date = _startDate;
      }
    } else if (type == "End Time") {
      if (selectedEvent != null && _endSet == false) {
        _date = selectedEvent.endDateTime;
        _endDate = _date;
      } else {
        _date = _endDate;
      }
    }

    _time = TimeOfDay(hour: _date.hour, minute: _date.minute);

    return Container(
      child: Row(children: [
        Text(
          type + ": ",
          style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
        ),
        Text(_date.hour.toString() + ":" + minuteToString(_date.minute)),
        FlatButton(
          child: Text("Select"),
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: _time,
            ).then((value) {
              setState(() {
                _date = DateTime(
                  _date.year,
                  _date.month,
                  _date.day,
                  value != null ? value.hour : _date.hour,
                  value != null ? value.minute : _date.minute,
                  0,
                );

                if (type == "Start Time") {
                  _startDate = _date;
                  _startSet = true;
                } else if (type == "End Time") {
                  _endDate = _date;
                  _endSet = true;
                }
                print(type + ": " + _date.toString());
              });
            });
          },
        ),
      ]),
    );
  }

  Widget _buildLocationFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Location',
      ),
      autovalidateMode: AutovalidateMode.always,
      // initialValue: selectedEvent != null ? selectedEvent.location : '',
      // Validation to check if empty or not 9 numbers
      validator: (String value) {
        if (value.isEmpty) {
          return 'Error: Please enter the event location!';
        } else if (locationException == true) {
          return 'Error: Please click \"Check location\" to check validity!';
        }
        return null;
      },
      onChanged: (String newValue) {
        _location = newValue;
      },
      controller: _locationController,
      /*onTap: () async {
        // then get the Prediction selected
        const kGoogleApiKey = "API_KEY";
        maps.Prediction p = await places.PlacesAutocomplete.show(
          context: context, apiKey: kGoogleApiKey,
        );
        displayPrediction(p);
      },*/
    );
  }

  Widget _buildLocationFormButton() {
    return RaisedButton(
      child: Text("Check location"),
      onPressed: () {
        if (_location != '') {
          getPosition(false);
        }
      },
    );
  }

  Widget _buildLocation() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
          )
        ],
      ),
      width: 300.0,
      height: 200.0,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          minZoom: 5.0,
          zoom: _zoom,
          maxZoom: 20.0,
          //center: selectedEvent.location != null ? selectedEvent.location : _centre,
          center: _centre,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoibGVvbi1jaG93MSIsImEiOiJja2hyMGRteWcwNjh0MzBteXh1NXNibHY0In0.nFSqVO-aIMytp_hQWKmXXQ',
              'id': 'mapbox.mapbox-streets-v8'
            },
            subdomains: ['a', 'b', 'c'],
          ),
          new MarkerLayerOptions(
            markers: marker != null ? [marker] : [],
          ),
        ],
      ),
    );
  }

  Widget _buildMapButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(Icons.zoom_in),
          onPressed: () {
            if (_zoom < 20.0) {
              setState(() {
                _zoom += 1.0;
                mapController.move(_centre, _zoom);
              });
            }
          },
        ),
        IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: () {
              if (_zoom > 5.0) {
                setState(() {
                  _zoom -= 1.0;
                  mapController.move(_centre, _zoom);
                });
              }
            }),
        IconButton(
          icon: Icon(Icons.my_location),
          onPressed: () {
            getPosition(true);
          },
        ),
      ],
    );
  }

  // Function to convert minute to string format, will be moved to another file later
  String minuteToString(int minute) {
    if (minute < 10) {
      return "0" + minute.toString();
    } else {
      return minute.toString();
    }
  }

  // future function to get the current position from the location property of event and use it for locationFromAddress
  Future<void> getPosition(bool current) async {
    var location;
    List<Placemark> places;
    try {
      if (current == true) {
        location = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _centre = LatLng(location.latitude, location.longitude);

        places = await geocoder.placemarkFromCoordinates(
            location.latitude, location.longitude);

        _location = places[0].postalCode.toString();
        _geoPoint = GeoPoint(_centre.latitude, _centre.longitude);

        setState(() {
          updateMarker(location);
          mapController.move(_centre, _zoom);

          _locationController.value = TextEditingValue(
            text: _location,
            selection: TextSelection.fromPosition(
              TextPosition(offset: _location.length),
            ),
          );
        });
        locationException = false;
      } else if (_location != '') {
        List<Location> places = await geocoder.locationFromAddress(_location);
        location = places[0];
        _centre = LatLng(location.latitude, location.longitude);
        _geoPoint = GeoPoint(_centre.latitude, _centre.longitude);
        setState(() {
          updateMarker(location);
          mapController.move(_centre, _zoom);
        });
        locationException = false;
      } else if (selectedEvent != null && selectedEvent.location != null) {
        List<Location> places =
            await geocoder.locationFromAddress(selectedEvent.location);
        location = places[0];
        _location = selectedEvent.location;
        _centre = LatLng(location.latitude, location.longitude);
        _geoPoint = GeoPoint(_centre.latitude, _centre.longitude);
        setState(() {
          updateMarker(location);
          mapController.move(_centre, _zoom);
        });
        locationException = false;
      }
    } on Exception catch (exception) {
      locationException = true;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error!'),
            content: Text(exception.toString()),
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

  // function to add a marker on the map box
  void updateMarker(var position) {
    var newMarker = new Marker(
      width: 70.0,
      height: 70.0,
      point: new LatLng(position.latitude, position.longitude),
      builder: (context) => Container(
          child: IconButton(
        color: Colors.red,
        icon: Icon(Icons.location_on),
        onPressed: () {
          print('Clicked icon!');
        },
      )),
    );
    marker = newMarker;
  }
}
