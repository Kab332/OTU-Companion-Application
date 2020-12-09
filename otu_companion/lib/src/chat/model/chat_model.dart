import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/chat/model/chat_rooms.dart';

class ChatModel
{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getUserAllRooms(){
    return _db.collection('userData').doc(_firebaseAuth.currentUser.uid).collection("joinedChatRooms").snapshots();
  }

  Stream<QuerySnapshot> getRoomMessages(String roomID)
  {
    return _db.collection("chatRooms").doc(roomID).collection("messages").limit(20).snapshots();
  }

  Stream<QuerySnapshot> getRoomMessagesByReference(String roomID)
  {
    return _db.collection("chatRooms").doc(roomID).collection("messages").limit(20).snapshots();
  }

  Future<void> createNewUserRoom(ChatRooms chatRooms) async
  {
    DocumentReference documentReference = await _db.collection('chatRooms').doc(_firebaseAuth.currentUser.uid).collection("joinedChatRooms").add(chatRooms.toMap()).then(
      (DocumentReference document) async{
        document.collection("users").doc(_firebaseAuth.currentUser.uid).set({"roles" : "Owner"});
        document.collection("messages").add({"message": "Hello!", "profileReference": _db.collection("profiles").doc(_firebaseAuth.currentUser.uid)});
        return document;
      });
    _db.collection('userData').doc(_firebaseAuth.currentUser.uid).collection("joinedChatRooms").add({"roomID" : documentReference});
  }

  Future<void> insertUserRooms(DocumentReference documentReference) async
  {
    await _db.collection('userData').doc(_firebaseAuth.currentUser.uid).collection("joinedChatRooms").add({"roomID" : documentReference});
    documentReference.collection("users").doc(_firebaseAuth.currentUser.uid).set({"roles" : "Member"});
  }

  Future<void> deleteRooms(DocumentReference documentReference) async
  {
    await documentReference.delete();
  }

  Future<void> updateChatRooms(DocumentReference documentReference, ChatRooms chatRooms) async
  {
    await documentReference.set(chatRooms.toMap());
  }
}