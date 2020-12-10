import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter_i18n/flutter_i18n.dart';

import '../model/event_model.dart';
import '../model/event.dart';

class EventStats extends StatefulWidget {
  final String title;
  final String userID;

  EventStats({Key key, this.title, this.userID}) : super(key: key);

  @override
  _EventStatsState createState() => _EventStatsState();
}

class _EventStatsState extends State<EventStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildEventStats(),
    );
  }

  /* This function gets the events from the cloud based on whether the user is 
     in joined events (gets userID) or in all events and builds a bar chart to
     show the # of participants in each event. */
  Widget _buildEventStats() {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: widget.userID != null
            ? _eventModel.getUserEvents(widget.userID)
            : _eventModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: charts.BarChart(
                convertData(
                  snapshot.data.docs
                      .map((document) => Event.fromMap(document.data(),
                          reference: document.reference))
                      .toList()
                      .cast<Event>(),
                ),
                barGroupingType: charts.BarGroupingType.grouped,
                vertical: false,
                // Creating the Axis titles
                behaviors: [
                  new charts.ChartTitle(
                      FlutterI18n.translate(
                          context, "eventStats.chartLabels.domainLabel"),
                      behaviorPosition: charts.BehaviorPosition.start),
                  new charts.ChartTitle(
                      FlutterI18n.translate(
                          context, "eventStats.chartLabels.measureLabel"),
                      behaviorPosition: charts.BehaviorPosition.bottom)
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  // Converts a list of events to data that can be used by a chart
  static List<charts.Series<Event, String>> convertData(List<Event> events) {
    if (events != null) {
      // Showing the # of participants for each event
      return [
        new charts.Series<Event, String>(
          id: "# of Participants",
          domainFn: (Event event, _) => event.name,
          measureFn: (Event event, _) => event.participants.length,
          data: events,
        )
      ];
    } else {
      return [];
    }
  }
}
