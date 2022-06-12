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

  EstadoRecepcion({
    this.idEstadoRecepcion,
    this.recepcion,
    this.usuario,
    this.tipoEstado = TipoEstadoRecepcion.PENDIENTE,
    required this.fecha,
  });

  factory EstadoRecepcion.fromJson(Map<String, dynamic> json) =>
      EstadoRecepcion(
        idEstadoRecepcion: json["idEstadoRecepcion"],
        recepcion: json["recepcion"] == null
            ? null
            : Recepcion.fromJson(json["recepcion"] as Map<String, dynamic>),
        usuario: json["usuario"] == null
            ? null
            : Usuario.fromJson(json["usuario"] as Map<String, dynamic>),
        tipoEstado: TipoEstadoRecepcion.values.byName(json["tipoEstado"]),
        fecha: DateTime.parse(json["fecha"] as String),
        );

  Map<String, dynamic> toJson() => {
        "idEstadoRecepcion": idEstadoRecepcion,
        "recepcion": null,
        "usuario": usuario,
        "tipoEstado": tipoEstado.name,
        "fecha": fecha?.toIso8601String(),
      };


      @override
  String toString() {
    // TODO: implement toString
    return 'EstadoRecepcion{idEstadoRecepcion: $idEstadoRecepcion, recepcion: $recepcion, usuario: $usuario, tipoEstado: $tipoEstado, fecha: $fecha}';
  }
}
