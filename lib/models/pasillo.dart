import 'package:clawtech_logistica_app/models/espacio.dart';
import 'package:flutter/material.dart';

class Pasillo {
  int idPasillo;
  String nomPasillo;

  List<Espacio> espacio;

  Pasillo({required this.idPasillo, required this.nomPasillo,required this.espacio});

  factory Pasillo.fromJson(Map<String, dynamic> json) => new Pasillo(
        idPasillo: json["idPasillo"],
        nomPasillo: json["nomPasillo"],
        espacio: List<Espacio>.from(
            json["espacio"].map((x) => Espacio.fromJson(x))),
            );



  Map<String, dynamic> toJson() => {
        "idPasillo": idPasillo,
        "nomPasillo": nomPasillo,
        "espacio":new List<dynamic>.from(espacio.map((x) => x.toJson())),
      };
}
