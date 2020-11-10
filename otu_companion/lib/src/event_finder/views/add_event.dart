import 'package:flutter/material.dart';

import '../model/event.dart';

class AddEventPage extends StatefulWidget {
  AddEventPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _description = '';
  DateTime _eventDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime _currentDate = DateTime.now();
    TimeOfDay _currentTime = TimeOfDay.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Event Name Input
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Name',
              ),
              autovalidateMode: AutovalidateMode.always,
              // set initial value, i noticed that the initial value is not actually the form value until it is edited,
              // validation to check if empty or not 9 numbers
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Error: Please enter an event!';
                }
                return null;
              },
              onChanged: (String newValue) {
                _name = newValue;
              },
            ),
            // Decription Input
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              autovalidateMode: AutovalidateMode.always,
              // validation to check if there is no grade, or if the grade is more than 3 characters
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Error: Please enter a description!';
                }
                return null;
              },
              onChanged: (String newValue) {
                _description = newValue;
              },
            ),
            // Event Date input
            Container(
              child: Row(
                children: [
                  Text(
                    "Event Date: ",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                  Text(_eventDate.day.toString() +
                      "/" +
                      _eventDate.month.toString() +
                      "/" +
                      _eventDate.year.toString()),
                  FlatButton(
                    child: Text("Select Date"),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: _eventDate,
                              firstDate: _currentDate,
                              lastDate: DateTime(2150))
                          .then((value) {
                        setState(() {
                          _eventDate = DateTime(
                            value != null ? value.year : _eventDate.year,
                            value != null ? value.month : _eventDate.month,
                            value != null ? value.day : _eventDate.day,
                            _eventDate.hour,
                            _eventDate.minute,
                            _eventDate.second,
                          );
                          print("_eventDate: " + _eventDate.toString());
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            // Event time input
            Container(
              child: Row(children: [
                Text(
                  "Select time: ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                ),
                Text(_eventDate.hour.toString() +
                    ":" +
                    _eventDate.minute.toString()),
                FlatButton(
                  child: Text("Select Time"),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: _currentTime,
                    ).then((value) {
                      setState(() {
                        _eventDate = DateTime(
                          _eventDate.year,
                          _eventDate.month,
                          _eventDate.day,
                          value != null ? value.hour : _eventDate.hour,
                          value != null ? value.minute : _eventDate.minute,
                          _eventDate.second,
                        );
                        print("_eventDate: " + _eventDate.toString());
                      });
                    });
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // handling validation here, also sending the grade back to the function that invoked this
          if (_formKey.currentState.validate()) {
            Event event = Event(
              name: _name,
              description: _description,
            );
            Navigator.pop(context, event);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
}
