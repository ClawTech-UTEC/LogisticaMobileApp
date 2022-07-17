import 'dart:convert';
import 'dart:ffi';

import 'package:clawtech_logistica_app/enums/metodo_picking.dart';
import 'package:clawtech_logistica_app/models/categoria.dart';
import 'package:clawtech_logistica_app/models/subcategoria.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TipoProducto {
  int idTipoProd;
  int codigoDeBarras;
  String nombre;
  String descripcion;

  double neto;
  double precio;
  double precioDeVenta;
  Categoria categoria;
  SubCategoria subCat;
  MetodoPicking metodoPicking;
  String imageUrl;	

  TipoProducto({
    required this.idTipoProd,
    required this.codigoDeBarras,
    required this.nombre,
    required this.descripcion,
    required this.neto,
    required this.precio,
    required this.precioDeVenta,
    required this.categoria,
    required this.subCat,
    required this.metodoPicking,
    required this.imageUrl,
   
  });

  factory TipoProducto.fromJson(Map<String, dynamic> json) => TipoProducto(
        idTipoProd: json["idTipoProd"],
        codigoDeBarras: json["codigoDeBarras"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        neto: json["neto"].toDouble(),
        precio: json["precio"].toDouble(),
        precioDeVenta: json["precioDeVenta"].toDouble(),
        categoria: Categoria.fromJson(json["categoria"]),
        subCat: SubCategoria.fromJson(json["subCat"]),
        metodoPicking: MetodoPicking.values.firstWhere((x) => x.value == json['metodoPicking']),
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "idTipoProd": idTipoProd,
        "codigoDeBarras": codigoDeBarras,
        "nombre": nombre,
        "descripcion": descripcion,
        "neto": neto,
        "precio": precio,
        "precioDeVenta": precioDeVenta,
        "categoria": categoria.toJson(),
        "subCat": subCat.toJson(),
        "metodoPicking": metodoPicking.value,
        "imageUrl": imageUrl,
      };

  static List<TipoProducto> getTipoProductoListFromJson(String jsonObjects) {
    final parsed = json.decode(jsonObjects).cast<Map<String, dynamic>>();
    return parsed
        .map<TipoProducto>((json) => TipoProducto.fromJson(json))
        .toList();
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'TipoProducto{idTipoProd: $idTipoProd, codigoDeBarras: $codigoDeBarras, nombre: $nombre, descripcion: $descripcion, neto: $neto, precio: $precio, categoria: $categoria, subCat: $subCat}';
  }
}
