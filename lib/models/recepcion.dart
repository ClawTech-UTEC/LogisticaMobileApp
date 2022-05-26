 import 'dart:ffi';

import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Recepcion {

    
     int? idRecepcion;
     DateTime? fechaRecepcion;
     Provedor? provedor;
     List<RecepcionProducto> productos = [];

    
     List<EstadoRecepcion> estadoRecepcion = [];

     
      Recepcion({
           this.idRecepcion,
           this.fechaRecepcion,
           this.provedor,
           this.productos = const [],
           this.estadoRecepcion = const [],
        });
  
        factory Recepcion.fromJson(Map<String, dynamic> json) => Recepcion(
          idRecepcion: json["idRecepcion"],
          fechaRecepcion: json["fechaRecepcion"],
          provedor: Provedor.fromJson(json["provedor"]),
          productos: List<RecepcionProducto>.from(json["productos"].map((x) => RecepcionProducto.fromJson(x))),
          estadoRecepcion: List<EstadoRecepcion>.from(json["estadoRecepcion"].map((x) => EstadoRecepcion.fromJson(x))),
        );
  
        Map<String, dynamic> toJson() => {
          // "idRecepcion": idRecepcion,
          "fechaRecepcion": fechaRecepcion.toString(),
          "provedor": provedor?.toJson(),
          "productos": List<dynamic>.from(productos.map((RecepcionProducto x) => x.toJson())).toString(),
          "estadoRecepcion": List<dynamic>.from(estadoRecepcion.map((x) => x.toJson()))
                .toString(),
        };


}