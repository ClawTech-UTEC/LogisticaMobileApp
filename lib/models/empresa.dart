import 'package:flutter/material.dart';

class Empresa {
  int idEmpresa;
	 String nomEmpresa;
	 String contacto;
	 int documento;
	 String email;

  Empresa({
   required this.idEmpresa,
   required this.nomEmpresa,
   required this.contacto,
   required this.documento,
   required this.email,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) => new Empresa(
    idEmpresa: json["idEmpresa"],
    nomEmpresa: json["nomEmpresa"],
    contacto: json["contacto"],
    documento: json["documento"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "idEmpresa": idEmpresa,
    "nomEmpresa": nomEmpresa,
    "contacto": contacto,
    "documento": documento,
    "email": email,
  };
}

	
