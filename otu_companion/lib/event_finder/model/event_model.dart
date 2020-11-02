import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'database_utilities.dart';
import 'event.dart';

class EventModel {
  Future<List<Event>> getAll() async {
    final db = await DatabaseUtilities.init();
    final List<Map<String, dynamic>> data = await db.query('events');
    List<Event> events = [];
    if (data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        events.add(Event.fromMap(data[i]));
      }
    }
    return events;
  }

  Future<void> insert(Event event) async {
    final db = await DatabaseUtilities.init();
    db.insert(
      'events', 
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}