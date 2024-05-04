// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:cost_tracker_app/src/models/rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String name;
  String lastname;
  String email;
  String password;
  String? image;
  String? sessionToken;
  List<Rol>? roles;

  User({
    this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    this.image,
    this.sessionToken,
    this.roles
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] is int ? json["id"].toString(): json["id"],
    name: json["name"],
    lastname: json["lastname"],
    email: json["email"],
    password: json["password"],
    image: json["image"],
    sessionToken: json["session_token"],
    roles:json["roles"] == null ? [] : List<Rol>.from(json['roles'].map((model) => Rol.fromJson(model))) ?? [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastname": lastname,
    "email": email,
    "password": password,
    "image": image,
    "session_token": sessionToken,
    "roles":roles
  };
}
