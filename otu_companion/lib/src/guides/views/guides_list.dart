import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/guide.dart';
import '../model/guide_model.dart';

import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

class GuidesListWidget extends StatefulWidget {
  GuidesListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  GuidesListWidgetState createState() => GuidesListWidgetState();
}

class GuidesListWidgetState extends State<GuidesListWidget> {
  AuthenticationService _authenticationService = AuthenticationService();
  GuideModel _guideModel = GuideModel();

  User user;

  Guide _selectedGuide;

  @override
  Widget build(BuildContext context) {
    user = _authenticationService.getCurrentUser();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: MainSideDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _selectedGuide == null
                ? null
                : _selectedGuide.createdBy != user.uid
                    ? null
                    : _editTip,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _selectedGuide == null
                ? null
                : _selectedGuide.createdBy != user.uid
                    ? null
                    : _deleteTip,
          )
        ],
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
        child: Text("Submit a Guide"),
        onPressed: _addTip,
      ),
    );
  }

  Widget _buildTipList() {
    return FutureBuilder<QuerySnapshot>(
        future: _guideModel.getAll(),
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
    final guide = Guide.fromMap(tipData.data(), reference: tipData.reference);

    return Container(
      decoration: BoxDecoration(
        border: _selectedGuide != null &&
                guide.reference.id == _selectedGuide.reference.id
            ? Border.all(width: 3.0, color: Colors.blueAccent)
            : null,
      ),
      child: GestureDetector(
          child: _buildTile(context, guide),
          onTap: () {
            setState(() {
              _selectedGuide = guide;
              print("Selected Guide: $_selectedGuide");
            });
          }),
    );
  }

  Widget _buildTile(BuildContext context, Guide guide) {
    return Card(
        child: ListTile(
            title: Text(guide.name),
            subtitle: Text("By: " + guide.username),
            leading: IconButton(
              icon: Icon(Icons.book, color: Colors.blue),
              onPressed: () {
                _showViewDialog(context, guide);
              },
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                iconSize: 15,
                icon: Icon(Icons.arrow_upward),
                onPressed: () {},
              ),
              Text("10"),
              IconButton(
                iconSize: 15,
                icon: Icon(Icons.arrow_downward),
                onPressed: () {},
              ),
              Text("5"),
            ])));
  }

  Future<void> _addTip() async {
    var result =
        await Navigator.pushNamed(context, "/guidesForm", arguments: null);

    Guide guide = result;

    if (guide != null) {
      guide.createdBy = user.uid;
      guide.username = user.displayName;
      setState(() {
        _guideModel.insert(guide);
      });
    }
    print("Adding guide $guide...");
  }

  Future<void> _deleteTip() async {
    if (_selectedGuide != null) {
      setState(() {
        _guideModel.delete(_selectedGuide);
      });
    }
  }

  Future<void> _editTip() async {
    if (_selectedGuide != null) {
      var result = await Navigator.pushNamed(context, "/guidesForm",
          arguments: _selectedGuide);

      Guide newGuide = result;

      if (result != null) {
        newGuide.createdBy = _selectedGuide.createdBy;
        newGuide.username = _selectedGuide.username;
        newGuide.reference = _selectedGuide.reference;
        setState(() {
          _guideModel.update(newGuide);
          _selectedGuide = null;
        });
      }
    }
  }

  // Function that shows a dialog that shows quick details about the event selected, pressing dismiss or clicking away will make it disappear
  void _showViewDialog(BuildContext context, Guide guide) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                // Guide name form field
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Guide Name',
                  ),
                  initialValue: guide.name,
                ),
                // Guide description form field
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'By',
                  ),
                  initialValue: guide.username,
                ),
                // Guide description form field
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: 'Event Description',
                  ),
                  initialValue: guide.description,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text('Dismiss'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
