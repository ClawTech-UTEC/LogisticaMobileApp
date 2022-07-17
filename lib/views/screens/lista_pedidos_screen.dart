import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/view_model/lista_pedidos_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/detalles_pedido_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/barcode_search_textform.dart';
import 'package:flutter/material.dart';

import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/view_model/lista_pedidos_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/detalles_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_detalles_recepcion.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoPedidos extends StatefulWidget {
  ListadoPedidos({Key? key}) : super(key: key);

  @override
  State<ListadoPedidos> createState() => _ListadoPedidosState();
}

class _ListadoPedidosState extends State<ListadoPedidos> {
  TextEditingController _searchController = TextEditingController();
  ListadoPedidosViewModel viewModel =
      ListadoPedidosViewModel(pedidosService: PedidosService());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: viewModel..add(LoadListadoPedidos()),
        builder: (context, ListadoPedidosState state) {
          return state.state == ListadoPedidosStateEnum.loading
              ? LoadingPage()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      BarcodeSearchTextFile(
                          searchController: _searchController,
                          onChanged: (value) {
                            viewModel.add(FilterListadoPedidos(value));
                          }),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                            itemCount: state.pedidos.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Hero(
                                    tag:
                                        "pedidos_card${state.pedidos[index].idPedido}",
                                    child: ListTile(
                                      tileColor: Colors.white,
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle),
                                        child: Center(
                                            child: Text( style :Theme.of(context).textTheme.headlineSmall,
                                                "${state.pedidos[index].idPedido}"),
                                            ),
                                      ),
                                      title: Text(
                                          'Pedido: ${state.pedidos[index].idPedido}'),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                              'Estado: ${state.pedidos[index].estadoPedido.last.tipoEstadoPedido.name}'),
                                          SizedBox(height: 10),
                                          Text(
                                              "Cliente: ${state.pedidos[index].cliente.nombre}")
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  DetallePedidoScreen(
                                                      pedido: state
                                                          .pedidos[index])),
                                        );
                                      },
                                    ),
                                  ));
                            }),
                      )
                    ],
                  ),
                );
        });
  }
}
