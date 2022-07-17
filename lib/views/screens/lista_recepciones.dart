import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/view_model/lista_recepciones_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/detalles_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/barcode_search_textform.dart';
import 'package:clawtech_logistica_app/views/widgets/card_detalles_recepcion.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoRecepciones extends StatefulWidget {
  ListadoRecepciones({Key? key}) : super(key: key);

  @override
  State<ListadoRecepciones> createState() => _ListadoRecepcionesState();
}

class _ListadoRecepcionesState extends State<ListadoRecepciones> {
  TextEditingController _searchController = TextEditingController();
  ListadoRecepcionesViewModel viewModel =
      ListadoRecepcionesViewModel(recepcionService: RecepcionService());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: viewModel..add(LoadListadoRecepciones()),
        builder: (context, ListadoRecepcionesState state) {
          return state.state == ListadoRecepcionesStateEnum.loading
              ? LoadingPage()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      BarcodeSearchTextFile(
                          searchController: _searchController,
                          onChanged: (value) {
                            viewModel.add(FilterListadoRecepciones(value));
                          }),
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
                                              "${state.recepciones[index].idRecepcion}"),
                                        ),
                                      ),
                                      title: Text(
                                          'Recepcion ${state.recepciones[index].idRecepcion}'),
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
                  ),
                );
        });
  }
}
