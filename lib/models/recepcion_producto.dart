 import 'dart:ffi';

import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';

class RecepcionProducto {
    
     Long idRecepcionProducto;

    
     Recepcion recepcion;
    
     Producto producto;
    Double cantidad;

    RecepcionProducto({
       required this.idRecepcionProducto,
      required  this.recepcion,
      required  this.producto,
      required  this.cantidad,
    });

    factory RecepcionProducto.fromJson(Map<String, dynamic> json) => RecepcionProducto(
      idRecepcionProducto: json["idRecepcionProducto"],
      recepcion: Recepcion.fromJson(json["recepcion"]),
      producto: Producto.fromJson(json["producto"]),
      cantidad: json["cantidad"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
      "idRecepcionProducto": idRecepcionProducto,
      "recepcion": recepcion.toJson(),
      "producto": producto.toJson(),
      "cantidad": cantidad,
    };
}