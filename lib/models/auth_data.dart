class AuthJwtData {
  String email;
  String jwt;
  int idUsuario;


  AuthJwtData(
      {required this.email, required this.jwt, required this.idUsuario});

  factory AuthJwtData.fromJson(Map<String, dynamic> json) => AuthJwtData(
        email: json["email"],
        jwt: json["jwt"],
        idUsuario: json["idUsuario"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['jwt'] = this.jwt;
    data['idUsuario'] = this.idUsuario;
    return data;
  }
}
