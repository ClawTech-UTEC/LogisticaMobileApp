import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/view_model/controlar_pedido_viewmode.dart';
import 'package:clawtech_logistica_app/view_model/events/controlar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/events/preparar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/preparar_pedido_viewmode.dart';
import 'package:clawtech_logistica_app/view_model/states/controlar_pedido_state.dart';
import 'package:clawtech_logistica_app/view_model/states/preparar_pedido_state.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/barcode_search_textform.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlarPedidoScreen extends StatefulWidget {
  ControlarPedidoScreen({Key? key, required Pedido this.pedido})
      : super(key: key);
  final Pedido pedido;
  @override
  State<ControlarPedidoScreen> createState() => _ControlarPedidoScreenState();
}

class _ControlarPedidoScreenState extends State<ControlarPedidoScreen> {
  ControlarPedidoViewModel viewModel = ControlarPedidoViewModel();
  TextEditingController _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: "Controlar Pedido",
        child: BlocListener(
          bloc: viewModel,
          listener: (context, ControlarPedidoState state) {
            if (state.status == ControlarPedidoStateEnum.ERROR) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text('${state.error}'),
                ),
              );
            }
            if (state.status == ControlarPedidoStateEnum.COMPLETED) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage()),
              );
            }
          },
          child: BlocBuilder(
              bloc: viewModel
                ..add(ControlarPedidoEventLoad(
                  widget.pedido,
                )),
              builder: (context, ControlarPedidoState state) {
                if (state.status == ControlarPedidoStateEnum.INITIAL) {
                  return LoadingPage();
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CardGeneral(
                    child: Column(
                      children: [
                        BarcodeSearchTextFile(
                            onChanged: (_) => {},
                            searchController: _searchController,
                            onScanCompleted: (String x) {
                              viewModel
                                  .add((ControlarPedidoEventAgregarProducto(
                                x,
                              )));
                            },
                            onSearch: () {
                              viewModel
                                  .add((ControlarPedidoEventAgregarProducto(
                                _searchController.text,
                              )));
                            }),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Form(
                            key: _formKey,
                            child: _createControllRecepctionDataTable(
                                state.pedido!.productos, state.tableController),
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
                              onPressed: (() => {
                                    if (_formKey.currentState!.validate())
                                      {
                                        confirmarcionDiolog(
                                            onConfirm: () {
                                              viewModel.add(
                                                  ControlarPedidoEventConfirmarPedido());
                                            },
                                            context: context,
                                            title: "Aceptar el pedido")
                                      }
                                    else
                                      {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            content:
                                                Text('No coincide los datos'),
                                          ),
                                        )
                                      }
                                  }),
                              child: Text("Aceptar"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  void confirmarcionDiolog(
      {required BuildContext context,
      required String title,
      required VoidCallback onConfirm}) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Por favor confirmar'),
            content: Text(title),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    onConfirm();

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Si')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}

DataTable _createControllRecepctionDataTable(
    List<PedidoProducto> productosCantidad,
    List<TextEditingController> controllersCantidadIngresada) {
  return DataTable(
      columnSpacing: 40,
      columns: _controllRecepctionProductsColumns(),
      rows: _controllRecepctionProductsRows(
          productosCantidad, controllersCantidadIngresada));
}

List<DataColumn> _controllRecepctionProductsColumns() {
  return [
    DataColumn(label: Text('Producto')),
    DataColumn(label: Text('Codigo')),
    DataColumn(label: Text('Esperado'), numeric: true),
    DataColumn(label: Text('Recibido'), numeric: true),
  ];
}

List<DataRow> _controllRecepctionProductsRows(List<PedidoProducto> productos,
    List<TextEditingController> controllersCantidadIngresada) {
  TextEditingController _textEditing = TextEditingController();
  return productos.map((entry) {
    return DataRow(cells: [
      DataCell(Text('${entry.producto.nombre}')),
      DataCell(Text('${entry.producto.codigoDeBarras}')),
      DataCell(Text('${entry.cantidad}')),
      DataCell(
          TextFormField(
            controller: controllersCantidadIngresada[productos.indexOf(entry)],
            //  initialValue: '${entry.value}',
            validator: (value) {
              if (value == null) {
                return '';
              }
              if (value != entry.cantidad.toString()) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          showEditIcon: true)
    ]);
  }).toList();
}
