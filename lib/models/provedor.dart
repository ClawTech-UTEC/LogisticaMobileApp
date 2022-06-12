import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Provedor {
   int idProv;
	
	 String nombreProv;
	
	 String contacto;
	
	 String email;

  
  Provedor({
    required this.idProv,
    required this.nombreProv,
    required this.contacto,
    required this.email,
  });

  factory Provedor.fromJson(Map<String, dynamic> json) => Provedor(
    idProv: json["idProv"],
    nombreProv: json["nombreProv"],
    contacto: json["contacto"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "idProv": idProv,
    "nombreProv": nombreProv,
    "contacto": contacto,
    "email": email,
  };

  @override
  String toString() {
    // TODO: implement toString
    return 'Provedor{idProv: $idProv, nombreProv: $nombreProv, contacto: $contacto, email: $email}';
  }
}