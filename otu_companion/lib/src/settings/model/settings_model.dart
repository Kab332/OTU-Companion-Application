import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'settings_db_utils.dart';
import 'settings.dart';

class SettingsModel {
  Future<List<Settings>> getAll() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> data = await db.query('settings');
    List<Settings> settings = [];
    if (data.length > 0) {
      for (var i = 0; i < data.length; i++) {
        settings.add(Settings.fromMap(data[i]));
      }
    }
    return settings;
  }

  Future<void> updateSettings(Settings settings) async {
    final db = await DBUtils.init();
    await db.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }
}