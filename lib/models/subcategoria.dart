import 'dart:ffi';

class SubCategoria {
  int idSubCat;
  String nombre;

  SubCategoria({
    required this.idSubCat,
    required this.nombre,
  });

  factory SubCategoria.fromJson(Map<String, dynamic> json) => SubCategoria(
        idSubCat: json["idSubCat"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idSubCat": idSubCat,
        "nombre": nombre,
      };
}
