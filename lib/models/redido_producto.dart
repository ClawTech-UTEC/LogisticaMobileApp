import 'dart:ffi';

import 'package:clawtech_logistica_app/mockdata.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PedidoProducto {
  int? idPedidoProducto;

  @JsonKey(ignore: true, includeIfNull: false)
  Pedido? pedido;

  TipoProducto producto;
  double cantidad;

  PedidoProducto({
    this.idPedidoProducto,
    required this.pedido,
    required this.producto,
    required this.cantidad,
  });

  factory PedidoProducto.fromJson(Map<String, dynamic> json) => PedidoProducto(
        idPedidoProducto: json["idPedidoProducto"],
        pedido: json["Pedido"] != null ? Pedido.fromJson(json["Pedido"]) : null,
        producto: TipoProducto.fromJson(json["producto"]),
        cantidad: json["cantidad"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idPedidoProducto": idPedidoProducto,
        "pedido": null,
        "producto": producto,
        "cantidad": cantidad,
      };
}
