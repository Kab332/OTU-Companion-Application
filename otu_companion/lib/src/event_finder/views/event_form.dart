import 'package:flutter/material.dart';

import '../model/event.dart';

class EventFormPage extends StatefulWidget {
  EventFormPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

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
            // Start Date input
            Container(
              child: Row(
                children: [
                  Text(
                    "Start Date: ",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                  Text(_startDate.day.toString() +
                      "/" +
                      _startDate.month.toString() +
                      "/" +
                      _startDate.year.toString()),
                  FlatButton(
                    child: Text("Select"),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: _currentDate,
                              lastDate: DateTime(2150))
                          .then((value) {
                        setState(() {
                          _startDate = DateTime(
                            value != null ? value.year : _startDate.year,
                            value != null ? value.month : _startDate.month,
                            value != null ? value.day : _startDate.day,
                            _startDate.hour,
                            _startDate.minute,
                            0,
                          );
                          print("_startDate: " + _startDate.toString());
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
                  "Start Time: ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                ),
                Text(_startDate.hour.toString() +
                    ":" +
                    _startDate.minute.toString()),
                FlatButton(
                  child: Text("Select"),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: _currentTime,
                    ).then((value) {
                      setState(() {
                        _startDate = DateTime(
                          _startDate.year,
                          _startDate.month,
                          _startDate.day,
                          value != null ? value.hour : _startDate.hour,
                          value != null ? value.minute : _startDate.minute,
                          0,
                        );
                        print("_startDate: " + _startDate.toString());
                      });
                    });
                  },
                ),
              ]),
            ),
            // Event Date input
            Container(
              child: Row(
                children: [
                  Text(
                    "End Date: ",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                  ),
                  Text(_endDate.day.toString() +
                      "/" +
                      _endDate.month.toString() +
                      "/" +
                      _endDate.year.toString()),
                  FlatButton(
                    child: Text("Select"),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: _currentDate,
                              lastDate: DateTime(2150))
                          .then((value) {
                        setState(() {
                          _endDate = DateTime(
                            value != null ? value.year : _endDate.year,
                            value != null ? value.month : _endDate.month,
                            value != null ? value.day : _endDate.day,
                            _endDate.hour,
                            _endDate.minute,
                          );
                          print("_endDate: " + _endDate.toString());
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
                  "End time: ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                ),
                Text(_endDate.hour.toString() +
                    ":" +
                    _endDate.minute.toString()),
                FlatButton(
                  child: Text("Select"),
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: _currentTime,
                    ).then((value) {
                      setState(() {
                        _endDate = DateTime(
                          _endDate.year,
                          _endDate.month,
                          _endDate.day,
                          value != null ? value.hour : _endDate.hour,
                          value != null ? value.minute : _endDate.minute,
                          0,
                        );
                        print("_endDate: " + _endDate.toString());
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
              startDateTime: _startDate,
              endDateTime: _endDate,
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
