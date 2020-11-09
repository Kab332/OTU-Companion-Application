import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUtilities {
  static Future<Database> init() async {
    var database = openDatabase(
      join(await getDatabasesPath(), 'event_data.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE events(id INTEGER PRIMARY KEY, name TEXT, description TEXT, startDateTime TEXT, endDateTime TEXT)");
      },
      version: 1,
    );
    return database;
  }
}