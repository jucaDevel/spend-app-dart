// To parse this JSON data, do
//
//     final type = typeFromJson(jsonString);

import 'dart:convert';

TypeTransaction typeFromJson(String str) => TypeTransaction.fromJson(json.decode(str));

String typeToJson(TypeTransaction data) => json.encode(data.toJson());

class TypeTransaction {
  String? id;
  String? name;
  String? description;
  String? image;
  List<TypeTransaction> toListType = [];

  TypeTransaction({
    this.id,
    this.name,
    this.description,
    this.image,
  });

  factory TypeTransaction.fromJson(Map<String, dynamic> json) => TypeTransaction(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
  };

  TypeTransaction.fromJsonListType(List<dynamic> jsonList){
    if(jsonList == null) return;
    jsonList.forEach((item) {
      TypeTransaction type = TypeTransaction.fromJson(item);
      toListType.add(type);
    });
  }
}
