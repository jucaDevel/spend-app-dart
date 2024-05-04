import 'dart:convert';

import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/transaction.dart';
import 'package:cost_tracker_app/src/pages/home/home_controller.dart';
import 'package:cost_tracker_app/src/pages/transaction/list/transanction_list_controller.dart';
import 'package:cost_tracker_app/src/pages/transaction/type/transaction_type_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:cost_tracker_app/src/widgets/no_data_widget.dart';
import 'package:cost_tracker_app/src/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  HomeController _con = new HomeController();
  TransactionTypeController _conType = new TransactionTypeController();
  TransactionListController _conList = new TransactionListController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
      _conType.init(context, refresh);
      _conList.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String typeId = arguments['typeId'];
    final String nameType = arguments['nameType'];
    // Se hace el llamdo al constructor de la clase del controller para poder pasar los parametros que recibimos de la vista anterior
    if(_conList.isInitialize==true){
      _conList.initializeCategories(typeId: typeId,nameType: nameType);
      if(_conList.isTransactionsLoaded != true){
        _conList.initializeTransactions(typeId,_conList.idCategory);
      }
    }
    return Scaffold(
      key: _con.key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(135.0), // Tamaño deseado
        child: AppBar(
          title: Container(
            margin: EdgeInsets.only(left: 50),
            child: Text(
              nameType,
              style: TextStyle(
                  color: MyColors.primaryColorDark
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: [
            _reloadAll(),
            _addTransaction(typeId,nameType),
          ],
          flexibleSpace: Column(
            children: [
              SizedBox(height: 45,),
              _menuDrawer(),
              _dropDownCategories(_conList.categories,typeId)
            ],
          ),
        ),
      ),
      drawer: _drawer(),
      body: FutureBuilder(
                future: Future.value(_conList.transactions),
                builder: (context, AsyncSnapshot<List<Transaction>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return ProgressWidget(text: 'Espera un momento');
                  }
                  else if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _contentListTransaction(snapshot.data![index],nameType);
                        },
                      );
                    } else {
                      return NoDataWidget(text: 'Ocurrió un error al traer la info, lo sentimos');
                    }
                  } else {
                    return NoDataWidget(text: 'No hay Movimientos');
                  }
                },
              ),
      bottomSheet: Card(
          elevation: 5.0,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Container(
                      child: Text(
                            'Total gastado:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'NimbusSans'
                            ),
                            textAlign: TextAlign.left,
                          ),
                    )
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Container(
                      child: Text(
                        NumberFormat.currency(
                          locale: 'es', // Puedes ajustar la localización según tus necesidades
                          symbol: '\$',
                          decimalDigits: 0,// Símbolo de la moneda
                        ).format(_conList.totalMoney),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'NimbusSans'
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                ),
              ),
            ],
          ),
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      ),
    );
  }
  Widget _contentListTransaction(Transaction transaction,String nameType){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Material(
                elevation: 5.0,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: _listTransaction(transaction,nameType)
            )
          ],
        ),
      ),
    );
  }
  Widget _listTransaction(Transaction transaction,String nameType){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: Row(
          children: [
            Container(
              child: Expanded(
                  child: Text(
                    transaction.name!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'NimbusSans'
                    ),
                  )
              ),
            ),
            SizedBox(width: 20),
            Container(
              child: Expanded(
                  child: Text(
                    NumberFormat.currency(
                      locale: 'es', // Puedes ajustar la localización según tus necesidades
                      symbol: '\$',
                      decimalDigits: 0,// Símbolo de la moneda
                    ).format(transaction.price),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'NimbusSans'
                    ),
                  )
              ),
            ),
            Container(
              child: Expanded(
                  child: Text(
                    transaction.createdAt!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'NimbusSans'
                    ),
                  )
              ),
            ),
            GestureDetector(
              onTap: (){
                _con.goToEditTransactionPage(transaction.id!,transaction.idType!,nameType);
              },
              child: Icon(
                Icons.edit,
                color: Colors.black,
                size: 25,
              ),
            )
          ],
        )
    );
  }
  Widget _addTransaction(String typeId, String nameType){
    return Tooltip(
      message: 'Nueva transacción',
      child: GestureDetector(
        onTap: (){
          _conType.goToInsertPage(typeId, nameType);
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10,top: 8),
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reloadAll(){
    return Tooltip(
      message: 'Cargar de nuevo la pagina',
      child: GestureDetector(
        onTap: (){
          refresh();
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10,top: 8),
              child: Icon(
                Icons.refresh_outlined,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuDrawer(){
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 20),
        child: Image.asset('assets/img/menu.png', width: 30, height: 30),
      ),
    );
  }
  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 300,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      width: 300,
                      margin: EdgeInsets.only(bottom: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50), // Ajusta el valor según el grado de redondeo que desees
                        child: Image.network(
                          _con.user?.image ?? 'https://firebasestorage.googleapis.com/v0/b/cost-tracker-app-4ee01.appspot.com/o/no-image.png?alt=media&token=fe266f62-7a4d-44dc-b1b5-5a57c1f902d1',
                          width: 200, // Ancho deseado de la imagen
                          height: 200, // Alto deseado de la imagen
                          fit: BoxFit.fitWidth, // Ajusta la imagen para que cubra todo el espacio recortado
                        ),
                      ),
                    ),
                    Text(
                      '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      _con.user?.email ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ],
                )
            ),
          ),
          ListTile(
            onTap: _con.goToTransactions,
            title: Text('Realizar Transaccion'),
            trailing: Icon(Icons.attach_money_outlined),
          ),
          ListTile(
            onTap: _con.goToCategory,
            title: Text('Categorias'),
            trailing: Icon(Icons.folder_copy_outlined),
          ),
          ListTile(
            onTap: _con.goToBalance,
            title: Text('Ver balances por mes'),
            trailing: Icon(Icons.auto_graph_outlined),
          ),
          /*ListTile(
            onTap: (){},
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person_outline),
          ),*/
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar Sesión'),
            trailing: Icon(Icons.power_settings_new),
          )
        ],
      ),
    );
  }


  Widget _dropDownCategories(List<Category> categories,String idType){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'Seleccionar Tipo',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                    ),
                  ),
                  items: _dropDownItems(categories),
                  value: _conList.idCategory ?? '0',
                  onChanged: (option) async{
                    _conList.idCategory = option;
                    await _conList.initTransactionsByChangeCat(option);
                    setState(() {
                      print('Tipo Seleccionado: $option');
                      print('Transacciones: ${jsonEncode(_conList.transactions)}');
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list = [];
    String defaultValue = '0';
    bool existDefaultValue = false;
    categories.forEach((category) {
      list.add(DropdownMenuItem(
        child: Text(category.name!),
        value: category.id,
      ));
      if (category.id == defaultValue) {
        existDefaultValue = true;
      }
    });
    if (!existDefaultValue) {
      list.add(DropdownMenuItem(
        child: Text('Sin categoría'),
        value: defaultValue,
      ));
    }

    return list;
  }


  void refresh(){
    setState(() {});
  }
}
