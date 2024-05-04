import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

class MySnackbar{
  static void show(BuildContext context, String text){
    if(context == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(
          content:
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14
            ),
          ),
          backgroundColor: MyColors.primaryColorDark,
          duration: Duration(seconds: 3),
        )
    );
  }
}