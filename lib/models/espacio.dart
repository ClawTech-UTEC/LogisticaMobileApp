import 'package:clawtech_logistica_app/models/espacio_producto.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:flutter/material.dart';

class Espacio {
  int idEsp;
  String nomEspacio;
  List<EspacioProducto>? productos;

  Espacio({required this.idEsp, required this.nomEspacio, productos});

  factory Espacio.fromJson(Map<String, dynamic> json) => new Espacio(
      idEsp: json["idEsp"],
      nomEspacio: json["nomEspacio"],
      productos: json["productos"] != null
          ? new List<Producto>.from(
              json["productos"].map((x) => EspacioProducto.fromJson(x)))
          : null);

  Map<String, dynamic> toJson() => {
        "idEsp": idEsp,
        "nomEspacio": nomEspacio,
        "productos": productos != null
            ? new List<dynamic>.from(productos!.map((x) => x.toJson()))
            : null,
      };
}
