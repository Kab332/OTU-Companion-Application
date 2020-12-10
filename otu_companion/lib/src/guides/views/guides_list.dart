import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import '../model/guide.dart';
import '../model/guide_model.dart';

/* We had this functionality in our original plan so we decided to include it
   even though it shares many similarities with event finder. */
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
          ),
          IconButton(
            icon: Icon(Icons.insert_chart, color: Colors.white),
            onPressed: _checkStats,
          ),
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

  // A button to add a new guide
  Widget _buildSubmit() {
    return Container(
      padding: EdgeInsets.all(5.0),
      height: 60,
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        child: Text(FlutterI18n.translate(
            context, "guidesList.buttonLabels.submitGuide")),
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

  // This function has votes functionality that is not in event finder
  Widget _buildTile(BuildContext context, Guide guide) {
    return Card(
        child: ListTile(
            title: Text(guide.name),
            subtitle: Text(
                FlutterI18n.translate(context, "guidesList.listLabels.by") +
                    guide.username),
            leading: IconButton(
              icon: Icon(Icons.book, color: Colors.blue),
              onPressed: () {
                _showViewDialog(context, guide);
              },
            ),
            // The trailing part of the tile holds the vote buttons and # of votes
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              // For up votes
              IconButton(
                iconSize: 15,
                // The icon has an orange colour if the user has up voted, otherwise it is grey
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
              // For down votes
              IconButton(
                iconSize: 15,
                // The icon has a blue colour if the user has down voted, otherwise it is grey
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

  // This function sends the user to a guide form to get user data then adds it to the guides collection
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
        _showCustomSnackBar(FlutterI18n.translate(
            context, "guidesList.snackBarLabels.guideAdded"));
      });
    }
    print("Adding guide $guide...");
  }

  // This funciton deletes the guide that is currently selected
  Future<void> _deleteGuide() async {
    if (_selectedGuide != null) {
      setState(() {
        _guideModel.delete(_selectedGuide);
        _showCustomSnackBar(FlutterI18n.translate(
            context, "guidesList.snackBarLabels.guideDeleted"));
      });
    }
  }

  /* This function sends the user to the guide form to edit the selected guide 
     and then updates it on the FireStore side */
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
        _showCustomSnackBar(FlutterI18n.translate(
            context, "guidesList.snackBarLabels.guideEdited"));
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Guide name form field
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(
                          context, "guidesList.formLabels.name"),
                    ),
                    initialValue: guide.name,
                  ),
                  // Guide description form field
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(
                          context, "guidesList.formLabels.by"),
                    ),
                    initialValue: guide.username,
                  ),
                  // Guide description form field
                  TextFormField(
                    enabled: false,
                    maxLines: 20,
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(
                          context, "guidesList.formLabels.description"),
                    ),
                    initialValue: guide.description,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  child: Text(FlutterI18n.translate(
                      context, "guidesList.formLabels.dismissButton")),
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

  // Function that sends the user to the stats page
  void _checkStats() {
    Navigator.pushNamed(context, "/guideStats", arguments: null);
  }

  // This creates a custom snackbar with its content based on the argument
  void _showCustomSnackBar(String content) {
    var snackbar = SnackBar(
        content: Text(content),
        action: SnackBarAction(
            label: FlutterI18n.translate(
                context, "guidesList.snackBarLabels.dismissButton"),
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            }));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
