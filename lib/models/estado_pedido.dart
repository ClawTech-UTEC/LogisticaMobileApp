import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';

class EstadoPedido {
  int? idEstadoPedido;

  List<Pedido> pedidos;

  DateTime fechaPedido;

  Usuario usuarios;

  EstadoPedido? estadosPedidosAnteriores;

  EstadoPedido({
    this.idEstadoPedido,
    required this.pedidos,
    required this.fechaPedido,
    required this.usuarios,
    this.estadosPedidosAnteriores,
  });

  factory EstadoPedido.fromJson(Map<String, dynamic> json) => EstadoPedido(
        idEstadoPedido: json["idEstadoPedido"],
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromJson(x))),
        fechaPedido: DateTime.parse(json["fechaPedido"]),
        usuarios: Usuario.fromJson(json["usuarios"]),
        estadosPedidosAnteriores: json["estadosPedidosAnteriores"] == null
            ? null
            : EstadoPedido.fromJson(json["estadosPedidosAnteriores"]),
      );

  Map<String, dynamic> toJson() => {
        "idEstadoPedido": idEstadoPedido,
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
        "fechaPedido":
            "${fechaPedido.year.toString().padLeft(4, '0')}-${fechaPedido.month.toString().padLeft(2, '0')}-${fechaPedido.day.toString().padLeft(2, '0')}",
        "usuarios": usuarios.toJson(),
        "estadosPedidosAnteriores": estadosPedidosAnteriores == null
            ? null
            : estadosPedidosAnteriores?.toJson(),
      };
}
