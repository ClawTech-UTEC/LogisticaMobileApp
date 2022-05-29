import 'dart:ffi';

import 'package:clawtech_logistica_app/enums/tipo_estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class EstadoRecepcion {
  int? idEstadoRecepcion;

  @JsonKey(ignore: true, includeIfNull: false)
  Recepcion? recepcion;

  Usuario? usuario;

  TipoEstadoRecepcion tipoEstado;

  DateTime? fecha;
  EstadoRecepcion? estadoAnterior;

  EstadoRecepcion({
    this.idEstadoRecepcion,
    this.recepcion,
    this.usuario,
    this.tipoEstado = TipoEstadoRecepcion.PENDIENTE,
    required this.fecha,
    this.estadoAnterior,
  });

  factory EstadoRecepcion.fromJson(Map<String, dynamic> json) =>
      EstadoRecepcion(
        idEstadoRecepcion: json["idEstadoRecepcion"],
        recepcion: null,
        usuario: null,
        tipoEstado: TipoEstadoRecepcion.PENDIENTE,
        fecha: null,
        estadoAnterior: null,
      );

  Map<String, dynamic> toJson() => {
        "idEstadoRecepcion": idEstadoRecepcion,
        "recepcion": null,
        "usuario": usuario,
        "tipoEstado": tipoEstado.name,
        "fecha": fecha?.toIso8601String(),
        "estadoAnterior": null,
      };


      
}
