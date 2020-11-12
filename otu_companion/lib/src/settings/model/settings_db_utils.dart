import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Future<Database> init() async {
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'settings_manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE settings(id INTEGER PRIMARY KEY, '
                'materialColorIndex INTEGER DEFAULT 0, '
                'accentColorIndex INTEGER DEFAULT 0, '
                'themeModeIndex INTEGER DEFAULT 0)');

        db.execute('INSERT INTO settings(materialColorIndex, accentColorIndex, themeModeIndex) '
            'VALUES(0, 0, 0)');

      },

      version: 1,
    );
    return database;
  }
}