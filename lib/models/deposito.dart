import 'package:clawtech_logistica_app/models/empresa.dart';
import 'package:clawtech_logistica_app/models/pasillo.dart';
import 'package:flutter/material.dart';
class Deposito {

   int idDeposito;
	 String nomDeposito;
	 String direccion;
	 Empresa empresa;
	 List<Pasillo>? pasillos;


  Deposito({
    required this.idDeposito,
    required this.nomDeposito,
    required this.direccion,
    required this.empresa,
    required this.pasillos,
  });

  factory Deposito.fromJson(Map<String, dynamic> json) => new Deposito(
    idDeposito: json["idDeposito"],
    nomDeposito: json["nomDeposito"],
    direccion: json["direccion"],
    empresa: Empresa.fromJson(json["empresa"]),
    pasillos: json["pasillos"] != null
        ? new List<Pasillo>.from(
            json["pasillos"].map((x) => Pasillo.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "idDeposito": idDeposito,
    "nomDeposito": nomDeposito,
    "direccion": direccion,
    "empresa": empresa.toJson(),
    "pasillos": pasillos != null ? new List<dynamic>.from(pasillos!.map((x) => x.toJson())) : null,
  };
  
}