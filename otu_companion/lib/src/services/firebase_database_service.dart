import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDatabaseService
{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<bool> createNewUserProfile
  ({
    String id,
    String imageURL,
    String name,
  }) async
  {
    try {
      await _db.collection('profiles').doc(id).set({
        "id": id,
        "imageURL": "",
        "name": name,
      });
    } on FirebaseException catch(e)
    {
      return false;
    }
    return true;
  }
}