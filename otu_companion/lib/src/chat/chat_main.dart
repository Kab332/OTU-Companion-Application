import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);

  final String title;

  _ChatPageState createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainSideDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(

      ),
    );
  }
}