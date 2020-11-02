import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  AddEventPage({Key key, this.title}) : super(key: key);
  
  final String title;
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Text("Add Event Page"),
      ),
    );
  }
}