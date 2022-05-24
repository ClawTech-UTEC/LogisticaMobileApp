 import 'dart:ffi';

class TipoEstadoRecepcion {
     int idEstadoRecepcion;
     String nombre;

      TipoEstadoRecepcion({
        required this.idEstadoRecepcion,
        required this.nombre,
      });

      factory TipoEstadoRecepcion.fromJson(Map<String, dynamic> json) => TipoEstadoRecepcion(
        idEstadoRecepcion: json["idEstadoRecepcion"],
        nombre: json["nombre"],
      );

      Map<String, dynamic> toJson() => {
        "idEstadoRecepcion": idEstadoRecepcion,
        "nombre": nombre,
      };
}