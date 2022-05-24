import 'dart:ffi';

import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';

class RecepcionProducto {
  int? idRecepcionProducto;

  int? recepcion;

  TipoProducto producto;
  double cantidad;

  RecepcionProducto({
    this.idRecepcionProducto,
     this.recepcion,
    required this.producto,
    required this.cantidad,
  });

  factory RecepcionProducto.fromJson(Map<String, dynamic> json) =>
      RecepcionProducto(
        idRecepcionProducto: json["idRecepcionProducto"],
        recepcion: json["recepcion"],
        producto: TipoProducto.fromJson(json["producto"]),
        cantidad: json["cantidad"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idRecepcionProducto": idRecepcionProducto,
        "recepcion": recepcion,
        "producto": producto.toJson(),
        "cantidad": cantidad,
      };

      
}
