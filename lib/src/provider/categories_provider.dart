import 'dart:convert';
import 'package:cost_tracker_app/src/api/environment.dart';
import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;


class CategoriesProvider{
  String _url = Environment.API_COST_TRACKER;
  String _api = '/api/category';
  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async{
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<ResponseApi?> create(Category category) async {
    try{
      Uri url = Uri.http(_url,'$_api/create');
      String bodyParams = json.encode(category);
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

  Future<ResponseApi?> delete(String idCategory) async {
    try{
      Uri url = Uri.http(_url,'$_api/delete');
      String bodyParams = json.encode({"idCategory":idCategory});
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

  Future<List<Category>> getCategoriesByType(String idType, int idUser) async{
    try{
      Uri url = Uri.http(_url,'$_api/getCategoriesByType/$idType/$idUser');
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
      Category type = Category.fromJsonList(data);
      return type.toList;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }

}