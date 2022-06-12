class Cliente {
  int? idCliente;
  String nombre;
  String razonSocial;
  String documento;
  String direccion;
  String ciudad;
  String email;
  String telefono;

  Cliente(
      {this.idCliente,
      this.nombre = '',
      this.razonSocial = '',
      this.documento = '',
      this.direccion = '',
      this.ciudad = '',
      this.email = '',
      this.telefono = ''});


  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        idCliente: json["idCliente"],
        nombre: json["nombre"],
        razonSocial: json["razonSocial"],
        documento: json["documento"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
        email: json["email"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "nombre": nombre,
        "razonSocial": razonSocial,
        "documento": documento,
        "direccion": direccion,
        "ciudad": ciudad,
        "email": email,
        "telefono": telefono,
      };

@override
  String toString() {
    // TODO: implement toString
    return 'Cliente{idCliente: $idCliente, nombre: $nombre, razonSocial: $razonSocial, documento: $documento, direccion: $direccion, ciudad: $ciudad, email: $email, telefono: $telefono}';
  }
      
}
