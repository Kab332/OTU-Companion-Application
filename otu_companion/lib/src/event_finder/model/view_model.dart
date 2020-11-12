import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'database_utilities.dart';
import 'view.dart';

// local storage for view model, to allow the user to change views in their event list
class ViewModel {
    // future function to get the views and returns it
  Future<List<View>> getViews() async {
    final db = await DatabaseUtilities.init();
    final List<Map<String, dynamic>> data = await db.query('event_views');
    List<View> views = [];  
    if (data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        views.add(View.fromMap(data[i]));
      }
    }
  return views;
  }

  // future function to update, takes a View as a parameter
  Future<void> updateView(View view) async {
    print('updating ${view.id}');
    final db = await DatabaseUtilities.init();
    return db.update(
      'event_views',
      view.toMap(),
      where: 'id = ?',
      whereArgs: [view.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}