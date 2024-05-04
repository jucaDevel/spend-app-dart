import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/pages/categories/create/categories_controller.dart';
import 'package:cost_tracker_app/src/pages/home/home_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  HomeController _con = new HomeController();
  CategoriesController _conCategory = new CategoriesController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.init(context, refresh);
    _conCategory.init(context, refresh);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: 60),
          child: Text(
              "Crear categorías",
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
          _backgroundCategories(),
          _contentCategories()
        ],
      ),
    );
  }

  Widget _backgroundCategories(){
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
  Widget _contentCategories(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80,),
            Material(
                elevation: 5.0,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: _dataCategories()
            ),
          ],
        ),
      ),
    );
  }
  Widget _dataCategories(){
    return Container(
      height: 600,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textFieldNameCategory(),
          _textFieldDescriptionCategory(),
          _dropDownCategories(_conCategory.types),
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
  Widget _textFieldNameCategory(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        controller: _conCategory.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre de la categoria',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.list_alt,
              color: MyColors.primaryColor,)
        ),
      ),
    );
  }
  Widget _textFieldDescriptionCategory(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.31,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        maxLength: 255,
        maxLines: 9,
        keyboardType: TextInputType.text,
        controller: _conCategory.descriptionController,
        decoration: InputDecoration(
            hintText: 'Descripción de la categoria',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            suffixIcon: Icon(
              Icons.description,
              color: MyColors.primaryColor,
            )
        ),
      ),
    );
  }
  Widget _buttonCreate(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 30),
      child: ElevatedButton(
        onPressed:_conCategory.createCategory,
        child: Text('Crear Categoria'),
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

  Widget _dropDownCategories(List<TypeTransaction> types){
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
                    'Selecciona un Tipo',
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
                  items: _dropDownItems(types),
                  onChanged: (option){
                    setState(() {
                      print('Tipo Seleccionado: $option');
                      _conCategory.idType = option!;//Estableciendo el valor seleccionado a la variable idCategory
                    });
                  },
                  value: _conCategory.idType,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<TypeTransaction> types){
    List<DropdownMenuItem<String>> list = [];
    types.forEach((type) {
      list.add(DropdownMenuItem(
        child: Text(type.name!),
        value: type.id,
      ));
    });

    return list;
  }

  void refresh(){
    setState(() {});
  }
}
