import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/view_model/crear_pedido_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearPedidoScreen extends StatefulWidget {
  CrearPedidoScreen({Key? key}) : super(key: key);

  @override
  State<CrearPedidoScreen> createState() => _CrearPedidoScreenState();
}

class _CrearPedidoScreenState extends State<CrearPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  CrearPedidoViewModel viewModel = CrearPedidoViewModel();
  TextEditingController _cantidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: "Crear Pedido",
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: BlocListener(
                    bloc: viewModel,
                    listener: (BuildContext context, CrearPedidoState state) {
                      if (state.status == CrearPedidoStateEnum.ERROR) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).accentColor,
                            content: Text('${state.error}'),
                          ),
                        );
                      }
                    },
                    child: BlocBuilder(
                        bloc: viewModel..add(CrearPedidoEventLoad()),
                        builder: (context, CrearPedidoState state) {
                          if (state.status == CrearPedidoStateEnum.INITIAL) {
                            return LoadingPage();
                          }

                          return Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: DropdownButtonFormField(
                                            icon: Icon(Icons.arrow_drop_down),
                                            validator: (value) => value == null
                                                ? 'Debe seleccionar un Producto'
                                                : null,
                                            decoration: InputDecoration(
                                              labelText: 'Producto',
                                            ),
                                            onChanged: (x) {
                                              viewModel.add(
                                                  CrearPedidoEventSeleccionarProducto(
                                                      producto: x as Producto));
                                            },
                                            items: state.productos
                                                .map((producto) =>
                                                    DropdownMenuItem(
                                                      child: Text(producto
                                                          .tipoProducto.nombre),
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
                                    Text(
                                        "Disponible: ${state.productoSeleccionado?.cantidadDisponible.toString() ?? ""}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    TextFormField(
                                      controller: _cantidadController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Cantidad',
                                      ),
                                      onChanged: (value) {
                                        if (double.parse(value) >
                                            state.productoSeleccionado!
                                                .cantidadDisponible) {
                                          _cantidadController.text = state
                                              .productoSeleccionado!
                                              .cantidadDisponible
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
                                    _createPedidoProductsDataTable(
                                        state.cantidadPorProducto),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            viewModel.add(
                                                CrearPedidoEventAgregarProducto(
                                              producto:
                                                  state.productoSeleccionado!,
                                              cantidad: int.parse(
                                                  _cantidadController.text),
                                            ));
                                          }
                                        },
                                        child: Text("Agregar Producto"))
                                  ],
                                ),
                              ));
                        })))));
  }
}

DataTable _createPedidoProductsDataTable(
  Map<Producto, int> productos,
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

List<DataRow> _createPedidoProductsRows(Map<Producto, int> productos) {
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
