 import 'dart:ffi';

import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';

class Recepcion {

    
     Long idRecepcion;
     String fechaRecepcion;
     Provedor provedor;
     List<RecepcionProducto> productos = [];

    
     List<EstadoRecepcion> estadoRecepcion = [];

     
      Recepcion({
          required this.idRecepcion,
          required this.fechaRecepcion,
          required this.provedor,
          required this.productos,
          required this.estadoRecepcion,
        });
  
        factory Recepcion.fromJson(Map<String, dynamic> json) => Recepcion(
          idRecepcion: json["idRecepcion"],
          fechaRecepcion: json["fechaRecepcion"],
          provedor: Provedor.fromJson(json["provedor"]),
          productos: List<RecepcionProducto>.from(json["productos"].map((x) => RecepcionProducto.fromJson(x))),
          estadoRecepcion: List<EstadoRecepcion>.from(json["estadoRecepcion"].map((x) => EstadoRecepcion.fromJson(x))),
        );
  
        Map<String, dynamic> toJson() => {
          "idRecepcion": idRecepcion,
          "fechaRecepcion": fechaRecepcion,
          "provedor": provedor.toJson(),
          "productos": List<RecepcionProducto>.from(productos.map((x) => x.toJson())),
          "estadoRecepcion": List<dynamic>.from(estadoRecepcion.map((x) => x.toJson())),
        };


}