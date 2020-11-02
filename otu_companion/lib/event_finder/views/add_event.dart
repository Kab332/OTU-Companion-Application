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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Name',
              ),
              autovalidate: true,
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              autovalidate: true,
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