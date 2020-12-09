import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'package:otu_companion/src/services/firebase_database_service.dart';
import 'package:otu_companion/res/routes/routes.dart';

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
        child: Column(
          children: <Widget>[
            _buildGlobalChatRoom(context),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, Routes.chatAddFriend).whenComplete((){
            setState(() {

            });
          });
        },
      ),
    );
  }

  Widget _buildGlobalChatRoom(BuildContext context)
  {
    return ListTile(
      title: Text('Global Chat'),
      leading: CircleAvatar(
        child: Text("G"),
      ),
      onTap: ()
      {

      },
    );
  }
}