import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PedidosService {
  static final PedidosService _instance = new PedidosService.internal();
  factory PedidosService() => _instance;
  PedidosService.internal();

  Future<List<Pedido>> getPedidos() async {
    final response = await http.post(Uri.parse(apiBaseUrl + '/pedidos'));
    print(response.body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Pedido>((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  Future<List<Pedido>> getPedidosByCliente(int idCliente) async {
    final response =
        await http.post(Uri.parse(apiBaseUrl + '/pedidos/cli/'), body: {
      'idCliente': idCliente.toString(),
    });
    print(response.body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Pedido>((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  Future<List<Pedido>> getPedidosByDistribuidor(int idDistribuidor) async {
    final response =
        await http.post(Uri.parse(apiBaseUrl + '/pedidos/dist/'), body: {
      'idDistribuidor': idDistribuidor.toString(),
    });
    print(response.body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Pedido>((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pedidos');
    }
  }
}
