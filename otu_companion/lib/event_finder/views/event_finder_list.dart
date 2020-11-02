import 'package:flutter/material.dart';
import '../model/event_model.dart';

Widget buildEventFinder() {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            height: 550.0,
            width: 300.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: _buildListView(),
          ),
        ),
      ),
    ],
  );
}

// TODO: create a builder here that builds a list of type Events to populate this scrollable box
Widget _buildListView() {
  EventModel _eventModel = EventModel();
  return FutureBuilder(
    future: _eventModel.getAll(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
        return Container(
          child: Text("Empty!"),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.hasData ? snapshot.data.length : null,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              child: ListTile(
                title: Text(snapshot.data[i].name),
                subtitle: Text(snapshot.data[i].description),
              )
            );
          }
        );
      }
    } 
  );
}