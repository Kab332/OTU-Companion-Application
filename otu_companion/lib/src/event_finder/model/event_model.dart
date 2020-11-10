import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import 'database_utilities.dart';
import 'event.dart';

class EventModel {
  Future<QuerySnapshot> getAll() async {
    return FirebaseFirestore.instance.collection('events').get();
  }

  Future<void> insert(Event event) async {
    CollectionReference events = FirebaseFirestore.instance.collection('events');
    events.add(event.toMap());
  }

  Future<void> update(Event event) async {
    event.reference.update({'name': event.name, 'description': event.description, 'startDateTime': event.startDateTime, 'endDateTime': event.endDateTime});
  }

  Future<void> delete(Event event) async {
    event.reference.delete();
  }
  
  /*

  Functions to be used for local settings instead 

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

  Future<void> deleteEventById(int id) async {
    final db = await DatabaseUtilities.init();
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await DatabaseUtilities.init();
    db.execute("DELETE FROM events");
  }*/
}
