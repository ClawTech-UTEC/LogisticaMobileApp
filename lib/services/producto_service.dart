import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:http/http.dart' as http;

class ProductoService {
  static final ProductoService _instance = new ProductoService.internal();
  factory ProductoService() => _instance;
  ProductoService.internal();

  Future<List<TipoProducto>> getProductos() async {
    final response = await http.post(Uri.parse(apiBaseUrl + '/tipoProductos'));
    print(response.body);
    if (response.statusCode == 200) {
      List<TipoProducto> productos =
          TipoProducto.getTipoProductoListFromJson(response.body);
      return productos;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<TipoProducto>> getProductosByCategoria(int idCategoria) async {
    final response =
        await http.get(Uri.parse('getProductosByCategoria/$idCategoria'));
    if (response.statusCode == 200) {
      List<TipoProducto> productos =
          TipoProducto.getTipoProductoListFromJson(response.body);
      return productos;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<TipoProducto>> getProductosBySubCategoria(
      int idSubCategoria) async {
    final response =
        await http.get(Uri.parse('getProductosBySubCategoria/$idSubCategoria'));
    if (response.statusCode == 200) {
      List<TipoProducto> productos =
          TipoProducto.getTipoProductoListFromJson(response.body);
      return productos;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<TipoProducto>> getProductosByMarca(int idMarca) async {
    final response = await http.get(Uri.parse('getProductosByMarca/$idMarca'));
    if (response.statusCode == 200) {
      List<TipoProducto> productos =
          TipoProducto.getTipoProductoListFromJson(response.body);
      return productos;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
