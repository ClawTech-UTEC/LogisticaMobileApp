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

  Future<Pedido> createPedido(Pedido pedido) async {
    print(jsonEncode(pedido.toJson()));
    final response = await http.post(
      Uri.parse(apiBaseUrl + '/pedidos/'),
      body: jsonEncode(pedido.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
      print(response.statusCode);
    if (response.statusCode == 201) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return Pedido.fromJson(parsed);
    } else {
      throw Exception('Failed to create pedidos');
    }
  }
}
