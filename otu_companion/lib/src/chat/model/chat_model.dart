import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatModel
{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<ChatRooms>> getAllRooms() async {
    var doc = await _db.collection('userChatRooms').doc(_firebaseAuth.currentUser.uid).get().then(
      (DocumentSnapshot document) async{
        List<Map<String, DocumentReference>> maps = document["people"];

        maps.forEach((element) async{
          DocumentSnapshot document = await _db.collection(element["otherUserID"].collection()).doc(element["otherUserID"].id).get();
        });
      }
    );

    doc.then((value){

    })
  }
  List<AccountInfo> _
}