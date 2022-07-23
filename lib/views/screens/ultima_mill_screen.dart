import 'dart:async';
import 'dart:ffi';

import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/screens/mapa_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class UltimaMilla extends StatefulWidget {
  UltimaMilla({Key? key}) : super(key: key);

  @override
  State<UltimaMilla> createState() => _UltimaMillaState();
}

class _UltimaMillaState extends State<UltimaMilla> {
  PedidosService _pedidosService = PedidosService();
  late Future<List<Pedido>> pedidos;
  List<Pedido> pedidosSeleccion = [];
  @override
  void initState() {
    super.initState();
    pedidos = getPedidos();
  }

  Future<List<Pedido>> getPedidos() async {
    int idUsuario =
        BlocProvider.of<AuthenticationViewModel>(context).usuario!.idUsuario!;
    List<Pedido> pedidos = await _pedidosService.getPedidosByUsuario(idUsuario);
    return pedidos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pedidos,
        builder: (context, AsyncSnapshot<List<Pedido>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Hero(
                              tag:
                                  "pedidos_card${snapshot.data![index].idPedido}",
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                        "${snapshot.data![index].idPedido}"),
                                  ),
                                ),
                                title: Text(
                                    'Pedido: ${snapshot.data![index].idPedido}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                        'Estado: ${snapshot.data![index].estadoPedido.last.tipoEstadoPedido.name}'),
                                    SizedBox(height: 10),
                                    Text(
                                        "Cliente: ${snapshot.data![index].cliente.nombre}")
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: Checkbox(
                                  value: pedidosSeleccion
                                      .contains(snapshot.data![index]),
                                  onChanged: (bool? value) {
                                    // value = checkboxList[index];
                                    // setState(() {});
                                  },
                                ),
                                onTap: () {
                                  bool isSelected = pedidosSeleccion
                                      .contains(snapshot.data![index]);
                                  if (isSelected) {
                                    pedidosSeleccion
                                        .remove(snapshot.data![index]);
                                  } else {
                                    pedidosSeleccion.add(snapshot.data![index]);
                                  }

                                  setState(() {});
                                },
                              ),
                            ));
                      }),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapaRuta(
                                    pedidos: pedidosSeleccion,
                                  )));
                    },
                    child: Text('Ver ultima milla')),
              ],
            );
          } else {
            return LoadingPage(
            
            );
          }
        });
  }
}
