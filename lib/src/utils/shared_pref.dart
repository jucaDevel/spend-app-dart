import 'dart:convert';

import 'package:cost_tracker_app/src/provider/users_provider.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  void save(String key, value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<dynamic> read(String? key) async{
    final prefs = await SharedPreferences.getInstance();
    
    if(prefs.getString(key!) == null) return null;

    String? value = prefs.getString(key);
    return json.decode(value ?? "");
  }

  Future<bool> contains(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  void logout(BuildContext context,String idUser) async{
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context);
    usersProvider.logout(idUser);
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}