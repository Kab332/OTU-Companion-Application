import 'package:flutter/material.dart';

class RoomFinderMain extends StatefulWidget {
  RoomFinderMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoomFinderMainState createState() => _RoomFinderMainState();
}

class _RoomFinderMainState extends State<RoomFinderMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("Test"),
      )
    );
  }
}
