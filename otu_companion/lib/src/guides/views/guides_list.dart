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
                    : _editGuide,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _selectedGuide == null
                ? null
                : _selectedGuide.createdBy != user.uid
                    ? null
                    : _deleteGuide,
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
        Expanded(child: _buildGuideList()),
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
        onPressed: _addGuide,
      ),
    );
  }

  Widget _buildGuideList() {
    return FutureBuilder<QuerySnapshot>(
        future: _guideModel.getAll(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) =>
                      _buildGuide(context, document))
                  .toList(),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildGuide(BuildContext context, DocumentSnapshot guideData) {
    final guide =
        Guide.fromMap(guideData.data(), reference: guideData.reference);

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
                color: guide.upVoters.contains(user.uid)
                    ? Colors.orange
                    : Colors.grey,
                icon: Icon(Icons.arrow_upward),
                onPressed: () {
                  setState(() {
                    _updateVotes("upVote", guide);
                  });
                },
              ),
              Text(guide.upVoters.length.toString()),
              IconButton(
                iconSize: 15,
                color: guide.downVoters.contains(user.uid)
                    ? Colors.blue
                    : Colors.grey,
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  setState(() {
                    _updateVotes("downVote", guide);
                  });
                },
              ),
              Text(guide.downVoters.length.toString()),
            ])));
  }

  Future<void> _addGuide() async {
    var result =
        await Navigator.pushNamed(context, "/guidesForm", arguments: null);

    Guide guide = result;

    if (guide != null) {
      guide.createdBy = user.uid;
      guide.username = user.displayName;
      guide.upVoters = [];
      guide.downVoters = [];
      setState(() {
        _guideModel.insert(guide);
        _showCustomSnackBar("Guide has been added.");
      });
    }
    print("Adding guide $guide...");
  }

  Future<void> _deleteGuide() async {
    if (_selectedGuide != null) {
      setState(() {
        _guideModel.delete(_selectedGuide);
        _showCustomSnackBar("Guide has been deleted.");
      });
    }
  }

  Future<void> _editGuide() async {
    if (_selectedGuide != null) {
      var result = await Navigator.pushNamed(context, "/guidesForm",
          arguments: _selectedGuide);

      Guide newGuide = result;

      if (result != null) {
        newGuide.createdBy = _selectedGuide.createdBy;
        newGuide.username = _selectedGuide.username;
        newGuide.upVoters = _selectedGuide.upVoters;
        newGuide.downVoters = _selectedGuide.downVoters;
        newGuide.reference = _selectedGuide.reference;
        setState(() {
          _guideModel.update(newGuide);
          _selectedGuide = null;
        });
        _showCustomSnackBar("Guide has been edited.");
      }
    }
  }

  /* Updates the passed guide's upVoters and downVoters based on the voteType
     argument and specific conditions  */
  Future<void> _updateVotes(String voteType, Guide guide) async {
    // For upvotes
    if (voteType == "upVote") {
      // If the user has already downvoted then we switch that to an upvote
      if (guide.downVoters.contains(user.uid)) {
        guide.downVoters.remove(user.uid);
        guide.upVoters.add(user.uid);
      }
      // If the user has already upvoted then we remove the upvote
      else if (guide.upVoters.contains(user.uid)) {
        guide.upVoters.remove(user.uid);
      }
      // If the user has not voted yet then we add an upvote
      else {
        guide.upVoters.add(user.uid);
      }
    }
    // For downvotes, same format as above but upvotes and downvotes have swapped
    else {
      if (guide.upVoters.contains(user.uid)) {
        guide.upVoters.remove(user.uid);
        guide.downVoters.add(user.uid);
      } else if (guide.downVoters.contains(user.uid)) {
        guide.downVoters.remove(user.uid);
      } else {
        guide.downVoters.add(user.uid);
      }
    }

    setState(() {
      _guideModel.update(guide);
    });
  }

  // Function that shows a dialog that shows quick details about the guide selected, pressing dismiss or clicking away will make it disappear
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
                    labelText: 'Guide Description',
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

  void _showCustomSnackBar(String content) {
    var snackbar = SnackBar(
        content: Text(content),
        action: SnackBarAction(
            label: "Dismiss",
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            }));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
