import 'dart:convert';
import 'dart:ffi';

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
  Categoria categoria;
  SubCategoria subCat;

  TipoProducto({
    required this.idTipoProd,
    required this.codigoDeBarras,
    required this.nombre,
    required this.descripcion,

    required this.neto,
    required this.precio,
    required this.categoria,
    required this.subCat,
  });

  factory TipoProducto.fromJson(Map<String, dynamic> json) => TipoProducto(
        idTipoProd: json["idTipoProd"],
        codigoDeBarras: json["codigoDeBarras"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
     
        neto: json["neto"].toDouble(),
        precio: json["precio"].toDouble(),
        categoria: Categoria.fromJson(json["categoria"]),
        subCat: SubCategoria.fromJson(json["subCat"]) ,
      );

  Map<String, dynamic> toJson() => {
        "idTipoProd": idTipoProd,
        "codigoDeBarras": codigoDeBarras,
        "nombre": nombre,
        "descripcion": descripcion,
     
        "neto": neto,
        "precio": precio,
        "categoria": categoria.toJson(),
        "subCat": subCat.toJson(),
      };

  static List<TipoProducto> getTipoProductoListFromJson(String jsonObjects) {
    final parsed = json.decode(jsonObjects).cast<Map<String, dynamic>>();
    return parsed
        .map<TipoProducto>((json) => TipoProducto.fromJson(json))
        .toList();
  }

  
}
