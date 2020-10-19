class Event {
  String name;
  String description;
  DateTime startDateTime;
  DateTime endDateTime; 

  Event({this.name, this.description, this.startDateTime, this.endDateTime});

  String toString() {
    return '$name: ($startDateTime) ($endDateTime)';
  }
}