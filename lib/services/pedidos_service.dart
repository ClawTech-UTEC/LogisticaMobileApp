import 'dart:io';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';

class PedidosService {
  static final PedidosService _instance = new PedidosService.internal();
  factory PedidosService() => _instance;
  PedidosService.internal();

  Future<List<Pedido>> getPedidos() async {
    final response = await http.get(Uri.parse(apiBaseUrl + '/pedidos'));
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
    print("--------BODY-----------------");
    print(response.body);
    print("--------STATUS---------------");

    print(response.statusCode);
    print("-------------------------");
    if (response.statusCode == 201) {
      return Pedido.fromJson(json.decode(response.body));
    } else {
      throw BadRequestException(
          "Error al crear el pedido, revisa los datos ingresados");
    }
  }

  Future<Pedido> prepararPedido(
      int idPedido, Map<String, String> productos, int idUsuaurio) async {
    final http.Response response = await http.put(
      Uri.parse(
          apiBaseUrl + '/pedidos/preparar/$idPedido/?idUsuario=$idUsuaurio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }

  Future<Pedido> controlarPedido(
      int idPedido, Map<String, String> productos, int idUsuaurio) async {
    final http.Response response = await http.put(
      Uri.parse(
          apiBaseUrl + '/pedidos/controlar/$idPedido/?idUsuario=$idUsuaurio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }

  Future<Pedido> despacharPedido(
      int idPedido, int idUsuaurio, int idDistribuidor) async {
    final http.Response response = await http.put(
      Uri.parse(apiBaseUrl +
          '/pedidos/despachar/$idPedido/?idUsuario=$idUsuaurio&idDistribuidor=$idDistribuidor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }

  Future<Pedido> entregarPedido(int idPedido, int idUsuaurio) async {
    final http.Response response = await http.put(
      Uri.parse(
          apiBaseUrl + '/pedidos/entregar/$idPedido/?idUsuario=$idUsuaurio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }

  Future<Pedido> devolverPedido(int idPedido, int idUsuaurio) async {
    final http.Response response = await http.put(
      Uri.parse(
          apiBaseUrl + '/pedidos/devolver/$idPedido/?idUsuario=$idUsuaurio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }

    Future<Pedido> cancelarPedido(int idPedido, int idUsuaurio) async {
    final http.Response response = await http.post(
      Uri.parse(
          apiBaseUrl + '/pedidos/cancelar/$idPedido/?idUsuario=$idUsuaurio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> descargarPdfPedido(int idPedido) async {
    // Directory tempDir = await getTemporaryDirectory();

    Dio dio = Dio();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory x =
        await Directory(appDocDir.path + '/' + 'dir').create(recursive: true)
// The created directory is returned as a Future.
            .then((Directory directory) {
      return directory;
    });
    // final http.Response response = await http.get(
    //   Uri.parse(apiBaseUrl + '/etiquetas/pedido/$idPedido'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    // );
    await dio.download(apiBaseUrl + '/etiquetas/pedido/$idPedido',
        x.path + "./example/flutter.pdf",
        options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}));

        File file = File(x.path + "./pedido/$idPedido.pdf");
        print(file.path);
        Share.shareFiles([x.path + "./pedido/$idPedido.pdf"], text: 'Great picture');

  }
}
