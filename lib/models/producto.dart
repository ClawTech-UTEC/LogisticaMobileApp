import 'dart:ffi';

import 'package:clawtech_logistica_app/models/tipo_producto.dart';

class Producto {
  Long id;

  TipoProducto tipoProducto;

  double cantidadDisponible;

  double cantidadReservada;

  Producto({
    required this.id,
    required this.tipoProducto,
    required this.cantidadDisponible,
    required this.cantidadReservada,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        tipoProducto: TipoProducto.fromJson(json["tipoProducto"]),
        cantidadDisponible: json["cantidadDisponible"].toDouble(),
        cantidadReservada: json["cantidadReservada"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipoProducto": tipoProducto.toJson(),
        "cantidadDisponible": cantidadDisponible,
        "cantidadReservada": cantidadReservada,
      };
}
