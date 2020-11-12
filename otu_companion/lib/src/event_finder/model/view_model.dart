import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'database_utilities.dart';
import 'view.dart';

// local storage for view model, to allow the user to change views in their event list
class ViewModel {
    // future function to get the views and returns it to the main event finder view
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

  // future function to delete a view, takes a View as a parameter
  Future<void> deleteView(View view) async {
    print('updating ${view.id}');
    final db = await DatabaseUtilities.init();
    return db.delete(
      'event_views',
      where: 'id = ?',
      whereArgs: [view.id],
    );
  }

  // future function to insert a view, takes a View as a parameter
  Future<void> insertView(View view) async {
    final db = await DatabaseUtilities.init();
    return db.insert(
      'event_views',
      view.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}