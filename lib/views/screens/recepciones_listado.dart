import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/view_model/lista_recepciones_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/detalles_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_recepcion.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoRecepciones extends StatefulWidget {
  ListadoRecepciones({Key? key}) : super(key: key);

  @override
  State<ListadoRecepciones> createState() => _ListadoRecepcionesState();
}

class _ListadoRecepcionesState extends State<ListadoRecepciones> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: ListadoRecepcionesViewModel(recepcionService: RecepcionService())
          ..add(LoadListadoRecepciones()),
        builder: (context, ListadoRecepcionesState state) {
          return state.state == ListadoRecepcionesStateEnum.loading
              ? LoadingPage()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              child: IconButton(
                                icon: Icon(CupertinoIcons.barcode),
                                onPressed: () async {
                                  String barcodeScannerResult =
                                      await FlutterBarcodeScanner.scanBarcode(
                                          "#ff6666",
                                          "Cancelar",
                                          false,
                                          ScanMode.DEFAULT);

                                  if (barcodeScannerResult != "-1") {
                                    _searchController.text =
                                        barcodeScannerResult;
                                    print("Codigo Escaneado: " +
                                        barcodeScannerResult);
                                  } else {
                                    print("No se escaneo nada");
                                  }
                                },
                              ),
                            ),
                            suffixIcon: Icon(Icons.search),
                            prefixIconColor: Colors.black,
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            hintText: "Buscar",
                            labelStyle: TextStyle(color: Colors.black),
                            focusColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                          itemCount: state.recepciones.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Hero(
                                  tag:
                                      "recepciones_card${state.recepciones[index].idRecepcion}",
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text('Recepcion $index'),
                                    subtitle: Text(
                                        'Estado: ${state.recepciones[index].estadoRecepcion.last.tipoEstado.name}'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                RecepcionDetallesScreen(
                                                    recepcion: state
                                                        .recepciones[index])),
                                      );
                                    },
                                  ),
                                ));
                          }),
                    )
                  ],
                );
        });
  }
}
