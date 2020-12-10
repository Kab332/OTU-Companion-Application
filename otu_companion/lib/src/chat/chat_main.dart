import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'package:otu_companion/src/services/firebase_database_service.dart';
import 'package:otu_companion/res/routes/routes.dart';
import 'package:otu_companion/src/chat/model/chat_rooms.dart';
import 'package:otu_companion/src/chat/model/chat_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.title}) : super(key: key);

  final String title;

  _ChatPageState createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage>
{
  ChatModel _chatModel = ChatModel();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: MainSideDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: _chatModel.getUserAllRooms(),
              builder: (context, snapshot)
              {
                if (snapshot.data == null)
                {
                  return Container();
                }
                else
                {
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index)
                    {
                      DocumentReference documentReference = snapshot.data.documents[index];
                      String roomName = "";
                      String roomImageURL = "";

                      documentReference.get().then(
                      (value) => {
                        setState((){
                          roomName = value.data()["name"];
                          roomImageURL = value.data()["imageURL"];
                        })
                      });

                      return ListTile(
                        title: Text(roomName),
                        leading: CachedNetworkImage(
                          imageUrl: roomImageURL,
                          errorWidget: (context, url, error)
                          {
                            return CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 50,
                            );
                          },
                          progressIndicatorBuilder: (context, url, downloadProgress)
                          {
                            return CircularProgressIndicator(value: downloadProgress.progress);
                          },
                          imageBuilder: (context, imageProvider)
                          {
                            return CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 50,
                            );
                          },
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, Routes.messagePage);
                        },
                      );
                    }
                  );
                }
              }
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