import 'dart:convert';
import 'dart:ffi';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecepcionService {
  static final RecepcionService _instance = new RecepcionService.internal();
  factory RecepcionService() => _instance;
  RecepcionService.internal();

  Future<Recepcion> createRec(Recepcion recepcion, Usuario usuario) async {
    print("-----");
    print(recepcion.toJson());
    print("-----");
    

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

  Future<Recepcion> cancelarRecepcion(int idRecepcion, int idUsuario) async {
    final response = await http.put(
      Uri.parse(apiBaseUrl + '/recepcion/cancelar'),
      body: jsonEncode({
        'idRecepcion': idRecepcion,
        'idUsuario': idUsuario,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Recepcion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }

  Future<Recepcion> controlarRecepcion(
      int idRecepcion,
      Map<String, String> productos,
      int idUsuaurio,
      bool controlarDiferencias) async {

    final http.Response response = await http.post(
      Uri.parse(apiBaseUrl + '/recepcion/controlar'),
      body: jsonEncode({
        "idRecepcion": idRecepcion,
        "productosRecibidos": productos,
        "idUsuario": idUsuaurio,
        "controlarDiferencias": controlarDiferencias
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Recepcion.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }
}
