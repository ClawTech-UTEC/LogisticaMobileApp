class ReporteData {
  int year;
  int mes;
  String? nombre;
  String? idProducto;
  num cantidad;

  ReporteData(
      {required this.year,
      required this.mes,
      this.idProducto,
      this.nombre,
      required this.cantidad});

  factory ReporteData.fromJson(Map<String, dynamic> json) => ReporteData(
        year: json["year"],
        mes: json["mes"],
        idProducto: json["idProducto"],
        nombre: json["nombre"],
        cantidad: json["cantidad"],
      );
}
