import 'dart:convert';

import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/services/provedor_service.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/view_model/events/crear_recepcion_events.dart';
import 'package:clawtech_logistica_app/view_model/states/crear_recepcion_states.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearRecepcionViewModel
    extends Bloc<CrearRecepcionEvent, CrearRecepcionState> {
  CrearRecepcionViewModel(
      {required this.productoService,
      required this.provedorService,
      required this.recepcionService})
      : super(CrearRecepcionInitialState()) {
    on<OnStartedEvent>(loadProvedores);
    on<AgregarProductoEvent>(agregarProducto);
    on<OnCambiarProvedorEvent>(loadProductos);
    on<ConfirmarRecepcionEvent>(confirmarRecepcion);

    add(OnStartedEvent());
  }
  final ProductoService productoService;
  final ProvedorService provedorService;
  final RecepcionService recepcionService;

  dispose() {}

  void loadProvedores(
      OnStartedEvent event, Emitter<CrearRecepcionState> emit) async {
    List<Provedor> provedores = await provedorService.getProvedores();

    emit(CrearRecepcionLoadedState(
        tipoProductos: [],
        provedores: provedores,
        recepcion: Recepcion(),
        recepcionProductos: state.recepcionProductos));
  }

  void loadProductos(
      OnCambiarProvedorEvent event, Emitter<CrearRecepcionState> emit) async {
    List<TipoProducto> tipoProductos =
        await productoService.getProductosByProvedor(event.provedor.idProv);
    ;
    emit(CrearRecepcionLoadedState(
        selectedProvedor: event.provedor,
        tipoProductos: tipoProductos,
        recepcion: Recepcion(),
        recepcionProductos: {},
        provedores: state.provedores));
  }

  void agregarProducto(
      AgregarProductoEvent event, Emitter<CrearRecepcionState> emit) {
    RecepcionProducto recepcionProducto = RecepcionProducto(
      producto: event.producto,
      cantidad: event.cantidad,
      recepcion: state.recepcion,
    );

    //Comprueba si el producto ya esta en la lista, en cuyo caso lo agrega a la cantidad
    state.recepcionProductos.containsKey(event.producto)
        ? state.recepcionProductos[event.producto] =
            state.recepcionProductos[event.producto]! + event.cantidad
        : state.recepcionProductos.addAll({event.producto: event.cantidad});

    //Genera una nueva lista con los productos actualizados
    List<RecepcionProducto> list = [];

    state.recepcionProductos.forEach((key, value) => list.add(RecepcionProducto(
          producto: key,
          cantidad: value,
          recepcion: state.recepcion,
        )));

    state.recepcion.productos = list;

    emit(CrearRecepcionLoadedState(
        selectedProvedor: state.selectedProvedor,
        provedores: state.provedores,
        tipoProductos: state.tipoProductos,
        recepcionProductos: state.recepcionProductos,
        recepcion: state.recepcion));
  }

  void confirmarRecepcion(
      ConfirmarRecepcionEvent event, Emitter<CrearRecepcionState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    Usuario usuario =
        Usuario(email: authData.email, idUsuario: authData.idUsuario);
    print("ConfirmarRecepcionEvent" + state.toString());
    state.recepcion.fechaRecepcion = DateTime.now();
    state.recepcion.provedor = state.selectedProvedor;

    state.recepcion.estadoRecepcion = [
      EstadoRecepcion(
          recepcion: state.recepcion, fecha: DateTime.now(), usuario: usuario)
    ];

    Recepcion recepcion = await recepcionService.createRec(state.recepcion);

    //TODO: controlar exepciones al crear una
    emit(CrearRecepcionRecepcionCreadaState(recepcion: recepcion));
  }
}
