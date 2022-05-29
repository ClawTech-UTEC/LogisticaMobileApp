import 'dart:ffi';

import 'package:clawtech_logistica_app/mockdata.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RecepcionProducto {
  int? idRecepcionProducto;

  @JsonKey(ignore: true, includeIfNull: false)
  Recepcion? recepcion;

  TipoProducto producto;
  double cantidad;

  RecepcionProducto({
    this.idRecepcionProducto,
    required this.recepcion,
    required this.producto,
    required this.cantidad,
  });

  factory RecepcionProducto.fromJson(Map<String, dynamic> json) =>
      RecepcionProducto(
        idRecepcionProducto: json["idRecepcionProducto"],
        recepcion:
            json["recepcion"] != null ? Recepcion.fromJson(json["recepcion"]) : null,
        producto: TipoProducto.fromJson(json["producto"]),
        cantidad: json["cantidad"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idRecepcionProducto": idRecepcionProducto,
        "recepcion": null,
        "producto": producto,
        "cantidad": cantidad,
      };
}
