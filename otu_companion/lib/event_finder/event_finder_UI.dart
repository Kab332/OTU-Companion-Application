import 'package:flutter/material.dart';

Widget buildEventFinder() {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: _buildListView(),
      ),
      Padding(
        padding: EdgeInsets.all(10.0),
        child: _buildAddButton(),
      )
    ],
  );
}

// TODO: create a builder here that builds a list of type Events to populate this scrollable box
Widget _buildListView() {
  return Container(
    padding: EdgeInsets.all(10.0),
    height: 550.0,
    width: 300.0,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
    ),
    child: Center(
      child: Text('ListView of Events here'),
    ),
  );
}

Widget _buildAddButton() {
  return Container(
    padding: EdgeInsets.all(10.0),
    alignment: Alignment.bottomCenter,
    child: RaisedButton(
      child: Text("Add Event"),
      onPressed: () {
        print("Add Event Page!");
      }
    )
  );
}