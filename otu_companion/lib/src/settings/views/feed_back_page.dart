import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/firebase_database_service.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FeedBackPage extends StatefulWidget
{
  FeedBackPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage>
{
  final _formKey = GlobalKey<FormState>();
  final _feedBack = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              controller: _feedBack,
              decoration: new InputDecoration(
                hintText: FlutterI18n.translate(
                  context, "feedbackPage.hintText"
                )
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return FlutterI18n.translate(
                    context, "feedbackPage.isEmptyText"
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            FirebaseDatabaseService.createFeedBack(
                message: _feedBack.text
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}