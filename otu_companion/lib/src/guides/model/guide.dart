import 'package:cloud_firestore/cloud_firestore.dart';

// Entity class Guide
class Guide {
  String name;
  String description;
  String createdBy;
  String username;
  List<String> upVoters;
  List<String> downVoters;
  DocumentReference reference;

  Guide(
      {this.name,
      this.description,
      this.createdBy,
      this.username,
      this.upVoters,
      this.downVoters});

  String toString() {
    return 'Guide: $name, $description, $createdBy, $username, $upVoters, $downVoters';
  }

  // Entity from map function
  Guide.fromMap(Map<String, dynamic> maps, {this.reference}) {
    this.name = maps['name'];
    this.description = maps['description'];
    this.createdBy = maps['createdBy'];
    this.username = maps['username'];

    if (maps['upVoters'] != null) {
      this.upVoters = maps['upVoters'].cast<String>();
    }

    if (maps['downVoters'] != null) {
      this.downVoters = maps['downVoters'].cast<String>();
    }
  }

  // Entity to map function
  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'description': this.description,
      'createdBy': this.createdBy,
      'username': this.username,
      'upVoters': this.upVoters,
      'downVoters': this.downVoters,
    };
  }
}
