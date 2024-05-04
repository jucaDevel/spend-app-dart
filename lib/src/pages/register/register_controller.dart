import 'dart:convert';
import 'dart:io';

import 'package:cost_tracker_app/src/models/response_api.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:cost_tracker_app/src/provider/users_provider.dart';
import 'package:cost_tracker_app/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegisterController{
  late BuildContext context;
  bool obs = true;
  bool obsConfirm = true;
  late Function refresh;
  bool isEnable = true;
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  late PickedFile pickedFile;
  File? imageFile;
  late ProgressDialog _progressDialog;
  UsersProvider usersProvider = new UsersProvider(); //Creo la instancia con la clase Provider que contiene las peticiones

  RegisterController() {
    // Constructor vacío, no se inicializa imageFile aquí
  }

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context); //Inicializo el progressDialog
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
  void viewPasswordConfirm(){
    if (obsConfirm == true){
      obsConfirm = false;
    }
    else if(obsConfirm == false){
      obsConfirm   = true;
    }
    refresh();
  }

  Future selectImage(ImageSource imageSource) async {
    final pickedFile = (await ImagePicker().pickImage(source: imageSource));
    if(pickedFile != null){
      imageFile = File(pickedFile.path);
      print("Image selected: ${imageFile?.path}");
    }else{
      imageFile = File("assets/img/user_profile.png");
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
        onPressed: (){selectImage(ImageSource.gallery);},
        child: Text('GALERIA')
    );
    Widget cameraButton = ElevatedButton(
        onPressed: (){selectImage(ImageSource.camera);},
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        }
    );
  }

  void register() async{
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if(email.isEmpty || name.isEmpty || lastname.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }

    if(confirmPassword != password){
      MySnackbar.show(context, 'Las contraseñas no coinciden');
      return;
    }

    if(password.length < 6){
      MySnackbar.show(context, 'La contraseña debe tener más de 6 caracteres');
      return;
    }

    if(imageFile == null){
      MySnackbar.show(context, 'Selecciona una imagen por favor');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espera un momento');
    isEnable = false;
    User user = new User(
        email: email,
        name: name,
        lastname: lastname,
        password: password
    ); //Creo el objeto con todos los datos del usuario
    Stream? stream = await usersProvider.createUser(user, imageFile!); //Hago el llamado al metodo que crea el usuario y le paso como parametro el objeto y la imagen
    stream?.listen((res) {
      _progressDialog.close();
      print("RESPUESTA: ${json.decode(res)}");
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res)); // Recibo la respuesta de las petición usando la clase ResponseApi
      print('RESPUESTA: ${responseApi.toJson()}');
      MySnackbar.show(context, responseApi.message.toString());

      if(responseApi.success == true){
        Future.delayed(Duration(seconds: 3),(){
          Navigator.pushReplacementNamed(context, 'login');
        });
      }
      else{
        isEnable = true;
      }
    }); //Metodo para recibir la respuesta del servidor

  }
}