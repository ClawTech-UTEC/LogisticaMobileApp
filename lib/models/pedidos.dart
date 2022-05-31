import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/estado_pedido.dart';
import 'package:clawtech_logistica_app/models/producto.dart';

class Pedido {
  int? idPedido;
  Cliente cliente;
  String direccion;
  double total;
  double duracionEstimada;
  double? duracionFinal;
  Distribuidor distribuidor;
  EstadoPedido estadoPedido;
  List<Producto> productos;

  Pedido({
    this.idPedido,
    required this.cliente,
    required this.direccion,
    required this.total,
    required this.duracionEstimada,
    required this.duracionFinal,
    required this.distribuidor,
    required this.estadoPedido,
    required this.productos,
  });


  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        idPedido: json["idPedido"],
        cliente: Cliente.fromJson(json["cliente"]),
        direccion: json["direccion"],
        total: json["total"].toDouble(),
        duracionEstimada: json["duracionEstimada"].toDouble(),
        duracionFinal: json["duracionFinal"] == null ? null : json["duracionFinal"].toDouble(),
        distribuidor: Distribuidor.fromJson(json["distribuidor"]),
        estadoPedido: EstadoPedido.fromJson(json["estadoPedido"]),
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idPedido": idPedido,
        "cliente": cliente.toJson(),
        "direccion": direccion,
        "total": total,
        "duracionEstimada": duracionEstimada,
        "duracionFinal": duracionFinal == null ? null : duracionFinal,
        "distribuidor": distribuidor.toJson(),
        "estadoPedido": estadoPedido.toJson(),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
      };
  
}
