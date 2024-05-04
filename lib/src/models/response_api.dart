import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String? message;
  String? error;
  bool? success;
  dynamic data;

  ResponseApi({
    this.message,
    this.error,
    this.success,
  });

  ResponseApi.fromJson(Map<String, dynamic> json) {
    message = json["message"];
    error= json["error"];
    success = json["success"];

    try {
      if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
        data = json['data'];
      }
    }catch(e){
      print('Exception data $e');
    }
  } //metodo que recibe la respuesta del servidor en formato JSON y posteriormente va desestructurando esa respuesta para dar mejor manejo a ella

  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error,
    "success": success,
    "data": data
  };
}