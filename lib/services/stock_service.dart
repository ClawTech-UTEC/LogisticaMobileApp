import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class StockService {
  static final StockService _instance = new StockService.internal();
  factory StockService() => _instance;
  StockService.internal();

  Future<List<Producto>> getProductosDisponibles() async {
    final response =
        await http.get(Uri.parse(apiBaseUrl + '/productosDisponibles'));
    print(response.body);
    if (response.statusCode == 200) {
      List<Producto> productos = List<Producto>.from(
          json.decode(response.body).map((x) => Producto.fromJson(x)));
      ;
      return productos;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
