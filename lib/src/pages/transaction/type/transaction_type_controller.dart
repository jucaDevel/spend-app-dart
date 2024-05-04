import 'dart:convert';

import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/categories_provider.dart';
import 'package:cost_tracker_app/src/provider/type_provider.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class TransactionTypeController{
  late BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  late Function refresh;
  late User user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  TypeProvider _typeProvider = new TypeProvider();
  List<TypeTransaction> types = [];
  
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _typeProvider.init(context, user);
    getTypes();
  }

  void getTypes() async{
    types = await _typeProvider.getTypes();
    print("Types ${jsonEncode(types)}");
    refresh();
  }

  void goToInsertPage(String typeId, String name){
    Navigator.pushNamed(context, 'transactions/create',arguments: {'typeId': typeId, 'nameType': name});
  }
}