import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  AddFriendPage({Key key, this.title}) : super(key: key);

  final String title;

  _AddFriendPageState createState() => _AddFriendPageState();
}
class _AddFriendPageState extends State<AddFriendPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(

        ),
      ),
    );
  }
}