import 'dart:convert';
import 'package:cost_tracker_app/src/api/environment.dart';
import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;


class TypeProvider{
  String _url = Environment.API_COST_TRACKER;
  String _api = '/api/type';
  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context, User sessionUser) async{
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<TypeTransaction>> getTypes() async{
    try{
      Uri url = Uri.http(_url,'$_api/getTypes');
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
      TypeTransaction type = TypeTransaction.fromJsonListType(data);
      return type.toListType;
    }
    catch(e){
      print(('Error: $e'));
      return [];
    }
  }
}