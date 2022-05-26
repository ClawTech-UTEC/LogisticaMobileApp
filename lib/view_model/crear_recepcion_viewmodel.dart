import 'dart:convert';

import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/services/provedor_service.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }
  final ProductoService productoService;
  final ProvedorService provedorService;
  final RecepcionService recepcionService;
  void loadProvedores(
      OnStartedEvent event, Emitter<CrearRecepcionState> emit) async {
    List<Provedor> provedores = await provedorService.getProvedores();

    emit(CrearRecepcionLoadedState(
        tipoProductos: [], provedores: provedores, recepcion: Recepcion()));
  }

  void loadProductos(
      OnCambiarProvedorEvent event, Emitter<CrearRecepcionState> emit) async {
    List<TipoProducto> tipoProductos =
        await productoService.getProductosByProvedor(event.provedor.idProv);
    emit(CrearRecepcionLoadedState(
        selectedProvedor: event.provedor,
        tipoProductos: tipoProductos,
        recepcion: state.recepcion,
        provedores: state.provedores));
  }

  void agregarProducto(
      AgregarProductoEvent event, Emitter<CrearRecepcionState> emit) {
    print("AgregarProductoEvent" + state.toString());

    RecepcionProducto recepcionProducto = RecepcionProducto(
      producto: event.producto,
      cantidad: event.cantidad,
      recepcion: state.recepcion,
    );
    state.recepcion.productos = [
      ...state.recepcion.productos,
      recepcionProducto
    ];
    emit(CrearRecepcionLoadedState(
        selectedProvedor: state.selectedProvedor,
        provedores: state.provedores,
        tipoProductos: state.tipoProductos,
        recepcion: state.recepcion));
  }

  void confirmarRecepcion(
      ConfirmarRecepcionEvent event, Emitter<CrearRecepcionState> emit) {
    print("ConfirmarRecepcionEvent" + state.toString());
    state.recepcion.fechaRecepcion = DateTime.now();
    state.recepcion.provedor = state.selectedProvedor;
    state.recepcion.productos.forEach((element) {
      print(element.toJson());
    });
    recepcionService.createRec(state.recepcion);
    emit(CrearRecepcionLoadedState(
        selectedProvedor: state.selectedProvedor,
        provedores: state.provedores,
        tipoProductos: state.tipoProductos,
        recepcion: new Recepcion()));
  }
}

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
  List<RecepcionProducto> recepcionProductos = [];
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
  CrearRecepcionLoadedState(
      {required this.recepcion,
      this.selectedProvedor,
      required this.tipoProductos,
      required this.provedores});
}

class CrearRecepcionErrorState extends CrearRecepcionState {
  final String errorMessage;
  List<TipoProducto> tipoProductos;
  List<RecepcionProducto> recepcionProductos;
  Recepcion recepcion;
  CrearRecepcionErrorState(
      {this.errorMessage = "",
      this.tipoProductos = const [],
      this.recepcionProductos = const [],
      required this.recepcion});
}
