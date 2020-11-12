import 'package:cloud_firestore/cloud_firestore.dart';

// entity class Event
class Event {
  String id;
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
    this.id = reference.id;
    this.name = maps['name'];
    this.description = maps['description'];
    this.startDateTime = maps['startDateTime'] != null
        ? DateTime.parse(maps['startDateTime'].toDate().toString())
        : null;
    this.endDateTime = maps['endDateTime'] != null
        ? DateTime.parse(maps['endDateTime'].toDate().toString())
        : null;
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
