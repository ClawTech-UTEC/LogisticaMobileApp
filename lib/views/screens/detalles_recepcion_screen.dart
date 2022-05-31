import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/view_model/crear_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/detalle_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_recepcion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecepcionDetallesScreen extends StatefulWidget {
  RecepcionDetallesScreen({Key? key, required this.recepcion})
      : super(key: key);
  Recepcion recepcion;
  @override
  State<RecepcionDetallesScreen> createState() =>
      _RecepcionDetallesScreenState();
}

class _RecepcionDetallesScreenState extends State<RecepcionDetallesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detalles de Recepcion'),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: BlocBuilder(
          bloc: DetalleRecepcionViewModel()
            ..add(LoadRecepcionEvent(widget.recepcion)),
          builder: (context, DetalleRecepcionState state) {
            if (state.state == DetalleRecepcionStateEnum.loaded) {
              return CardDetallesRecepcion(recepcion: state.recepcion!);
            }
            return LoadingPage();
          }),
    );
  }
}
