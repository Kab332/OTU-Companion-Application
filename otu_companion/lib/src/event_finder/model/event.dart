import 'package:cloud_firestore/cloud_firestore.dart';

// Entity class Event
class Event {
  String id;
  String name;
  String description;
  String createdBy;
  DateTime startDateTime;
  DateTime endDateTime;
  DocumentReference reference;
  String location;
  List<String> participants;

  Event(
      {this.name,
      this.description,
      this.createdBy,
      this.startDateTime,
      this.endDateTime,
      this.location,
      this.participants});

  String toString() {
    return 'event: $id, $name, $description, $createdBy, ($startDateTime) ($endDateTime), $location, $participants';
  }

  Event.fromMap(Map<String, dynamic> maps, {this.reference}) {
    this.id = reference.id;
    this.name = maps['name'];
    this.description = maps['description'];
    this.createdBy = maps['createdBy'];
    this.startDateTime = maps['startDateTime'] != null
        ? DateTime.parse(maps['startDateTime'].toDate().toString())
        : null;
    this.endDateTime = maps['endDateTime'] != null
        ? DateTime.parse(maps['endDateTime'].toDate().toString())
        : null;
    this.location = maps['location'];

    if (maps['participants'] != null) {
      this.participants = maps['participants'].cast<String>();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'createdBy': this.createdBy,
      'startDateTime': this.startDateTime,
      'endDateTime': this.endDateTime,
      'location': this.location,
      'participants': this.participants
    };
  }
}
