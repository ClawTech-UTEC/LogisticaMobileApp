import 'package:clawtech_logistica_app/enums/tipo_estado_pedido.dart';
import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/estado_pedido.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:intl/intl.dart';

class Pedido {
  int? idPedido;
  Cliente cliente;
  String direccion;
  double total;
  DateTime? duracionEstimada;
  DateTime? duracionFinal;
  Distribuidor? distribuidor;
  List<EstadoPedido> estadoPedido;
  List<PedidoProducto> productos;
  DateTime fechaPedido;

  Pedido({
    this.idPedido,
    required this.cliente,
    required this.direccion,
    required this.total,
    this.duracionEstimada,
    this.duracionFinal,
    this.distribuidor,
    required this.estadoPedido,
    required this.productos,
    required this.fechaPedido,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        idPedido: json["idPedido"],
        cliente: Cliente.fromJson(json["cliente"]),
        direccion: json["direccion"],
        total: json["total"].toDouble(),
        duracionEstimada: json["duracionEstimada"] == null
            ? null
            : DateTime.parse(json["duracionEstimada"]),
        duracionFinal: json["duracionFinal"] == null
            ? null
            : DateTime.parse(json["duracionFinal"]),
        distribuidor: json["distribuidor"] != null
            ? Distribuidor.fromJson(json["distribuidor"])
            : null,
        estadoPedido: List<EstadoPedido>.from(
            json["estadoPedido"].map((x) => EstadoPedido.fromJson(x))),
        productos: List<PedidoProducto>.from(
            json["productos"].map((x) => PedidoProducto.fromJson(x))),
        fechaPedido: DateTime.parse(json["fechaPedido"]),
      );

  Map<String, dynamic> toJson() => {
        "idPedido": idPedido,
        "cliente": cliente.toJson(),
        "direccion": direccion,
        "total": total,
        "duracionEstimada": duracionEstimada == null ? null : duracionEstimada!.toIso8601String(),
        "duracionFinal": duracionFinal == null ? null : duracionFinal!.toIso8601String(),
        "distribuidor": distribuidor?.toJson(),
        "estadoPedido": List<dynamic>.from(estadoPedido.map((x) => x.toJson())),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "fechaPedido": fechaPedido.toIso8601String(),
      };

  Usuario? get usuarioCreador {
    return estadoPedido.first.usuario;
  }

  String get getFecha {
    DateFormat dateFormat = DateFormat("dd-MM-yy");

    return dateFormat.format(fechaPedido);
  }

  String get getHora {
    DateFormat dateFormat = DateFormat("HH:mm");

    return dateFormat.format(fechaPedido);
  }

  TipoEstadoPedido get getEstadoActual {
    return estadoPedido.last.tipoEstadoPedido;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Pedido{idPedido: $idPedido, cliente: $cliente, direccion: $direccion, total: $total, duracionEstimada: $duracionEstimada, duracionFinal: $duracionFinal, distribuidor: $distribuidor, estadoPedido: $estadoPedido, productos: $productos, fechaPedido: $fechaPedido}';
  }
}
