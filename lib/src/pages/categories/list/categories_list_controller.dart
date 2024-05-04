import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/response_api.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/categories_provider.dart';
import 'package:cost_tracker_app/src/provider/type_provider.dart';
import 'package:cost_tracker_app/src/utils/my_snackbar.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CategoriesListController{
  late BuildContext context;
  late Function refresh;
  List<TypeTransaction> types = [];
  List<Category> dataCategories = [];
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  TypeProvider _typeProvider = new TypeProvider();
  late User user;
  SharedPref sharedPref = new SharedPref();
  late ProgressDialog progressDialog;
  Future<void> init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _typeProvider.init(context, user);
    progressDialog = ProgressDialog(context: context); //Inicializo el progressDialog
    getTypes();
  }

  Future<List<Category>> getCategoriesByType(String idCategory) async{
    int idUser = int.parse(user.id!);
    dataCategories = await _categoriesProvider.getCategoriesByType(idCategory,idUser);
    return dataCategories;
  }

  void getTypes() async {
    types = await _typeProvider.getTypes();
    refresh();
    print("Tipos : $types");
  }

  void delete(String idCategory) async{
    print("category $idCategory");
    ResponseApi? responseApi = await _categoriesProvider.delete(idCategory);
    MySnackbar.show(context, responseApi!.message!);
  }
}