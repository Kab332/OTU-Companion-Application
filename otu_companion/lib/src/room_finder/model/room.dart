import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  Room({this.start_time, this.end_time, this.day, this.building, this.room});

  String start_time;
  String end_time;
  String day;
  String building;
  String room;
  DocumentReference reference;

  Room.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.start_time = map['start time'];
    this.end_time = map['end time'];
    this.day = map['day'];
    this.building = map['building'];
    this.room = map['room'];
  }
}

