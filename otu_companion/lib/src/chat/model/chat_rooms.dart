import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRooms
{
  String roomID;
  String name;
  String imageURL;
  DocumentReference reference;

  ChatRooms({this.roomID, this.name, this.imageURL});

  ChatRooms.fromMap(Map<String, dynamic> maps, {this.reference}) {
    this.roomID = maps['roomID'];
    this.name = maps['name'];
    this.imageURL = maps['imageURL'];
  }

  Map<String, dynamic> toMap() {
    return {
      'roomID': this.roomID,
      'name' : this.name,
      'imageURL' : this.imageURL,
    };
  }
}