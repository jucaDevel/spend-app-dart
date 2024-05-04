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

class CategoriesController{
  late BuildContext context;
  late Function refresh;

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  List<TypeTransaction> types = [];
  late String idType = '1';
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  TypeProvider _typeProvider = new TypeProvider();
  late User user;
  late ProgressDialog _progressDialog;
  SharedPref sharedPref = new SharedPref();
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context); //Inicializo el progressDialog
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _typeProvider.init(context, user);
    getTypes();
  }

  void createCategory() async{
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    String idUser = user.id!;
    if(name.isEmpty || description.isEmpty){
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }
    if(idType == null){
      MySnackbar.show(context, 'Debes seleccionar el tipo de categoria');
      return;
    }

    Category category = new Category(
      name:name,
      description: description,
      idType: int.parse(idType),
      idUser: int.parse(idUser),
    );
    print("category ${category.toJson()}");
    ResponseApi? responseApi = await _categoriesProvider.create(category);

    _progressDialog.show(max: 100, msg: 'Espera un momento');
    if(responseApi!=null){
      _progressDialog.close();
      MySnackbar.show(context, responseApi!.message!);
    }

    if(responseApi!.success!){
      nameController.text = '';
      descriptionController.text = '';
      idType = '1';
      refresh();
    }
  }

  void getTypes() async {
    types = await _typeProvider.getTypes();
    refresh();
    print("Tipos : $types");
  }
}