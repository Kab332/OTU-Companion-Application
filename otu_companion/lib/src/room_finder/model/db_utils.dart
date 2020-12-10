import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBUtils {
  static Future init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "room_manager.db");

    final exist = await databaseExists(path);

    if(exist){
      print("Database already exists.");
    }
    else { // Copies pre-made db to phone
      print("Creating copy...");
      try {
        await Directory(dirname(path)).create(recursive:true);
      } catch(_){}

      ByteData data = await rootBundle.load(join("lib/res/database","room_manager.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush:true);

      print("DB copied.");
    }

    return await openDatabase(path);
  }
}
