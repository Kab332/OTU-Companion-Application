class Room {
  Room({this.building, this.day, this.room, this.time});

  int id;
  String building;
  String day;
  String room;
  String time;

  Room.fromMap(Map<String, dynamic> map) {
    this.building = map['building'];
    this.day = map['day'];
    this.room = map['room'];
    this.time = map['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'building': this.building,
      'day': this.day,
      'room': this.room,
      'time': this.time,
    };
  }


  String toString() {
    return '\n\Room{id: $id, building: $building, day: $day, room: $room, time: $time}';
  }
}

