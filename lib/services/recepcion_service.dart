import 'dart:convert';

import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecepcionService {
  Future<Recepcion> createRec(Recepcion recepcion) async {
    print("-----");
    print(recepcion.toJson());
    print("-----");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Usuario usuarioCreador =
        Usuario.fromJson(json.decode(prefs.getString("token")!));
    print(usuarioCreador.toJson());
    recepcion.estadoRecepcion.forEach((EstadoRecepcion element) {
      element.usuario = usuarioCreador;
    });

    final response = await http.post(
      Uri.parse(apiBaseUrl + '/recepcion'),
      body: jsonEncode(recepcion.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("Respuesta del servidor:");
    print(response.body);
    if (response.statusCode == 201) {
      return Recepcion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  Future<List<Recepcion>> getRecepciones() async {
    
    
    final response = await http.get(
      Uri.parse(apiBaseUrl + '/recepcion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
       
      },
    );
    if (response.statusCode == 200) {
      return List<Recepcion>.from(
          json.decode(response.body).map((x) => Recepcion.fromJson(x)));
    } else {
      throw Exception('Failed');
    }
  }


}
