import 'dart:convert';
import 'package:cost_tracker_app/src/api/environment.dart';
import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/transaction.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;


class TransactionProvider{
  String _url = Environment.API_COST_TRACKER;
  String _api = '/api/transaction';
  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async{
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<ResponseApi?> create(Transaction transaction) async {
    try{
      Uri url = Uri.http(_url,'$_api/create');
      String bodyParams = json.encode(transaction);
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.post(url,headers:headers,body:bodyParams);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e){
      print('Error: $e');
      return null;
    }

  }

  Future<ResponseApi?> update(Transaction transaction) async {
    try{
      Uri url = Uri.http(_url,'$_api/update');
      String bodyParams = json.encode(transaction);
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.post(url,headers:headers,body:bodyParams);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e){
      print('Error: $e');
      return null;
    }

  }

  Future<List<Transaction>> getAllTransactions(int idUser) async{
    try{
      Uri url = Uri.http(_url,'$_api/getAllTransactions/$idUser');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.get(url,headers:headers);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      Transaction transaction = Transaction.fromJsonList(data);
      return transaction.toList;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }

  Future<List<Transaction>> getSumTransactions(int idUser) async{
    try{
      Uri url = Uri.http(_url,'$_api/getSumTransactions/$idUser');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.get(url,headers:headers);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      Transaction transaction = Transaction.fromJsonList(data);
      return transaction.toList;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }

  Future<List<Transaction>> getTransactionsByType(int idUser,String idType) async{
    try{
      Uri url = Uri.http(_url,'$_api/getTransactionsByType/$idUser/$idType');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.get(url,headers:headers);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      Transaction transaction = Transaction.fromJsonList(data);
      return transaction.toList;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }

  Future<List<Transaction>> getTransactionsById(int idUser,String idTrans) async{
    try{
      Uri url = Uri.http(_url,'$_api/getTransactionsById/$idUser/$idTrans');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.get(url,headers:headers);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      Transaction transaction = Transaction.fromJsonList(data);
      return transaction.toList;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }

  Future<List<Transaction>> getTransactionsByCategory(int idUser,String idType,String idCat) async{
    try{
      Uri url = Uri.http(_url,'$_api/getTransactionsByCategory/$idUser/$idType/$idCat');
      Map<String, String> headers = {
        'Content-type':'application/json',
        'Authorization':sessionUser.sessionToken!
      };

      final res = await http.get(url,headers:headers);

      if(res.statusCode==401){
        Fluttertoast.showToast(msg: 'Sesion expirada');
        new SharedPref().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      Transaction transaction = Transaction.fromJsonList(data);
      return transaction.toList;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }

}