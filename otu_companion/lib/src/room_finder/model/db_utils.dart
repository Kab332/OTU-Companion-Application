import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'room.dart';

class DBUtils {
  static Future<Database> init() async {
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'room_manager.db'),
      onCreate: (db, version) async {
        // Create table
        db.execute(
            'CREATE TABLE room_items(id INTEGER PRIMARY KEY AUTOINCREMENT, building TEXT, day TEXT, room TEXT, time TEXT)');

        // Read from firestore collection
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection("rooms").get();
        print(querySnapshot.size);

        // Iterate through each document, map, and insert to sqflite db
        querySnapshot.docs.forEach((document) {
          final room =
              Room.fromMap(document.data(), reference: document.reference);
          db.insert(
            'room_items',
            room.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        });
      },
      version: 1,
    );
    return database;
  }
}

