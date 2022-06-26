import 'dart:convert';

import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/deposito.dart';
import 'package:http/http.dart' as http;

class DepositoService {
  static final DepositoService _instance = new DepositoService.internal();
  factory DepositoService() => _instance;
  DepositoService.internal();

  Future<Deposito> getDepositoById(int idDeposito) async {
    final response =
        await http.get(Uri.parse(apiBaseUrl + '/deposito/$idDeposito'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);

      print(parsed);
      return Deposito.fromJson(parsed);
    } else {
      throw Exception('Failed to load deposito');
    }
  }
}
