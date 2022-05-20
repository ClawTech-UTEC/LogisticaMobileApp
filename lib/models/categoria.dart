import 'dart:ffi';

class Categoria {
  int idCat;
  String nombre;


  Categoria({
    required this.idCat,
    required this.nombre,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        idCat: json["idCat"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idCat": idCat,
        "nombre": nombre,
      };
}
