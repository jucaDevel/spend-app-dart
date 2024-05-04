import 'dart:io';

import 'package:cost_tracker_app/src/pages/register/register_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  RegisterController _con = new RegisterController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.init(context,refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
          children: [
            _backgroundLogin(),
            _contentLogin(),
          ],
        )
    );
  }

  Widget _backgroundLogin(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                MyColors.secondaryColor,
                MyColors.primaryColor,
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft
          )
      ),
    );
  }

  Widget _contentLogin(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80,),
            _dataLogin()
          ],
        ),
      ),
    );
  }
  Widget _dataLogin(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageUser(),
          _textFieldName(),
          _textFieldLastName(),
          _textFieldEmail(),
          _textFieldPassword(),
          _textFieldConfirmPassword(),
          _buttonRegister(),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
    );
  }

  Widget _textFieldName(){
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Nombre',
            style: TextStyle(
                color: MyColors.primaryColorDark
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: MyColors.primaryOpacityColor,
              borderRadius: BorderRadius.circular(5)
          ),
          child: TextFormField(
            controller: _con.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: '¡Tu nombre!',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color: MyColors.primaryColorDark
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldLastName(){
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'Apellido',
            style: TextStyle(
                color: MyColors.primaryColorDark
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: MyColors.primaryOpacityColor,
              borderRadius: BorderRadius.circular(5)
          ),
          child: TextFormField(
            controller: _con.lastnameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: '¡Tu apellido!',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color: MyColors.primaryColorDark
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: Container(
          margin: EdgeInsets.only(
              left:MediaQuery.of(context).size.height * 0.08,
              right: MediaQuery.of(context).size.height * 0.06
          ),
          height: 150,
          width: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Esto asegura que el contenedor sea circular
          border: Border.all(
            color: MyColors.primaryColorDark, // Color del borde
            width: 2.0, // Ancho del borde
          ),
        ),
        child: _con.imageFile != null
            ? CircleAvatar(
          backgroundImage: FileImage(_con.imageFile!),
          radius: 58,
          backgroundColor: Colors.white,
          ) : CircleAvatar(
          backgroundImage: AssetImage("assets/img/user_profile.png"),
          radius: 58,
          backgroundColor: Colors.white,
        ), // En caso de _con.imageFile sea null, muestra un Text u otro widget
        ),
    );
  }

  Widget _textFieldEmail(){
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Email",
            style: TextStyle(
                color: MyColors.primaryColorDark
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: MyColors.primaryOpacityColor,
              borderRadius: BorderRadius.circular(5)
          ),
          child: TextFormField(
            controller: _con.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: '¡Tu correo!',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintStyle: TextStyle(
                  color: MyColors.primaryColorDark
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldPassword(){
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Contraseña",
            style: TextStyle(
                color: MyColors.primaryColorDark
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: MyColors.primaryOpacityColor,
              borderRadius: BorderRadius.circular(5)
          ),
          child: TextFormField(
            controller: _con.passwordController,
            obscureText: _con.obs,
            decoration: InputDecoration(
                hintText: '¡Tu contraseña!',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle: TextStyle(
                    color: MyColors.primaryColorDark
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  onPressed: _con.viewPassword,
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldConfirmPassword(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: MyColors.primaryOpacityColor,
              borderRadius: BorderRadius.circular(5)
          ),
          child: TextFormField(
            controller: _con.confirmPasswordController,
            obscureText: _con.obsConfirm,
            decoration: InputDecoration(
                hintText: '¡Confírmala!',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                hintStyle: TextStyle(
                    color: MyColors.primaryColorDark
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined),
                  onPressed: _con.viewPasswordConfirm,
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
      child: ElevatedButton(
        onPressed: _con.register,
        child: Text('Registrarse'),
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

  void refresh(){
    setState(() {});
  }
}
