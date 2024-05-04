import 'package:cost_tracker_app/src/models/category.dart';
import 'package:cost_tracker_app/src/models/type.dart';
import 'package:cost_tracker_app/src/pages/categories/create/categories_controller.dart';
import 'package:cost_tracker_app/src/pages/home/home_controller.dart';
import 'package:cost_tracker_app/src/pages/transaction/type/transaction_type_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionTypePage extends StatefulWidget {
  const TransactionTypePage({Key? key}) : super(key: key);

  @override
  State<TransactionTypePage> createState() => _TransactionTypePageState();
}

class _TransactionTypePageState extends State<TransactionTypePage> {

  HomeController _con = new HomeController();
  TransactionTypeController _conType = new TransactionTypeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
      _conType.init(context,refresh);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.key,
        appBar: AppBar(
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
              _backgroundTypes(),
              _buildGridView()
            ]
        ),
    );
  }

  Widget _backgroundTypes(){
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
  Widget _buildGridView() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: _conType.types.length,
        itemBuilder: (context, index) {
          final type = _conType.types[index];
          return _cardType(type);
        },
      ),
    );
  }
  Widget _cardType( TypeTransaction type){
    return GestureDetector(
      onTap: (){
       _conType.goToInsertPage(type.id!,type.name!);
      },
      child: Container(
        height: 300,
        child: Card(
          color: MyColors.primaryColor,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      type.image ?? '', // Reemplaza con la ubicación de tu archivo SVG
                      width: 400, // Ajusta el ancho según tus necesidades
                      height: 400, // Ajusta la altura según tus necesidades
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 15,
                    child: Text(
                      type.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'NimbusSans',
                        color: Colors.white
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh(){
    setState(() {});
  }
}
