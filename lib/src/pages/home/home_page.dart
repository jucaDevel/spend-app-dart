import 'dart:ffi';

import 'package:cost_tracker_app/src/pages/home/home_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:cost_tracker_app/src/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _con = new HomeController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
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
          _backgroundHome(),
          _cardTotalAvailable(),
          _cardTotalIn(),
          _cardsSavingAndBills()
        ],
      ),
    );
  }

  Widget _backgroundHome(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                MyColors.primaryColor,
                MyColors.secondaryColorHome,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.5, 1]
          )
      ),
    );
  }

  Widget _cardTotalAvailable() {
    return Stack(
          children: [
            Container(
              width: 600,
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  color: Colors.white
              ),
            ),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.only(right: 15,top: 5,bottom: 10),
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      'assets/svg/coins.svg', // Reemplaza con la ubicación de tu archivo SVG
                      width: 200, // Ajusta el ancho según tus necesidades
                      height: 160, // Ajusta la altura según tus necesidades
                    ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    "Saldo disponible para el resto del mes:",
                    style: TextStyle(
                      fontFamily: 'NimbusSans',
                      fontSize: 13,
                      color: MyColors.primaryColorDark
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15,top: 5),
                  alignment: Alignment.centerRight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Obtener el ancho disponible en el contexto
                      double availableWidth = constraints.maxWidth;

                      // Ajustar el tamaño del texto en función del ancho disponible
                      double fontSize = availableWidth / _con.totalAvailable.toString().length;

                      // Limitar el tamaño mínimo y máximo del texto
                      fontSize = fontSize.clamp(12.0, 50.0);

                     if(_con.isLoaded == 0){
                       return ProgressWidget(text: '');
                     }
                     else{
                       return Column(
                         children: <Widget>[
                           // Ajustar el tamaño del texto
                           Align(
                             alignment: Alignment.centerRight,
                             child: Text(
                               NumberFormat.currency(
                                 locale: 'es', // Puedes ajustar la localización según tus necesidades
                                 symbol: '\$',
                                 decimalDigits: 0,// Símbolo de la moneda
                               ).format(_con.totalAvailable),
                               style: TextStyle(
                                   fontSize: fontSize,
                                   fontFamily: 'NimbusSans',
                                   color: MyColors.primaryColorDark
                               ),
                             ),
                           ),
                         ],
                       );
                     }
                    },
                  ),
                ),
              ],
            )
          ]
        );
  }
  Widget _cardTotalIn() {
    return GestureDetector(
      onTap: (){
        _con.goToTransactionPage("1", "INGRESOS");
      },
      child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.30,
                  right: MediaQuery.of(context).size.height * -0.03,
                  left: MediaQuery.of(context).size.height * -0.03,
                  child: Container(
                    width: 500,
                    height: 150,
                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  right: MediaQuery.of(context).size.height * 0.12,
                  child:Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 15),
                        child: Text(
                          "Total de ingresos este mes",
                          style: TextStyle(
                              fontFamily: 'NimbusSans',
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                  )
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.43,
                    right: MediaQuery.of(context).size.height * 0.03,
                    child: Container(
                      margin: EdgeInsets.only(right: 15,top: 5),
                      alignment: Alignment.centerRight,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Obtener el ancho disponible en el contexto
                          double availableWidth = constraints.maxWidth;

                          // Ajustar el tamaño del texto en función del ancho disponible
                          double fontSize = availableWidth / _con.totalRevenues.toString().length;

                          // Limitar el tamaño mínimo y máximo del texto
                          fontSize = fontSize.clamp(12.0, 25.0);
                          if(_con.isLoaded == 0){
                            return ProgressWidget(text: '');
                          }
                          else{
                            return _dataMoney(fontSize,_con.totalRevenues);
                          }
                        },
                      ),
                    ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.38,
                  right: MediaQuery.of(context).size.height * 0.2,
                  child: Container(
                    margin: EdgeInsets.only(right: 15,top: 5),
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                          'assets/svg/money-in.svg', // Reemplaza con la ubicación de tu archivo SVG
                          width: 200, // Ajusta el ancho según tus necesidades
                          height: 200, // Ajusta la altura según tus necesidades
                      ),
                    )
                )
              ]
          ),
    );
  }
  Widget _cardsSavingAndBills(){
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.52,
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  _con.goToTransactionPage("2", "SALIDAS");
                },
                child: Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 270,
                      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.height * 0.02,
                        child:Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 15),
                          child: Text(
                            "Gastos este mes",
                            style: TextStyle(
                                fontFamily: 'NimbusSans',
                                fontSize: 17,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.09,
                      left: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                        margin: EdgeInsets.only(right: 15,top: 5),
                        alignment: Alignment.centerRight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Obtener el ancho disponible en el contexto
                            double availableWidth = constraints.maxWidth;

                            // Ajustar el tamaño del texto en función del ancho disponible
                            double fontSize = availableWidth / _con.totalExpenses.toString().length;

                            // Limitar el tamaño mínimo y máximo del texto
                            fontSize = fontSize.clamp(12.0, 25.0);
                            if(_con.isLoaded == 0){
                              return ProgressWidget(text: '');
                            }
                            else{
                              return _dataMoney(fontSize,_con.totalExpenses);
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.17,
                        child: Container(
                          margin: EdgeInsets.only(right: 15,top: 5,left: 10),
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            'assets/svg/manage-money.svg', // Reemplaza con la ubicación de tu archivo SVG
                            width: 160, // Ajusta el ancho según tus necesidades
                            height: 160, // Ajusta la altura según tus necesidades
                          ),
                        )
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  _con.goToTransactionPage("3", "AHORROS");
                },
                child: Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 270,
                      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.height * 0.02,
                        child:Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 15),
                          child: Text(
                            "Ahorros este mes",
                            style: TextStyle(
                                fontFamily: 'NimbusSans',
                                fontSize: 17,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.09,
                      left: MediaQuery.of(context).size.height * 0.05,
                      child: Container(
                        margin: EdgeInsets.only(right: 5,top: 5),
                        alignment: Alignment.centerRight,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Obtener el ancho disponible en el contexto
                            double availableWidth = constraints.maxWidth;

                            // Ajustar el tamaño del texto en función del ancho disponible
                            double fontSize = availableWidth / _con.totalSavings.toString().length;

                            // Limitar el tamaño mínimo y máximo del texto
                            fontSize = fontSize.clamp(12.0, 25.0);
                            if(_con.isLoaded == 0){
                              return ProgressWidget(text: '');
                            }
                            else{
                              return _dataMoney(fontSize,_con.totalSavings);
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.17,
                        child: Container(
                          margin: EdgeInsets.only(right: 15,top: 5,left: 10),
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            'assets/svg/piggy-bank.svg', // Reemplaza con la ubicación de tu archivo SVG
                            width: 130, // Ajusta el ancho según tus necesidades
                            height: 130, // Ajusta la altura según tus necesidades
                          ),
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  Widget _dataMoney(double fontSize, int totalMoney ){
    return Column(
      children: <Widget>[
        // Ajustar el tamaño del texto
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            NumberFormat.currency(
              locale: 'es', // Puedes ajustar la localización según tus necesidades
              symbol: '\$',
              decimalDigits: 0,// Símbolo de la moneda
            ).format(totalMoney),
            style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'NimbusSans',
                color: Colors.white
            ),
          ),
        ),
      ],
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
                      )/*FadeInImage(
                        image: NetworkImage(_con.user?.image ?? 'https://firebasestorage.googleapis.com/v0/b/cost-tracker-app-4ee01.appspot.com/o/no-image.png?alt=media&token=fe266f62-7a4d-44dc-b1b5-5a57c1f902d1'),
                        fit: BoxFit.fitWidth,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      )*/,
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

  void refresh(){
    setState(() {});
  }
}
