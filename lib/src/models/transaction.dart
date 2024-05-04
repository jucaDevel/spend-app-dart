// To parse this JSON data, do
//
//     final transaction = transactionFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

Transaction transactionFromJson(String str) => Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  String? id;
  String? name;
  double? price;
  int? idCategory;
  int? idType;
  int? idUser;
  String? createdAt;
  List<Transaction> toList = [];

  Transaction({
    this.id,
    this.name,
    this.price,
    this.idCategory,
    this.idType,
    this.idUser,
    this.createdAt
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    name: json["name"],
    price: json['price'] is String ? double.parse(json["price"]) : isInteger(json["price"]) ? json["price"].toDouble() : json['price'],
    idCategory: json["id_category"] is String ? int.parse(json["id_category"]):json["id_category"],
    idType: json["id_type"] is String ? int.parse(json["id_type"]):json["id_type"],
    idUser: json["id_user"] is String ? int.parse(json["id_user"]):json["id_user"],
    createdAt: json["created_at"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "id_category": idCategory,
    "id_type": idType,
    "id_user": idUser,
    "date":createdAt
  };

  Transaction.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;
    jsonList.forEach((item) {
      Transaction transaction = Transaction.fromJson(item);
      toList.add(transaction);
    });
  }

  static bool isInteger(num value) => value is int || value == value.roundToDouble();
}
