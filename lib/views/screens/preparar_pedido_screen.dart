import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/utils/confirmation_diolog.dart';
import 'package:clawtech_logistica_app/view_model/events/preparar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/preparar_pedido_viewmode.dart';
import 'package:clawtech_logistica_app/view_model/states/preparar_pedido_state.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/barcode_search_textform.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrepararPedidoScreen extends StatefulWidget {
  PrepararPedidoScreen({Key? key, required Pedido this.pedido})
      : super(key: key);
  final Pedido pedido;
  @override
  State<PrepararPedidoScreen> createState() => _PrepararPedidoScreenState();
}

class _PrepararPedidoScreenState extends State<PrepararPedidoScreen> {
  PrepararPedidoViewModel viewModel = PrepararPedidoViewModel();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: "Preparar Pedido",
        child: BlocListener(
          bloc: viewModel,
          listener: (context, PrepararPedidoState state) {
            if (state.status == PrepararPedidoStateEnum.ERROR) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text('${state.error}'),
                ),
              );
            }
            if (state.status == PrepararPedidoStateEnum.COMPLETED) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage()),
              );
            }
          },
          child: BlocBuilder(
              bloc: viewModel
                ..add(PrepararPedidoEventLoad(
                  widget.pedido,
                )),
              builder: (context, PrepararPedidoState state) {
                if (state.status == PrepararPedidoStateEnum.INITIAL) {
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
                              viewModel.add((PrepararPedidoEventAgregarProducto(
                                x,
                              )));
                            },
                            onSearch: () {
                              viewModel.add((PrepararPedidoEventAgregarProducto(
                                _searchController.text,
                              )));
                            }),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: _createControllRecepctionDataTable(
                              state.pedido!.productos, state.tableController),
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
                                    confirmarcionDiolog(
                                        onConfirm: () {
                                          viewModel.add(
                                              PrepararPedidoEventConfirmarPedido());
                                        },
                                        context: context,
                                        title: "Confirma preparar el pedido")
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
