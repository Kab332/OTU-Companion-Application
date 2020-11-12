import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUtilities {
  static Future<Database> init() async {
    var database = openDatabase(
      join(await getDatabasesPath(), 'event_views_data.db'),
      onCreate: (db, version) {
<<<<<<< HEAD
        db.execute("CREATE TABLE event_views(id INTEGER PRIMARY KEY, viewType TEXT)");
        return db.insert(
          'event_views', // table name
          {'id': 1, 'viewType': "list"}, // Map values
          conflictAlgorithm: ConflictAlgorithm.replace // conflict algorithm if ID already exists in table
        );
=======
        db.execute(
            "CREATE TABLE events(id INTEGER PRIMARY KEY, name TEXT, description TEXT, startDateTime TEXT, endDateTime TEXT)");
>>>>>>> fd10e51e84ff64e96dfe2974a3d4fe12b97b51c5
      },
      version: 1,
    );
    return database;
  }
}
