import 'package:cost_tracker_app/src/pages/login/login_controller.dart';
import 'package:cost_tracker_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();
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
              _imageBanner(),
              Text(
                "Bienvenido",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "Controla tus gastos, Controla tu vida",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
              SizedBox(height: 15,),
              _dataLogin()
            ],
          ),
        ),
    );
  }
  Widget _imageBanner(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
          top:MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.04
      ),
      child: Image.asset(
        'assets/img/spend2.png',
        width: 300,
        height: 300,
      ),
    );
  }
  Widget _dataLogin(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textFieldEmail(),
          _textFieldPassword(),
          _buttonLogin(),
          _textDontHaveAccount()
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
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
                hintText: '¡Tú correo!',
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
              hintText: '¡Tú contraseña!',
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

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
      child: ElevatedButton(
        onPressed: _con.login,
        child: Text('Ingresar'),
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

  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(
              color: MyColors.primaryColor
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor
            ),
          ),
        )
      ],
    );
  }

  void refresh(){
    setState(() {});
  }
}
