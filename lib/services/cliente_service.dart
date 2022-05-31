import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClienteService {

  
  Future<List<Cliente>> getAllClientes() async {
    final response = await http.get(Uri.parse(apiBaseUrl + '/cli'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Cliente>((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clientes');
    }
  }
}
