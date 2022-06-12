import 'dart:ffi';

import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PedidoProducto {
  int? idPedidoProducto;

  

  TipoProducto producto;
  double cantidad;

  PedidoProducto({
    this.idPedidoProducto,
    required this.producto,
    required this.cantidad,
  });

  factory PedidoProducto.fromJson(Map<String, dynamic> json) => PedidoProducto(
        idPedidoProducto: json["idPedidoProducto"],
        producto: TipoProducto.fromJson(json["producto"]),
        cantidad:  json["cantidad"]  ,
      );

  Map<String, dynamic> toJson() => {
        "idPedidoProducto": idPedidoProducto,
        "producto": producto,
        "cantidad": cantidad,
      };


      @override
  String toString() {
    // TODO: implement toString
    return 'PedidoProducto{idPedidoProducto: $idPedidoProducto, producto: $producto, cantidad: $cantidad}';
  }
}
