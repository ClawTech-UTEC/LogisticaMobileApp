import 'package:barcode_widget/barcode_widget.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/utils/confirmation_diolog.dart';
import 'package:clawtech_logistica_app/view_model/entregar_pedido_viewmode.dart';
import 'package:clawtech_logistica_app/view_model/events/entregar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/entregar_pedido_state.dart';

import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:clawtech_logistica_app/views/widgets/tabla_detalle_pedido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntregarPedidoScren extends StatefulWidget {
  EntregarPedidoScren({Key? key, required this.pedido}) : super(key: key);
  Pedido pedido;

  @override
  State<EntregarPedidoScren> createState() => _EntregarPedidoScrenState();
}

class _EntregarPedidoScrenState extends State<EntregarPedidoScren> {
  final EntregarPedidoViewModel viewModel = EntregarPedidoViewModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // viewModel.add(EntregarPedidoEventLoad(widget.pedido));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
      title: 'Entregar Pedido',
      child: BlocListener(
          bloc: viewModel,
          listener: (BuildContext context, EntregarPedidoState state) {
            print(state.status.name);

            if (state.status == EntregarPedidoStateEnum.ERROR) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text('${state.error}'),
                ),
              );
            }
            if (state.status == EntregarPedidoStateEnum.COMPLETED) {
              print(true);

              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage()),
              );
            }
          },
          child: BlocBuilder(
              bloc: viewModel..add(EntregarPedidoEventLoad(widget.pedido)),
              builder: (context, EntregarPedidoState state) => state.status ==
                      EntregarPedidoStateEnum.LOADED
                  ? CardGeneral(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pedido: ${widget.pedido.idPedido}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              BarcodeWidget(
                                height: 30,
                                drawText: false,
                                barcode: Barcode.code128(),
                                data: '${widget.pedido.idPedido}',
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Text('Productos: ',
                              style: Theme.of(context).textTheme.titleMedium),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: TablaDetallePedido(pedido: widget.pedido)),
                          Divider(
                            thickness: 1,
                          ),
                          Text('Cliente: ${widget.pedido.cliente.nombre}',
                              style: Theme.of(context).textTheme.titleMedium),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: DataTable(
                                headingTextStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                dataTextStyle:
                                    Theme.of(context).textTheme.bodySmall,
                                columns: [
                                  DataColumn(
                                    label: Text("Fecha:"),
                                  ),
                                  DataColumn(label: Text("TOTAL:"))
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Text('${widget.pedido.getFecha}')),
                                    DataCell(Text('\$${widget.pedido.total}'))
                                  ])
                                ],
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      confirmarcionDiolog(
                                          context: context,
                                          title: 'Confirmar Despacho',
                                          onConfirm: () {
                                            viewModel.add(
                                                EntregarPedidoEventConfirmarPedido());
                                          });
                                    })
                              ])
                        ]))
                  : LoadingPage())),
    );
  }
}
