import 'dart:convert';

import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:http/http.dart' as http;

class RecepcionService {
  Future<Recepcion> createRec(Recepcion recepcion) async {
    print(recepcion.toJson());
    final response = await http.post(Uri.parse(apiBaseUrl + '/recepcion'),
        body: {"recepcion" : recepcion.toJson().toString()});

    print(response.body);
    if (response.statusCode == 200) {
      return Recepcion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed');
    }
  }
}
