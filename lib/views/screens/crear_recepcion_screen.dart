import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/services/provedor_service.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/view_model/crear_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/views/widgets/card_recepcion.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/crear_recepcion_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearRecepcionScreen extends StatefulWidget {
  CrearRecepcionScreen({Key? key}) : super(key: key);

  @override
  State<CrearRecepcionScreen> createState() => _CrearRecepcionScreenState();
}

class _CrearRecepcionScreenState extends State<CrearRecepcionScreen> {
  CrearRecepcionViewModel viewModel = CrearRecepcionViewModel(
      productoService: ProductoService(),
      provedorService: ProvedorService(),
      recepcionService: RecepcionService());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: viewModel..add(OnStartedEvent()),
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Crear Recepcion'),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: manageState(state, viewModel),
          );
        });
  }

  Widget manageState(Object? state, viewModel) {
    if (state is CrearRecepcionInitialState) {
      return LoadingPage();
    } else if (state is CrearRecepcionLoadedState) {
      return CrearRecepcionForm(
          provedores: state.provedores,
          tipoProductos: state.tipoProductos,
          viewModel: viewModel);
    } else if (state is CrearRecepcionRecepcionCreadaState) {
      return CardDetallesRecepcion(recepcion: state.recepcion);
    }
    return LoadingPage();
  }
}
