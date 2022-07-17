import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:flutter/material.dart';

class TablaDetallePedido extends StatelessWidget {
  const TablaDetallePedido({Key? key, required this.pedido}) : super(key: key);
  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Producto')),
          DataColumn(label: Text('Cantidad')),
          DataColumn(label: Text('Precio'))
        ],
        rows: pedido.productos
            .map((producto) => DataRow(cells: [
                  DataCell(Text(producto.producto.nombre)),
                  DataCell(Text('${producto.cantidad}')),
                  DataCell(Text('\$${producto.producto.precioDeVenta}'))
                ]))
            .toList());
  }
}