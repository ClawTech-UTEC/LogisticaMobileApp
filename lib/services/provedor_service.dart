


import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:http/http.dart' as http;

class ProvedorService {
  static final ProvedorService _instance = new ProvedorService.internal();
  factory ProvedorService() => _instance;
  ProvedorService.internal();
  Future<List<Provedor>> getProvedores() async {

    
    final response = await http.get(Uri.parse(apiBaseUrl + "/prov"));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      List<Provedor> list = [];
      for (var item in responseJson) {
        list.add(Provedor.fromJson(item));
      }
      return list;
    } else {
      throw FetchDataException("Error desconocido");
    }
  }

  Future<List<Provedor>> getProvedoresByName(String nombre) async {
    print(nombre);
    final response = await http.get(Uri.parse(apiBaseUrl + "/prov/search/nombre/$nombre"));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      List<Provedor> list = [];
      for (var item in responseJson) {
        list.add(Provedor.fromJson(item));
      }
      return list;
    } else {
      throw FetchDataException("Error desconocido");
    }
  }
}