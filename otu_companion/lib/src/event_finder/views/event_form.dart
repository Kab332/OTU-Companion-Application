import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  String _imageURL = '';

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  bool _startSet = false;
  bool _endSet = false;

  Event selectedEvent;

  @override
  Widget build(BuildContext context) {
    selectedEvent = widget.event != null ? widget.event : null;
    tz.initializeTimeZones();
    _eventNotifications.init();

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
              ],
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
            );
            // Calculating the difference in milliseconds between the event start date and the time it is not
            var secondsDiff = (event.startDateTime.millisecondsSinceEpoch -
                    tz.TZDateTime.now(tz.local).millisecondsSinceEpoch) ~/
                1000;

            print('seconds: $secondsDiff');

            // If the start date is greater than one day, send a notification later,
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
    } else if (type == "Image URL" && selectedEvent != null) {
      typeVal = _imageURL;
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
        } else if (type == "Image URL") {
          _imageURL = newValue;
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
                      firstDate: DateTime.now(),
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

  // Function to convert minute to string format, will be moved to another file later
  String minuteToString(int minute) {
    if (minute < 10) {
      return "0" + minute.toString();
    } else {
      return minute.toString();
    }
  }
}
