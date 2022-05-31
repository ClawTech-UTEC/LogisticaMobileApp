import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DistribuidoresService {
static final DistribuidoresService _instance = new DistribuidoresService.internal();
  factory DistribuidoresService() => _instance;
  DistribuidoresService.internal();

  Future<List<Distribuidor>> getDistribuidores() async {
    final response = await http.post(Uri.parse(apiBaseUrl + '/dist'));
    print(response.body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<Distribuidor>((json) => Distribuidor.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Distribuidor');
    }
  }
}
