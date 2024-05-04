import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/response_api.dart';
import 'package:cost_tracker_app/src/models/transaction.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/categories_provider.dart';
import 'package:cost_tracker_app/src/provider/transaction_provider.dart';
import 'package:cost_tracker_app/src/provider/type_provider.dart';
import 'package:cost_tracker_app/src/utils/my_snackbar.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class TransactionCreateController{
  late BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  Function? refresh;
  late User user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  TransactionProvider _transactionProvider = new TransactionProvider();
  TypeProvider _typeProvider = new TypeProvider();
  List<Category> categories = [];
  String? idCategory;
  String? idType;
  String? typeId;
  String? nameType;
  bool isInitialize = false;
  late ProgressDialog _progressDialog;
  TextEditingController transactionController = new TextEditingController();
  TextEditingController valueController = new TextEditingController();

  TransactionCreateController({this.typeId, this.nameType}){
  }

// Se crea un constructor para poder pasar parametros desde el page

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    print("User: $user");
    _categoriesProvider.init(context, user);
    _typeProvider.init(context, user);
    _transactionProvider.init(context, user);
    _progressDialog = ProgressDialog(context: context); //Inicializo el progressDialog
    refresh();
    isInitialize = true;
  }

  void create() async{
    String transactionDescription = transactionController.text.trim();
    String value = valueController.text.trim();
    String idUser = user.id!;
    if(transactionDescription.isEmpty || value.isEmpty){
      MySnackbar.show(context, 'Por favor llena todos los campos');
      return;
    }
    if(idCategory == null || idCategory == '0'){
      MySnackbar.show(context, 'Parece que te falta seleccionar la categoría');
      return;
    }
    if(idType == null){
      MySnackbar.show(context, 'No hay un tipo de transacción definido');
      return;
    }
    print("Transaccion: $transactionDescription, valor: $value, categoria: $idCategory, tipo: $idType");
    Transaction transaction = new Transaction(
      name: transactionDescription,
      price: double.parse(value),
      idCategory: int.parse(idCategory!),
      idType: int.parse(idType!),
      idUser: int.parse(idUser!)
    );

    print("Transaction ${transaction.toJson()}");
    ResponseApi? responseApi = await _transactionProvider.create(transaction);
    _progressDialog.show(max: 100, msg: 'Espera un momento');
    if(responseApi!=null){
      _progressDialog.close();
      MySnackbar.show(context, responseApi!.message!);
    }

    if(responseApi!.success!){
      transactionController.text = '';
      valueController.text = '';
      idCategory = '0';
    }
  }

  Future<void> _loadCategories(String typeId, int idUser) async {
    try {
      print("TypeId: $typeId");
      categories = await _categoriesProvider.getCategoriesByType(typeId,idUser);
      print("Categories: $categories");
      refresh!();
      isInitialize = false;
      idType = typeId;
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir durante la carga de categorías
      print('Error al cargar categorías: $e');
      categories = [];
    }
  }

  void initializeCategories({String? typeId, String? nameType}) {
    int idUser = int.parse(user.id!);
    if (typeId != null) {
      _loadCategories(typeId,idUser);
    }
  }
}