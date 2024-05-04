import 'dart:convert';

import 'package:cost_tracker_app/src/models/response_api.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/users_provider.dart';
import 'package:cost_tracker_app/src/utils/my_snackbar.dart';
import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoginController {
  late BuildContext context;
  bool obs = true;
  late Function refresh;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  UsersProvider usersProvider = new UsersProvider();
  SharedPref _sharedPref = new SharedPref();
  dynamic dataSharedPref;
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    await usersProvider.init(context);
    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    print("User: ${jsonEncode(user)}");
    print("Session: ${user.sessionToken}");
    if(user.sessionToken != null){
      if(user.roles != null && user.roles!.length > 1){
        Navigator.pushNamedAndRemoveUntil(context,'roles',(route) => false);
      }
      else{
        if (user.roles?.isNotEmpty == true) { //Hago una validación adicional para que la lista de roles del usuario no venga null y así acceder a la info que hay en el campo route de la tabla en BD
          Navigator.pushNamedAndRemoveUntil(context, user.roles![0].route, (route) => false);
        }
      }
    }
  }

  void viewPassword(){
    if (obs == true){
      obs = false;
    }
    else if(obs == false){
      obs = true;
    }
    refresh();
  }

  void goToRegisterPage(){
    Navigator.pushNamed(context, "register");
  }

  void login() async{
    try{
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      ResponseApi? responseApi = await usersProvider.login(email, password); //Hago la llamada al metodo del provider para que se envien los datos al backend
      if(responseApi != null){
        bool success =responseApi?.success ?? false;
        if(success == true){ //Valido que la respuesta sea success o en caso tal de llegar
          String dataJson = jsonEncode(responseApi.data);
          Map<String, dynamic> userData = json.decode(dataJson);
          User user = User.fromJson(userData); //Creo un objeto de tipo User con los datos del usuario de sesion
          _sharedPref.save('user', user.toJson()); //Guardo esos datos en sharedPref para tener acceso a ellos sin tener que ir a la BD
          if(user.roles != null && user.roles!.length > 1){ //Valido que la lista con los roles del usuario no venga null y que la cantidad de roles que tiene este sea mayor a uno
            Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
            dataSharedPref = await _sharedPref.read('user') ?? {};
            print("dataSharedPref $dataSharedPref");
          }
          else{
            if (user.roles?.isNotEmpty == true) { //Hago una validación adicional para que la lista de roles del usuario no venga null y así acceder a la info que hay en el campo route de la tabla en BD
              Navigator.pushNamedAndRemoveUntil(context, user.roles![0].route, (route) => false);
            }
          }
        }
        else{
          String message = responseApi?.message ?? "Null error";
          MySnackbar.show(context, message);
        }
        print('Respuesta:${responseApi?.toJson()}');
      }
    }
    catch(e){
      print("Error: $e");
    }
  }

  void logout(){

  }
}