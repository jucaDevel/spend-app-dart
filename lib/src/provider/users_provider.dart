import 'dart:convert';
import 'dart:io';

import 'package:cost_tracker_app/src/api/environment.dart';
import 'package:cost_tracker_app/src/models/response_api.dart';
import 'package:cost_tracker_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider{
  String _url =Environment.API_COST_TRACKER; //Crear la instancia con la API de node js
  String _api ='/api/user'; //Crear la ruta para realizar las peticiones a la APlate I

  late BuildContext context;
  late User sessionUser;

  Future init(BuildContext context,{User? sessionUser}) async {
    this.context =context;
    if(sessionUser!=null){
      this.sessionUser = sessionUser;
    }
  }

  Future<Stream?> createUser(User user,File image) async{
    try{
      Uri url = Uri.http(_url,'$_api/create'); //Hago la petición a la API
      final request = http.MultipartRequest('POST',url); //Envio la petición y los parametros de tipo de petición y la url que armé anteriormente
      if (image != null){
        request.files.add(http.MultipartFile( //Agrego la imagen a la variable que se envía con la petición
            'image',
            http.ByteStream(image.openRead().cast()), // Abro la imagen y la preparo para ser enviada por http a Node
            await image.length(),
            filename: basename(image.path)
        ));
      }
      request.fields['user'] = jsonEncode(user); //Agrego el objeto con los datos del usuario a la variable que se envia con la petición
      final response = await request.send(); //Envio la petición y almaceno la respuesta dentro de la variable
      return response.stream.transform(utf8.decoder); //Transformo la respuesta en una cadena de caracteres y la retorno para ser recibida
    }
    catch(e){
      print("Error: $e");
      return null;
    }
  }

  Future<ResponseApi?> login(String email, String password) async{
    try{
      Uri url =Uri.http(_url,'$_api/login'); //Hago el llamado a la ruta
      String bodyParams = jsonEncode({
        'email':email,
        'password':password
      }); //Creo un objeto llamado bodyParams para guardar el email y la contraseña que el usuario envía desde la App
      Map<String, String> headers = {
        'Content-type':'application/json'
      }; //Creo los headers para realizar la petición

      final res =await http.post(url,headers: headers,body: bodyParams); //envio la petición haciendo uso de HTTP, envio la url que se creo al principio, y en body agrego el objeto con los parametros
      final data = jsonDecode(res.body); // hago un jsonDecode a la respuesta que me envía el backend y la guardo en una variable
      ResponseApi? responseApi =ResponseApi.fromJson(data); //Llamo a responseApi para que me ayude a legibilizar la respuesta
      return responseApi!;
    }
    catch(e){
      print("Error $e");
      return null;
    }
  }

  Future<ResponseApi?> logout(String idUser) async {
    try{
      Uri url = Uri.http(_url,'$_api/logout');
      String bodyParams = json.encode({
        'id': idUser
      });
      Map<String, String> headers = {
        'Content-type':'application/json'
      };

      final res = await http.post(url,headers:headers,body:bodyParams);
      final data = json.decode(res.body);
      ResponseApi? responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e){
      print('Error: $e');
      return null;
    }

  }
}