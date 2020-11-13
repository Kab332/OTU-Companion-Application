import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  Future<QuerySnapshot> getRooms() async {
    return await FirebaseFirestore.instance.collection('roomschedules').get();
  }
}

