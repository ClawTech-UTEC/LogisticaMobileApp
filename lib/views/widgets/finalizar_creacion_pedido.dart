import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/view_model/crear_pedido_viewmodel.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:flutter/material.dart';

class FinalizarCreacionPedido extends StatefulWidget {
  FinalizarCreacionPedido({
    Key? key,
    required this.viewModel,
  }) : super(key: key);
  final CrearPedidoViewModel viewModel;

  @override
  State<FinalizarCreacionPedido> createState() =>
      _FinalizarCreacionPedidoState();
}

class _FinalizarCreacionPedidoState extends State<FinalizarCreacionPedido> {
  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
                Text(
                      'Resumen de pedido:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  Divider(
                    thickness: 1,
                  ),
                  Text(
                    'Cliente:',
                    style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: Colors.grey[600]),
                  ),
                  ListTile(
                    title: Text(
                      'Nomnbre: ${widget.viewModel.state.cliente == null ? '' : widget.viewModel.state.cliente?.nombre}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    subtitle: Text(
                      'Direccion: ${widget.viewModel.state.cliente == null ? '' :  widget.viewModel.state.cliente!.direccion}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                   Divider(
                thickness: 1,
              ),
                  Text(
                    'Productos:',
                    style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: Colors.grey[600]),
                  ),
              widget.viewModel.state.cantidadPorProducto.isNotEmpty ?    FittedBox(
                fit: BoxFit.fitWidth,
                child: _createPedidoProductsDataTable(
                        widget.viewModel.state.cantidadPorProducto),
              ) : Container(),
                ],
              
          ),
        ),
      ),
    );
  }
}

DataTable _createPedidoProductsDataTable(
  Map<Producto, double> productos,
) {
  return DataTable(
      columns: _createPedidoProductsColumns(),
      rows: _createPedidoProductsRows(productos));
}

List<DataColumn> _createPedidoProductsColumns() {
  return [
    DataColumn(label: Text('Producto')),
    DataColumn(label: Text('Cantidad')),
    DataColumn(label: Text('Precio'))
  ];
}

List<DataRow> _createPedidoProductsRows(Map<Producto, double> productos) {
  List<DataRow> list = [];

  productos.forEach((producto, cantidad) => list.add(DataRow(
        cells: [
          DataCell(Text(producto.tipoProducto.nombre)),
          DataCell(Text(cantidad.toString())),
          DataCell(Text(producto.tipoProducto.precio.toString()))
        ],
      )));
  return list;
}
