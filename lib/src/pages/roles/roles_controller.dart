import 'package:cost_tracker_app/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';


import '../../models/user.dart';

class RolesController{
  late BuildContext context;
  late Function refresh;
  late User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));
    print(user);
    refresh();
  }

  void goToPage(String route){
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  void logout(){
    _sharedPref.logout(context, user?.id ?? '');
  }
}