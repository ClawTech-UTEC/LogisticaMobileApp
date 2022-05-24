import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearRecepcionViewModel
    extends Bloc<CrearRecepcionEvent, CrearRecepcionState> {
  CrearRecepcionViewModel({required this.productoService})
      : super(CrearRecepcionInitialState()) {
    on<OnStartedEvent>(loadProductos);
    on<AgregarProductoEvent>(agregarProducto);
  }
  final ProductoService productoService;
  void loadProductos(
      OnStartedEvent event, Emitter<CrearRecepcionState> emit) async {
    List<TipoProducto> tipoProductos = await productoService.getProductos();
    emit(CrearRecepcionLoadedState(
        tipoProductos: tipoProductos,
        recepcionProductos: [],
        recepcion: state.recepcion));
  }

  void agregarProducto(
      AgregarProductoEvent event, Emitter<CrearRecepcionState> emit) {
    print("AgregarProductoEvent" + state.toString());

    RecepcionProducto recepcionProducto = RecepcionProducto(
        producto:  event.producto,
        cantidad: event.cantidad,
        recepcion: state.recepcion.idRecepcion!);
    List<RecepcionProducto> recepcionesProductos = state.recepcionProductos;
    recepcionesProductos.add(recepcionProducto);
    emit(CrearRecepcionLoadedState(
        tipoProductos: state.tipoProductos,
        recepcionProductos: recepcionesProductos,
        recepcion: state.recepcion));
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

abstract class CrearRecepcionState  {
  CrearRecepcionState();
  Recepcion recepcion = Recepcion();
  List<TipoProducto> tipoProductos = [];
  List<RecepcionProducto> recepcionProductos = [];
 
}

class CrearRecepcionInitialState extends CrearRecepcionState {
  CrearRecepcionInitialState();
  
}

class CrearRecepcionLoadedState extends CrearRecepcionState {
  List<TipoProducto> tipoProductos;
  List<RecepcionProducto> recepcionProductos;
  Recepcion recepcion;
  CrearRecepcionLoadedState(
      {required this.tipoProductos,
      required this.recepcionProductos,
      required this.recepcion});
  
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
