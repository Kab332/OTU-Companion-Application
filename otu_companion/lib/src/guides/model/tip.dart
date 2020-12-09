import 'package:cloud_firestore/cloud_firestore.dart';

// Entity class Tip
class Tip {
  String name;
  String description;
  String createdBy;
  String username;
  DocumentReference reference;

  Tip({
    this.name,
    this.description,
    this.createdBy,
    this.username,
  });

  String toString() {
    return 'Tip: $name, $description, $createdBy, $username';
  }

  Tip.fromMap(Map<String, dynamic> maps, {this.reference}) {
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
