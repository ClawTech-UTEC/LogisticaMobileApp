import 'package:charts_flutter/flutter.dart';
import 'package:clawtech_logistica_app/models/reporte_data.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportePedidosScreen extends StatefulWidget {
  ReportePedidosScreen({Key? key}) : super(key: key);

  @override
  State<ReportePedidosScreen> createState() => _ReportePedidosScreenState();
}

class _ReportePedidosScreenState extends State<ReportePedidosScreen> {
  PedidosService _pedidosService = new PedidosService();
  late Future<List<ReporteData>> reportePedidos;
  int year = 2022;
  TipoProducto? _selectedTipoProducto;
  List<TipoProducto> _tiposProductos = [];
  ProductoService _productoService = new ProductoService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportePedidos = _pedidosService.getReportePedidoAnual(year);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: reportePedidos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return LoadingPage();
          }

          List<ReporteData> reporte = snapshot.data;
          return ScaffoldGeneralBackground(
              title: "Reporte Pedidos",
              child: CardGeneral(
                  child: Column(children: <Widget>[
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: DropdownButton<String>(
                          onChanged: (String? newValue) async {
                            setState(() {
                              _selectedTipoProducto = null;
                              year = int.parse(newValue!);
                              reportePedidos =
                                  _pedidosService.getReportePedidoAnual(year);
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
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownSearch<TipoProducto>(
                          selectedItem: _selectedTipoProducto,
                          popupProps: PopupProps.menu(showSearchBox: true),
                          validator: (value) => value == null
                              ? 'Debe seleccionar un Producto'
                              : null,
                          onChanged: (x) {
                            _selectedTipoProducto = x as TipoProducto;
                            reportePedidos =
                                _pedidosService.getReporteProductoPedidoAnual(
                                    year, x.idTipoProd);
                            setState(() {});
                          },
                          asyncItems: (x) => _productoService.getProductos(),
                          itemAsString: (item) => item.nombre,
                        ),
                      ),
                    ]),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height - 250,
                  child: LineChart(
                    [
                      charts.Series<ReporteData, num>(
                        id: 'Pedidos',
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
                      new charts.ChartTitle('Productos Solicitados',
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
