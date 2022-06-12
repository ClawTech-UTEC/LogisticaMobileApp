class Distribuidor {
  int? idDistribu;

  String vehiculo;

  String matricula;

  String chofer;

  Distribuidor({
    this.idDistribu,
    required this.vehiculo,
    required this.matricula,
    required this.chofer,
  });

  factory Distribuidor.fromJson(Map<String, dynamic> json) => Distribuidor(
        idDistribu: json["idDistribu"],
        vehiculo: json["vehiculo"],
        matricula: json["matricula"],
        chofer: json["chofer"],
      );

  Map<String, dynamic> toJson() => {
        "idDistribu": idDistribu,
        "vehiculo": vehiculo,
        "matricula": matricula,
        "chofer": chofer,
      };

      @override
  String toString() {
    // TODO: implement toString
    return 'Distribuidor{idDistribu: $idDistribu, vehiculo: $vehiculo, matricula: $matricula, chofer: $chofer}';
  }
}
