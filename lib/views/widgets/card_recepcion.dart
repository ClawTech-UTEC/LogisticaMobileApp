import 'package:barcode_widget/barcode_widget.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:flutter/material.dart';

class CardDetallesRecepcion extends StatefulWidget {
  CardDetallesRecepcion({Key? key, required this.recepcion}) : super(key: key);
  Recepcion recepcion;
  @override
  State<CardDetallesRecepcion> createState() => _CardDetallesRecepcionState();
}

class _CardDetallesRecepcionState extends State<CardDetallesRecepcion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recepcion: ${widget.recepcion.idRecepcion}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  BarcodeWidget(
                    height: 30, drawText: false,
                    barcode: Barcode.code128(),
                    data: '${widget.recepcion.idRecepcion}',
                  )
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Text('Productos: ',
                  style: Theme.of(context).textTheme.titleMedium),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView(
                    children: [
                      _createRecepctionProductsDataTable(
                          widget.recepcion.productos)
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SingleChildScrollView(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  DataTable(
                    headingTextStyle: Theme.of(context).textTheme.titleSmall,
                    dataTextStyle: Theme.of(context).textTheme.bodySmall,
                    horizontalMargin: 12,
                    columns: [
                      DataColumn(
                        label: Text("Fecha Creacion:"),
                      ),
                      DataColumn(
                        label: Text("Provedor:"),
                      ),
                      DataColumn(label: Text("TOTAL:"))
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('${widget.recepcion.getFecha}')),
                        DataCell(
                          Text('${widget.recepcion.provedor?.nombreProv}'),
                        ),
                        DataCell(Text('\$${widget.recepcion.total}'))
                      ])
                    ],
                  )
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Aceptar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Imprimir'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

DataTable _createRecepctionProductsDataTable(
    List<RecepcionProducto> productos) {
  return DataTable(
      columns: _createRecepctionProductsColumns(),
      rows: _createRecepctionProductsRows(productos));
}

List<DataColumn> _createRecepctionProductsColumns() {
  return [
    DataColumn(label: Text('Producto')),
    DataColumn(label: Text('Cantidad')),
    DataColumn(label: Text('Precio'))
  ];
}

List<DataRow> _createRecepctionProductsRows(List<RecepcionProducto> productos) {
  return productos.map((producto) => _createRow(producto)).toList();
}

DataRow _createRow(RecepcionProducto producto) {
  return DataRow(cells: [
    DataCell(Text(producto.producto.nombre)),
    DataCell(Text('${producto.cantidad}')),
    DataCell(Text('\$${producto.producto.precio}'))
  ]);
}
