import 'dart:convert';

import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/transaction.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/categories_provider.dart';
import 'package:cost_tracker_app/src/provider/transaction_provider.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class TransactionListController{
  late BuildContext context;
  late Function refresh;
  TransactionProvider _transactionProvider = new TransactionProvider();
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  late User user;
  String? idCategory;
  String? idType;
  bool isInitialize = false;
  bool isTransactionsLoaded = false;
  bool isCategoriesLoaded = false;
  int totalMoney = 0;
  int count = 0;
  List<Category> categories = [];
  List<Transaction> transactions = [];
  SharedPref sharedPref = new SharedPref();
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _transactionProvider.init(context, user);
    _categoriesProvider.init(context, user);
    isInitialize = true;
  }

  Future<void> _getTransactionsByTypeAndCat(String idType, String? idCat) async{
    int idUser = int.parse(user.id!);
    count = count + 1 ;
    if(count > 0 && count < 2){
      if(idCat == null || idCat == '0'){
        transactions =await _transactionProvider.getTransactionsByType(idUser,idType);
      }else{
        transactions =await _transactionProvider.getTransactionsByCategory(idUser,idType,idCat!);
      }
      print("Transactions: ${jsonEncode(transactions)}");
      transactions.forEach((transaction) {
        totalMoney = totalMoney + transaction.price!.toInt();
      });
      print('Total Money: $totalMoney');
    }
    print('Total Ejecuciones: $count');
  }

  Future<void>_loadCategories(String typeId, int idUser) async {
    try{
      categories = await _categoriesProvider.getCategoriesByType(typeId, idUser);
      print("Categories: ${jsonEncode(categories)}");
      refresh!();
      //isInitialize = false;
    }catch(e){
      // Maneja cualquier error que pueda ocurrir durante la carga de categorías
      print('Error al cargar categorías: $e');
      categories = [];
    }
  }

  void initializeCategories({String? typeId, String? nameType}){
    int idUser = int.parse(user.id!);
    if (typeId != null && isCategoriesLoaded == false) {
      _loadCategories(typeId,idUser);
      isCategoriesLoaded = true;
    }
  }

  Future<void> initTransactionsByChangeCat(String? idCat) async {
    print('Ejecutado');
    //isTransactionsLoaded = false;
    totalMoney = 0;
    count = 0;
    await _getTransactionsByTypeAndCat(idType!, idCat);
  }

  void initializeTransactions(String typeId, String? idCat) async{
    if (typeId != null && isTransactionsLoaded == false) {
      idType = typeId;
      await _getTransactionsByTypeAndCat(typeId,idCat);
      isTransactionsLoaded = true;
    }
  }
}