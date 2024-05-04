import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/pages/home/home_controller.dart';
import 'package:cost_tracker_app/src/pages/transaction/create/transaction_create_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TransactionCreatePage extends StatefulWidget {
  const TransactionCreatePage({Key? key}) : super(key: key);

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  HomeController _con = new HomeController();
  TransactionCreateController _conTransaction = new TransactionCreateController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
      _conTransaction.init(context, refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    // Se reciben los parametros de la vista anterior y se guardan en un Map
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String typeId = arguments['typeId'];
    final String nameType = arguments['nameType'];
    // Se hace el llamdo al constructor de la clase del controller para poder pasar los parametros que recibimos de la vista anterior
    if(_conTransaction.isInitialize==true){
      _conTransaction.initializeCategories(typeId: typeId,nameType: nameType);
    }
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: 60),
          child: Text(
            "Crear Transaccion",
            style: TextStyle(
                color: MyColors.primaryColorDark
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Column(
          children: [
            SizedBox(height: 45,),
            _menuDrawer(),
          ],
        ),
      ),
      drawer: _drawer(),
      body: Stack(
        children: [
          _backgroundTransaction(),
          _contentTransaction(nameType,typeId)
        ],
      ),
    );
  }

  Widget _backgroundTransaction(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft
          )
      ),
    );
  }

  Widget _contentTransaction(nameType,typeId){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80,),
            _dataTransaction(nameType,typeId)
          ],
        ),
      ),
    );
  }
  Widget _dataTransaction(nameType,typeId){
    return Container(
      height: 600,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textFieldNameTransaction(),
          _textFieldPriceTransaction(),
          _dropDownCategories(_conTransaction.categories),
          _textFieldTypeTransaction(nameType,typeId),
          SizedBox(height: 20),
          _buttonCreate(),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
    );
  }

  Widget _textFieldNameTransaction(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        controller: _conTransaction.transactionController,
        keyboardType: TextInputType.text,
        maxLength: 255,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Descripción de la transacción',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.wallet,
              color: MyColors.primaryColor,)
        ),
      ),
    );
  }
  Widget _textFieldPriceTransaction(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        controller: _conTransaction.valueController,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Valor',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.monetization_on,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _textFieldTypeTransaction(nameType,typeId){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color de la sombra
                    spreadRadius: 1, // Extensión de la sombra
                    blurRadius: 4, // Difuminación de la sombra
                    offset: Offset(0, 3), // Desplazamiento de la sombra (efecto 3D)
                  ),
              ],

          ),
          child: TextField(
            enabled: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: nameType,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle: TextStyle(
                    color: MyColors.primaryColorDark
                ),
                suffixIcon: Icon(
                  Icons.text_snippet_rounded,
                  color: MyColors.primaryColor,)
            ),
          ),
        ),
      ],
    );
  }
  Widget _buttonCreate(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 30),
      child: ElevatedButton(
        onPressed:_conTransaction.create,
        child: Text('Crear Transaccion'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
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

  Widget _dropDownCategories(List<Category> categories){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Selecciona una categoría',
                    style: TextStyle(
                        color: MyColors.primaryColorDark,
                        fontSize: 16
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                  value: _conTransaction.idCategory ?? '0',
                  onChanged: (option){
                    setState(() {
                      print('Tipo Seleccionado: $option');
                      _conTransaction.idCategory = option;//Estableciendo el valor seleccionado a la variable idCategory
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
