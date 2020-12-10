import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key, this.title}) : super(key: key);

  final String title;

  _MessagePageState createState() => _MessagePageState();
}
class _MessagePageState extends State<MessagePage>
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