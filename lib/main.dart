import 'package:cost_tracker_app/src/pages/categories/create/categories_page.dart';
import 'package:cost_tracker_app/src/pages/categories/list/categories_list_page.dart';
import 'package:cost_tracker_app/src/pages/home/home_page.dart';
import 'package:cost_tracker_app/src/pages/login/login_page.dart';
import 'package:cost_tracker_app/src/pages/register/register_page.dart';
import 'package:cost_tracker_app/src/pages/roles/roles_page.dart';
import 'package:cost_tracker_app/src/pages/transaction/create/transaction_create_page.dart';
import 'package:cost_tracker_app/src/pages/transaction/edit/transaction_edit_page.dart';
import 'package:cost_tracker_app/src/pages/transaction/list/transaction_list_page.dart';
import 'package:cost_tracker_app/src/pages/transaction/type/transaction_type_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spend',
        initialRoute: 'login',
        routes: {
          'login':(BuildContext context)=> LoginPage(),
          'register':(BuildContext context)=> RegisterPage(),
          'roles':(BuildContext context)=> RolesPage(),
          'home':(BuildContext context)=> HomePage(),
          'create/categories':(BuildContext context)=> CategoriesPage(),
          'list/categories':(BuildContext context)=> CategoriesListPage(),
          'transactions':(BuildContext context)=> TransactionTypePage(),
          'transactions/create':(BuildContext context)=> TransactionCreatePage(),
          'transactions/edit':(BuildContext context)=> TransactionEditPage(),
          'transactions/list':(BuildContext context)=> TransactionListPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        
    );
  }
}
