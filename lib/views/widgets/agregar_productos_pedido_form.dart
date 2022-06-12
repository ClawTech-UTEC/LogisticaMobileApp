import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/view_model/crear_pedido_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/events/crear_pedido_events.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgregarProdoctosPedidoForm extends StatelessWidget {
  const AgregarProdoctosPedidoForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.viewModel,
    required TextEditingController cantidadController,
  })  : _formKey = formKey,
        _cantidadController = cantidadController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final CrearPedidoViewModel viewModel;
  final TextEditingController _cantidadController;

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: DropdownButtonFormField(
                              icon: Icon(Icons.arrow_drop_down),
                              validator: (value) => value == null
                                  ? 'Debe seleccionar un Producto'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Producto',
                              ),
                              onChanged: (x) {
                                viewModel.add(CrearPedidoEventSeleccionarProducto(
                                    producto: x as Producto));
                              },
                              items: viewModel.state.productos
                                  .map((producto) => DropdownMenuItem(
                                        child: Text(producto.tipoProducto.nombre),
                                        value: producto,
                                      ))
                                  .toList(),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              iconSize: 48,
                              icon: Icon(CupertinoIcons.barcode),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                        "Disponible: ${viewModel.state.productoSeleccionado?.cantidadDisponible.toString() ?? ""}",
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                      ),
                      onChanged: (value) {
                        if (double.parse(value) >
                            viewModel
                                .state.productoSeleccionado!.cantidadDisponible) {
                          _cantidadController.text = viewModel
                              .state.productoSeleccionado!.cantidadDisponible
                              .toString();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una cantidad';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.add(CrearPedidoEventAgregarProducto(
                              producto: viewModel.state.productoSeleccionado!,
                              cantidad: int.parse(_cantidadController.text),
                            ));
                          }
                        },
                        child: Text("Agregar Producto")),
                    _createPedidoProductsDataTable(
                        viewModel.state.cantidadPorProducto),
                  ],
                ),
              ),
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
