import 'dart:ffi';

import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Producto {
  int? id;

  TipoProducto tipoProducto;

  int cantidadDisponible;

  int cantidadReservada;

  Producto({
     this.id,
    required this.tipoProducto,
     this.cantidadDisponible = 0,
     this.cantidadReservada = 0,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        tipoProducto: TipoProducto.fromJson(json["tipoProducto"]),
        cantidadDisponible: json["cantidadDisponible"].toInt(),
        cantidadReservada: json["cantidadReservada"].toInt(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipoProducto": tipoProducto.toJson(),
        "cantidadDisponible": cantidadDisponible,
        "cantidadReservada": cantidadReservada,
      };
}
