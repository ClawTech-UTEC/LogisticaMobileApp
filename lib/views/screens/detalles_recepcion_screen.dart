import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/view_model/crear_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/detalle_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_detalles_recepcion.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: 'Detalles de Recepcion',
        child: CardDetallesRecepcion(recepcion: widget.recepcion));
  }
}
