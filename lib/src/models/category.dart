// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  String? id;
  String? name;
  String? description;
  List<Category> toList = [];
  int? idType;
  int? idUser;

  Category({
    this.id,
    this.name,
    this.description,
    this.idType,
    this.idUser
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    idType: json['idType'],
    idUser: json['idUser'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "idType":idType,
    "idUser":idUser
  };

  Category.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    jsonList.forEach((item) {
      Category category = Category.fromJson(item);
      toList.add(category);
    });
  }
}
