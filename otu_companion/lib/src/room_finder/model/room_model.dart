import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'db_utils.dart';
import 'room.dart';

class RoomModel {

  // Returns a list of each building for the Building dropdown menu
  Future<List<DropdownMenuItem>> getDropdownBuildings() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT building FROM room_items');

    List<Room> result = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(Room.fromMap(maps[i]));
      }
    }

    return result.map((room) => DropdownMenuItem(child: Text(room.building), value: room.building)).toList();
  }

  // Returns a list of each room for the Rooms dropdown menu
  Future<List<DropdownMenuItem>> getDropdownRooms() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT room FROM room_items ORDER BY room DESC');

    List<Room> result = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(Room.fromMap(maps[i]));
      }
    }

    return result.map((room) => DropdownMenuItem(child: Text(room.room), value: room.room)).toList();
  }

  // Returns a list of free rooms at specified query
  Future<List<Room>> getRoomsAtTime(String day, String startTime, String endTime, [String building]) async {
    final db = await DBUtils.init();
    if (building.isNotEmpty) {
      final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT DISTINCT room FROM room_items WHERE building LIKE '$building' AND day LIKE '$day' AND time BETWEEN '$startTime' AND '$endTime'");

      List<Room> result = [];

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          result.add(Room.fromMap(maps[i]));
        }
      }

      return result;
    }
    else {
      final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT DISTINCT room FROM room_items WHERE day LIKE '$day' AND time BETWEEN '$startTime' AND '$endTime'");

      List<Room> result = [];

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          result.add(Room.fromMap(maps[i]));
        }
      }

      return result;
    }
  }

  // Returns a list of free times at specified query
  Future<List<Room>> getTimesAtRoom(String room) async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT DISTINCT time, day FROM room_items WHERE room LIKE '$room' ORDER BY day ASC");

    List<Room> result = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(Room.fromMap(maps[i]));
      }
    }

    return result;
  }

}

