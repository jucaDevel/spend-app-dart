import 'dart:ffi';

import 'package:cost_tracker_app/src/models/transaction.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/transaction_provider.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController{
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  late User user;
  SharedPref _sharedPref = new SharedPref();
  int totalRevenues = 0;
  int totalExpenses = 0;
  int totalSavings = 0;
  int totalAvailable = 0;
  int isLoaded = 0;
  List<Transaction> transactions = [];
  TransactionProvider _transactionProvider = new TransactionProvider();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _transactionProvider.init(context, user!);
    getValuesTransactions();
    refresh();
  }

  void openDrawer(){
    key.currentState?.openDrawer();
  }

  void logout(){
    _sharedPref.logout(context, user?.id ?? '');
  }
  
  void goToCategory(){
    Navigator.pushNamed(context, 'list/categories');
  }

  void goToCreateCategory(){
    Navigator.pushNamed(context, 'create/categories');
  }

  void goToTransactions(){
    Navigator.pushNamed(context, 'transactions');
  }

  void goToBalance(){
    Navigator.pushNamed(context, 'home');
  }

  void getValuesTransactions() async{
    int idUser = int.parse(user.id!);
    transactions = await _transactionProvider.getSumTransactions(idUser);
    if(transactions!=null){
      isLoaded = 1;
      transactions.forEach((transaction) {
        if(transaction.idType == 1){
          totalRevenues = totalRevenues + transaction.price!.toInt();
        }
        if(transaction.idType ==2){
          totalExpenses = totalExpenses + transaction.price!.toInt();
        }
        if(transaction.idType ==3){
          totalSavings = totalSavings + transaction.price!.toInt();
        }
      });
      totalAvailable = totalRevenues - totalExpenses - totalSavings;
      print("Ingresos: $totalRevenues, gastos: $totalExpenses, ahorros:$totalSavings");
    }
    refresh();
  }

  void goToTransactionPage(String typeId, String name){
    Navigator.pushNamed(context, 'transactions/list',arguments: {'typeId': typeId, 'nameType': name});
  }

  void goToEditTransactionPage(String transId,int typeId,String name){
    Navigator.pushNamed(context, 'transactions/edit',arguments: {'transId': transId,'typeId':typeId,'nameType': name});
  }

}