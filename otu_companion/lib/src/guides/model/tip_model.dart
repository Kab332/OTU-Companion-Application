import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'tip.dart';

// Model that represents the CRUD functions, used lecture 07a_Cloud_Storage for assistance
class TipModel {
  // Future function of that returns a QuerySnapshot to get all tips from the database
  Future<QuerySnapshot> getAll() async {
    return await FirebaseFirestore.instance.collection('tips').get();
  }

  // Future function to insert an tip to the database
  Future<void> insert(Tip tip) async {
    CollectionReference tips = FirebaseFirestore.instance.collection('tips');
    tips.add(tip.toMap());
  }

  // Future function to update an tip to the database
  Future<void> update(Tip tip) async {
    tip.reference.update({
      'name': tip.name,
      'description': tip.description,
    });
  }

  // Future function to delete an tip from the database
  Future<void> delete(Tip tip) async {
    print('deleting tip $tip...');
    tip.reference.delete();
  }
}
