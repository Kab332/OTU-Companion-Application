import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/tip.dart';
import '../model/tip_model.dart';

import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class GuidesListWidget extends StatefulWidget {
  GuidesListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  GuidesListWidgetState createState() => GuidesListWidgetState();
}

class GuidesListWidgetState extends State<GuidesListWidget> {
  TipModel _tipModel = TipModel();

  Tip _selectedTip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: MainSideDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildGuides(),
    );
  }

  Widget _buildGuides() {
    return Container(
        child: Column(
      children: [
        Expanded(child: _buildTipList()),
        _buildSubmit(),
      ],
    ));
  }

  Widget _buildSubmit() {
    return Container(
      padding: EdgeInsets.all(5.0),
      height: 60,
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        child: Text("Submit a Tip"),
        onPressed: () {},
      ),
    );
  }

  Widget _buildTipList() {
    return FutureBuilder<QuerySnapshot>(
        future: _tipModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) =>
                      _buildTip(context, document))
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildTip(BuildContext context, DocumentSnapshot tipData) {
    final tip = Tip.fromMap(tipData.data(), reference: tipData.reference);

    return Container(
      decoration: BoxDecoration(
        border: _selectedTip != null &&
                tip.reference.id == _selectedTip.reference.id
            ? Border.all(width: 3.0, color: Colors.blueAccent)
            : null,
      ),
      child: GestureDetector(
          child: _buildTile(context, tip),
          onTap: () {
            setState(() {
              _selectedTip = tip;
              print("Selected Tip: $_selectedTip");
            });
          }),
    );
  }

  Widget _buildTile(BuildContext context, Tip tip) {
    return Card(
        child: ListTile(
      title: Text(tip.name),
      subtitle: Text("Created by: " + tip.username),
      trailing: Text(tip.description),
    ));
  }
}
