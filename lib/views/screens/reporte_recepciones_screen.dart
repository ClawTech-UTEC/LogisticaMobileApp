import 'package:charts_flutter/flutter.dart';
import 'package:clawtech_logistica_app/models/reporte_data.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReporteRecepcionesScreen extends StatefulWidget {
  ReporteRecepcionesScreen({Key? key}) : super(key: key);

  @override
  State<ReporteRecepcionesScreen> createState() =>
      _ReporteRecepcionesScreenState();
}

class _ReporteRecepcionesScreenState extends State<ReporteRecepcionesScreen> {
  RecepcionService _recepcionesService = new RecepcionService();
  late Future<List<ReporteData>> reporteRecepciones;
  int year = 2022;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reporteRecepciones = _recepcionesService.getReporteRecepcionesAnual(year);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: reporteRecepciones,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return LoadingPage();
          }

          List<ReporteData> reporte = snapshot.data;
          return ScaffoldGeneralBackground(
              title: "Reporte Recepciones",
              child: CardGeneral(
                  child: Column(children: <Widget>[
                DropdownButton<String>(
                  onChanged: (String? newValue) async {
                    setState(() {
                      year = int.parse(newValue!);
                      reporteRecepciones =
                          _recepcionesService.getReporteRecepcionesAnual(year);
                    });
                  },
                  value: year.toString(),
                  items: [
                    DropdownMenuItem<String>(
                      value: "2020",
                      child: Text("2020"),
                    ),
                    DropdownMenuItem<String>(
                      value: "2021",
                      child: Text("2021"),
                    ),
                    DropdownMenuItem<String>(
                      value: "2022",
                      child: Text("2022"),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height - 250,
                  child: LineChart(
                    [
                      charts.Series<ReporteData, num>(
                        id: 'Recepciones',
                        data: reporte,
                        measureFn: (ReporteData x, _) => x.cantidad,
                        domainFn: (ReporteData x, _) => x.mes,
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                      )
                    ],
                    defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, stacked: true),
                    behaviors: [
                      new charts.ChartTitle('Mes',
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                      new charts.ChartTitle(
                          'Productos solicitados en recepciones',
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleStyleSpec: charts.TextStyleSpec(fontSize: 11),
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea)
                    ],
                  ),
                ),
              ])));
        });
  }
}
