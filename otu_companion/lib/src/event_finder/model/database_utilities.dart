import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUtilities {
  static Future<Database> init() async {
    var database = openDatabase(
      join(await getDatabasesPath(), 'event_views_data.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE event_views(id INTEGER PRIMARY KEY, viewType TEXT)");
        return db.insert(
          'event_views', // table name
          {'id': 1, 'viewType': "list"}, // Map values
          conflictAlgorithm: ConflictAlgorithm.replace // conflict algorithm if ID already exists in table
        );
      },
      version: 1,
    );
    return database;
  }
}
