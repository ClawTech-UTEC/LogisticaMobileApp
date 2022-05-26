 import 'dart:ffi';

import 'package:clawtech_logistica_app/enums/tipo_estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable()
class EstadoRecepcion {
    
     int idEstadoRecepcion;
    
      @JsonKey(ignore: true, includeIfNull: false)

     Recepcion? recepcion;

    
     Usuario? usuario;

     TipoEstadoRecepcion tipoEstado;


     DateTime fecha;
     EstadoRecepcion? estadoAnterior;

    

      EstadoRecepcion({
          required this.idEstadoRecepcion,
           this.recepcion,
           this.usuario,
           this.tipoEstado = TipoEstadoRecepcion.PENDIENTE,
          required this.fecha,
           this.estadoAnterior,
        });

        
        factory EstadoRecepcion.fromJson(Map<String, dynamic> json) => EstadoRecepcion(
          idEstadoRecepcion: json["idEstadoRecepcion"],
          recepcion: Recepcion.fromJson(json["recepcion"]),
          usuario: Usuario.fromJson(json["usuario"]),
          tipoEstado: json["tipoEstado"],
          fecha: DateTime.parse(json["fecha"]),
          estadoAnterior: EstadoRecepcion.fromJson(json["estadoAnterior"]),
        );

        Map<String, dynamic> toJson() => {
          "idEstadoRecepcion": idEstadoRecepcion,
          "recepcion": recepcion!.toJson(),
          "usuario": usuario!.toJson(),
          "tipoEstado": tipoEstado,
          "fecha": fecha.toIso8601String(),
          "estadoAnterior": estadoAnterior!.toJson(),
        };

        

}