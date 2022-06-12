
import 'package:clawtech_logistica_app/enums/tipo_estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Recepcion {
  int? idRecepcion;
  DateTime? fechaRecepcion;
  Provedor? provedor;
  List<RecepcionProducto> productos = [];

  List<EstadoRecepcion> estadoRecepcion = [];
  int? usuarioCreadorId;
  Recepcion({
    this.idRecepcion,
    this.fechaRecepcion,
    this.provedor,
    this.productos = const [],
    this.estadoRecepcion = const [],
  });

  factory Recepcion.fromJson(Map<String, dynamic> json) => Recepcion(
        idRecepcion: json["idRecepcion"],
        fechaRecepcion: DateTime.tryParse(json["fechaRecepcion"]),
        provedor: Provedor.fromJson(json["provedor"]),
        productos: List<RecepcionProducto>.from(
            json["productos"].map((x) => RecepcionProducto.fromJson(x))),
        estadoRecepcion: List<EstadoRecepcion>.from(
            json["estadoRecepcion"].map((x) => EstadoRecepcion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idRecepcion": idRecepcion,
        "fechaRecepcion": fechaRecepcion?.toIso8601String(),
        "provedor": provedor,
        "productos":
            List<dynamic>.from(productos.map((RecepcionProducto x) => x)),
        "estadoRecepcion":
            List<dynamic>.from(estadoRecepcion.map((EstadoRecepcion x) => x)),
      };

  double get total {
    double total = 0;
    productos.forEach((element) {
      total += element.producto.precio * element.cantidad;
    });
    return total;
  }

  double get totalProductos {
    double total = 0;
    productos.forEach((element) {
      total += element.cantidad;
    });
    return total;
  }

  Usuario? get usuarioCreador {
    return estadoRecepcion.first.usuario;
  }

  String get getFecha {
    DateFormat dateFormat = DateFormat("dd-MM-yy");

    return fechaRecepcion != null
        ? dateFormat.format(fechaRecepcion!)
        : "No se registro fecha";
  }

  String get getHora {
    DateFormat dateFormat = DateFormat("HH:mm");

    return fechaRecepcion != null
        ? dateFormat.format(fechaRecepcion!)
        : "No se registro hora";
  }

  TipoEstadoRecepcion get getEstadoActual {
    return estadoRecepcion.last.tipoEstado;
  }

  @override
  String toString() {
    return 'Recepcion{idRecepcion: $idRecepcion, fechaRecepcion: $fechaRecepcion, provedor: $provedor, productos: $productos, estadoRecepcion: $estadoRecepcion}';
  }
}
