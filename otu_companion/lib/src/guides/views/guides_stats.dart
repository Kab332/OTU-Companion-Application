import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../model/guide_model.dart';
import '../model/guide.dart';

class GuideStats extends StatefulWidget {
  final String title;
  final String userID;

  GuideStats({Key key, this.title, this.userID}) : super(key: key);

  @override
  _GuideStatsState createState() => _GuideStatsState();
}

class _GuideStatsState extends State<GuideStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildGuideStats(),
    );
  }

  Widget _buildGuideStats() {
    GuideModel _guideModel = GuideModel();
    return FutureBuilder<QuerySnapshot>(
        future: _guideModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: charts.BarChart(
                convertData(
                  snapshot.data.docs
                      .map((document) => Guide.fromMap(document.data(),
                          reference: document.reference))
                      .toList()
                      .cast<Guide>(),
                ),
                barGroupingType: charts.BarGroupingType.grouped,
                vertical: false,
                behaviors: [
                  new charts.ChartTitle("Guide Names",
                      behaviorPosition: charts.BehaviorPosition.start),
                  new charts.ChartTitle("Number of Votes",
                      behaviorPosition: charts.BehaviorPosition.bottom),
                  new charts.SeriesLegend(),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  static List<charts.Series<Guide, String>> convertData(List<Guide> guides) {
    if (guides != null) {
      return [
        new charts.Series<Guide, String>(
          id: "Up votes",
          domainFn: (Guide guide, _) => guide.name,
          measureFn: (Guide guide, _) => guide.upVoters.length,
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
          data: guides,
        ),
        new charts.Series<Guide, String>(
          id: "Down votes",
          domainFn: (Guide guide, _) => guide.name,
          measureFn: (Guide guide, _) => guide.downVoters.length,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          data: guides,
        )
      ];
    } else {
      return [];
    }
  }
}
