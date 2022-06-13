import 'package:clawtech_logistica_app/enums/tipo_estado_pedido.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';

class EstadoPedido {
  int? idEstadoPedido;


  DateTime? fecha;

  Usuario usuario;


  TipoEstadoPedido tipoEstadoPedido;

  EstadoPedido({
    this.idEstadoPedido,
     this.fecha,
    required this.usuario,
    required this.tipoEstadoPedido,
  });

  factory EstadoPedido.fromJson(Map<String, dynamic> json) => EstadoPedido(
        idEstadoPedido: json["idEstadoPedido"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        usuario: Usuario.fromJson(json["usuario"]),
        tipoEstadoPedido: TipoEstadoPedido.values.byName(json["tipoEstadoPedido"]),
      );

  Map<String, dynamic> toJson() => {
        "idEstadoPedido": idEstadoPedido,
        "fecha":  fecha == null ? null : fecha!.toIso8601String(),
        "usuario": usuario.toJson(),
        "tipoEstadoPedido": tipoEstadoPedido.name,
      };

      @override
      String toString() {
        return 'EstadoPedido{idEstadoPedido: $idEstadoPedido, fecha: $fecha, usuario: $usuario, tipoEstadoPedido: $tipoEstadoPedido}';
      }
}
