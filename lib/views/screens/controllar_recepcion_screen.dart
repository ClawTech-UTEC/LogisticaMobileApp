import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/control_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControllarRecepcionScreen extends StatefulWidget {
  ControllarRecepcionScreen({Key? key, required this.recepcion})
      : super(key: key);
  Recepcion recepcion;

  @override
  State<ControllarRecepcionScreen> createState() =>
      _ControllarRecepcionScreenState();
}

class _ControllarRecepcionScreenState extends State<ControllarRecepcionScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: "Controlar Recepción",
        child: BlocBuilder(
            bloc: ControlRecepcionViewModel()
              ..add(ControlRecepcionEventLoaded(recepcion: widget.recepcion)),
            builder: (context, ControlRecepcionState state) {
              if (state.status == ControlRecepcionStateEnum.INITIAL) {
                return LoadingPage();
              }

              return Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            _createControllRecepctionDataTable(
                                state.cantidadRecividaPorProducto)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor,
                            )),
                            onPressed: (() => {}),
                            child: Text("Aceptar"),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor,
                            )),
                            onPressed: (() => {}),
                            child: Text("Aceptar Con Diferencias"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}

DataTable _createControllRecepctionDataTable(
    Map<RecepcionProducto, int> productosCantidad) {
  return DataTable(
      columnSpacing: 40,
      columns: _controllRecepctionProductsColumns(),
      rows: _controllRecepctionProductsRows(productosCantidad));
}

List<DataColumn> _controllRecepctionProductsColumns() {
  return [
    DataColumn(label: Text('Producto')),
    DataColumn(label: Text('Codigo')),
    DataColumn(label: Text('Esperado'), numeric: true),
    DataColumn(label: Text('Recibido'), numeric: true),
  ];
}

List<DataRow> _controllRecepctionProductsRows(
    Map<RecepcionProducto, int> productos) {
  return productos.entries.map((entry) {
    return DataRow(cells: [
      DataCell(Text('${entry.key.producto.nombre}')),
      DataCell(Text('${entry.key.producto.codigoDeBarras}')),
      DataCell(Text('${entry.key.cantidad}')),
      DataCell(Text('${entry.value}'))
    ]);
  }).toList();
}
