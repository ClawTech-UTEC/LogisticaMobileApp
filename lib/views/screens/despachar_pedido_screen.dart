import 'package:barcode_widget/barcode_widget.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/services/distribuidor_service.dart';
import 'package:clawtech_logistica_app/utils/confirmation_diolog.dart';
import 'package:clawtech_logistica_app/view_model/despachar_pedido_viewmode.dart';
import 'package:clawtech_logistica_app/view_model/events/despachar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/despachar_pedido_state.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:clawtech_logistica_app/views/widgets/tabla_detalle_pedido.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DespacharPedidoScren extends StatefulWidget {
  DespacharPedidoScren({Key? key, required this.pedido}) : super(key: key);
  Pedido pedido;

  @override
  State<DespacharPedidoScren> createState() => _DespacharPedidoScrenState();
}

class _DespacharPedidoScrenState extends State<DespacharPedidoScren> {
  final DespacharPedidoViewModel viewModel = DespacharPedidoViewModel();
  Distribuidor? _selectedDistribuidor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // viewModel.add(DespacharPedidoEventLoad(widget.pedido));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
      title: 'Despachar Pedido',
      child: BlocListener(
          bloc: viewModel,
          listener: (BuildContext context, DespacharPedidoState state) {
            print(state.status.name);

            if (state.status == DespacharPedidoStateEnum.ERROR) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text('${state.error}'),
                ),
              );}
              if (state.status == DespacharPedidoStateEnum.COMPLETED) {
                print(true);

                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage()),
                );
              }
            
          },
          child: BlocBuilder(
              bloc: viewModel..add(DespacharPedidoEventLoad(widget.pedido)),
              builder: (context, DespacharPedidoState state) => state.status ==
                      DespacharPedidoStateEnum.LOADED
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
                          DropdownSearch<Distribuidor>(
                            popupProps: PopupProps.menu(showSearchBox: true),
                            validator: (value) => value == null
                                ? 'Debe seleccionar un Distribuidor'
                                : null,
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Distribuidor',
                            ),
                            selectedItem: _selectedDistribuidor,
                            itemAsString: (item) => item.chofer,
                            asyncItems: (searchValue) async {
                              return await DistribuidoresService()
                                  .getDistribuidores();
                            },
                            onChanged: (item) {
                              _selectedDistribuidor = item;
                            },
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      _selectedDistribuidor != null
                                          ? confirmarcionDiolog(
                                              context: context,
                                              title: 'Confirmar Despacho',
                                              onConfirm: () {
                                                viewModel.add(
                                                    DespacharPedidoEventConfirmarPedido(
                                                        _selectedDistribuidor!));
                                              })
                                          : null;
                                      ;
                                    })
                              ])
                        ]))
                  : LoadingPage())),
    );
  }
}
