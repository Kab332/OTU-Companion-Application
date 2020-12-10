import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDatabaseService
{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> createFeedBack({
    String message,
  }) async
  {
    try
    {
      await _db.collection('feedback').add({
        "message": message,
      });
    }
    on FirebaseException catch(e)
    {
      return e.message;
    }
  }

  static Future<bool> createNewUserProfile
  ({
    String id,
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

  static Future<bool> updateUserProfile
      ({
    String id,
    String imageURL = "",
    String name,
  }) async
  {
    try {
      await _db.collection('profiles').doc(id).set({
        "id": id,
        "imageURL": imageURL,
        "name": name,
      });
    } on FirebaseException catch(e)
    {
      return false;
    }
    return true;
  }
}