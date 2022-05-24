import 'dart:ffi';

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
}