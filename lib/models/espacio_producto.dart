import 'package:clawtech_logistica_app/models/tipo_producto.dart';

class EspacioProducto {
  int idEspacio;
  TipoProducto tipoProducto;
  int cantidad;

  EspacioProducto(
      {required this.idEspacio,
      required this.tipoProducto,
      required this.cantidad});

  factory EspacioProducto.fromJson(Map<String, dynamic> json) =>
      new EspacioProducto(
        idEspacio: json["idEspacio"],
        tipoProducto: TipoProducto.fromJson(json["id_tipo_producto"]),
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "idEspacio": idEspacio,
        "id_tipo_producto": tipoProducto.toJson(),
        "cantidad": cantidad,
      };
}
