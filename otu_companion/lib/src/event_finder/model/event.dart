import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  int id;
  String name;
  String description;
  DateTime startDateTime;
  DateTime endDateTime; 
  DocumentReference reference;

  Event({this.name, this.description, this.startDateTime, this.endDateTime});

  String toString() {
    return 'event: $id, $name, $description, ($startDateTime) ($endDateTime)';
  }

  Event.fromMap(Map<String, dynamic> maps, {this.reference}) {
    this.id = maps['id'];
    this.name = maps['name'];
    this.description = maps['description'];
    this.startDateTime = maps['startDateTime'];
    this.endDateTime = maps['endDateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'startDateTime': this.startDateTime,
      'endDateTime': this.endDateTime,
    };
  }
}