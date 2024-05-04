import 'package:cost_tracker_app/src/pages/roles/roles_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';


import '../../models/rol.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {

  RolesController _con = new RolesController();

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
        appBar: AppBar(
          title: Text(
              'Selecciona un rol',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
              ),
          ),
          backgroundColor: MyColors.primaryColor,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
          child: ListView(
            children: _con.user != null ? _con.user.roles!.map((Rol rol){
              return _cardRol(rol);
            }).toList() : [],
          ),
        )
    );
  }

  Widget _cardRol(Rol rol){
    return GestureDetector(
      onTap: (){_con.goToPage(rol!.route);},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 40),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                height: 100,
                child: SvgPicture.network(
                  rol.image ?? "https://firebasestorage.googleapis.com/v0/b/cost-tracker-app-4ee01.appspot.com/o/503%20Error%20Service%20Unavailable-rafiki.svg?alt=media&token=9b11be89-2e6c-4654-b9f4-0b51d504b01c",
                  width: 200, // Tamaño deseado
                  height: 200,
                ),
              ),
              SizedBox(height: 15),
              Text(
                  rol!.name ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: MyColors.primaryColorDark,
                      fontFamily: 'NimbusSans'
                  )
              ),
              SizedBox(height: 25),
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
