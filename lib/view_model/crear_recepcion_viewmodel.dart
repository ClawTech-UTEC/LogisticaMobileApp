import 'dart:convert';

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
    emit(CrearRecepcionLoadedState(
        selectedProvedor: event.provedor,
        tipoProductos: tipoProductos,
        recepcion: state.recepcion,
        recepcionProductos: state.recepcionProductos,
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("ConfirmarRecepcionEvent" + state.toString());
    state.recepcion.fechaRecepcion = DateTime.now();
    state.recepcion.provedor = state.selectedProvedor;

    state.recepcion.estadoRecepcion = [
      EstadoRecepcion(recepcion: state.recepcion, fecha: DateTime.now())
    ];
    Recepcion recepcion = await recepcionService.createRec(state.recepcion);

    //TODO: controlar exepciones al crear una
    emit(CrearRecepcionRecepcionCreadaState(recepcion: recepcion));
  }
}

//TODO: simplificar el codigo
abstract class CrearRecepcionEvent extends Equatable {}

class AgregarProductoEvent extends CrearRecepcionEvent {
  final TipoProducto producto;
  final double cantidad;
  AgregarProductoEvent(this.producto, this.cantidad);
  List<Object> get props => [producto, cantidad];
}

class QuitarProductoEvent extends CrearRecepcionEvent {
  List<Object> get props => [];
}

class ConfirmarRecepcionEvent extends CrearRecepcionEvent {
  List<Object> get props => [];
}

class OnStartedEvent extends CrearRecepcionEvent {
  List<Object> get props => [];
}

class OnCambiarProvedorEvent extends CrearRecepcionEvent {
  final Provedor provedor;
  OnCambiarProvedorEvent({required this.provedor});
  List<Object> get props => [];
}

abstract class CrearRecepcionState {
  CrearRecepcionState();
  Recepcion recepcion = Recepcion();
  List<TipoProducto> tipoProductos = [];
  Map<TipoProducto, double> recepcionProductos = Map<TipoProducto, double>();
  List<Provedor> provedores = [];
  Provedor? selectedProvedor;
}

class CrearRecepcionInitialState extends CrearRecepcionState {
  CrearRecepcionInitialState();
}

class CrearRecepcionLoadedState extends CrearRecepcionState {
  List<TipoProducto> tipoProductos;
  List<Provedor> provedores;
  Recepcion recepcion;
  Provedor? selectedProvedor;
  Map<TipoProducto, double> recepcionProductos = Map<TipoProducto, double>();

  CrearRecepcionLoadedState(
      {required this.recepcion,
      this.selectedProvedor,
      required this.tipoProductos,
      required this.recepcionProductos,
      required this.provedores});
}

class CrearRecepcionErrorState extends CrearRecepcionState {
  final String errorMessage;
  List<TipoProducto> tipoProductos;
  Map<TipoProducto, double> recepcionProductos = Map<TipoProducto, double>();
  Recepcion recepcion;
  CrearRecepcionErrorState(
      {this.errorMessage = "",
      this.tipoProductos = const [],
      required this.recepcionProductos,
      required this.recepcion});
}

class CrearRecepcionRecepcionCreadaState extends CrearRecepcionState {
  Recepcion recepcion;
  CrearRecepcionRecepcionCreadaState({required this.recepcion});
}
