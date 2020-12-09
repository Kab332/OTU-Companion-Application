import 'package:cloud_firestore/cloud_firestore.dart';

// Entity class Guide
class Guide {
  String name;
  String description;
  String createdBy;
  String username;

  DocumentReference reference;

  Guide({
    this.name,
    this.description,
    this.createdBy,
    this.username,
  });

  String toString() {
    return 'Guide: $name, $description, $createdBy, $username';
  }

  Guide.fromMap(Map<String, dynamic> maps, {this.reference}) {
    this.name = maps['name'];
    this.description = maps['description'];
    this.createdBy = maps['createdBy'];
    this.username = maps['username'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'description': this.description,
      'createdBy': this.createdBy,
      'username': this.username,
    };
  }
}
