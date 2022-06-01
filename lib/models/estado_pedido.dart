import 'package:clawtech_logistica_app/enums/tipo_estado_pedido.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';

class EstadoPedido {
  int? idEstadoPedido;

  Pedido? pedidos;

  DateTime fechaPedido;

  Usuario usuarios;

  EstadoPedido? estadosPedidosAnteriores;

  TipoEstadoPedido tipoEstadoPedido;

  EstadoPedido({
    this.idEstadoPedido,
     this.pedidos,
    required this.fechaPedido,
    required this.usuarios,
    this.estadosPedidosAnteriores,
    required this.tipoEstadoPedido,
  });

  factory EstadoPedido.fromJson(Map<String, dynamic> json) => EstadoPedido(
        idEstadoPedido: json["idEstadoPedido"],
        pedidos:
            Pedido.fromJson(json["pedidos"] == null ? null : json["pedidos"]),
        fechaPedido: DateTime.parse(json["fechaPedido"]),
        usuarios: Usuario.fromJson(json["usuarios"]),
        estadosPedidosAnteriores: json["estadosPedidosAnteriores"] == null
            ? null
            : EstadoPedido.fromJson(json["estadosPedidosAnteriores"]),
        tipoEstadoPedido: TipoEstadoPedido.values[json["tipoEstadoPedido"]],
      );

  Map<String, dynamic> toJson() => {
        "idEstadoPedido": idEstadoPedido,
        "pedidos":pedidos,
        "fechaPedido":
            "${fechaPedido.year.toString().padLeft(4, '0')}-${fechaPedido.month.toString().padLeft(2, '0')}-${fechaPedido.day.toString().padLeft(2, '0')}",
        "usuarios": usuarios.toJson(),
        "estadosPedidosAnteriores": estadosPedidosAnteriores == null
            ? null
            : estadosPedidosAnteriores?.toJson(),
        "tipoEstadoPedido": tipoEstadoPedido.name,
      };
}
