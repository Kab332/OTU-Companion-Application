import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'guide.dart';

// Model that represents the CRUD functions, used lecture 07a_Cloud_Storage for assistance
class GuideModel {
  // Future function of that returns a QuerySnapshot to get all Guides from the database
  Future<QuerySnapshot> getAll() async {
    return await FirebaseFirestore.instance.collection('guides').get();
  }

  // Future function to insert an Guide to the database
  Future<void> insert(Guide guide) async {
    CollectionReference guides =
        FirebaseFirestore.instance.collection('guides');
    guides.add(guide.toMap());
  }

  // Future function to update an Guide to the database
  Future<void> update(Guide guide) async {
    guide.reference.update({
      'name': guide.name,
      'description': guide.description,
    });
  }

  // Future function to delete an Guide from the database
  Future<void> delete(Guide guide) async {
    print('deleting guide $guide...');
    guide.reference.delete();
  }
}
