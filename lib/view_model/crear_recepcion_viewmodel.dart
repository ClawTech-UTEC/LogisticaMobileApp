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
  }
  final ProductoService productoService;

  void loadProductos(
      OnStartedEvent event, Emitter<CrearRecepcionState> emit) async {
    List<TipoProducto> tipoProductos = await productoService.getProductos();
    emit(CrearRecepcionLoadedState(
        tipoProductos: tipoProductos, recepcionProductos: []));
  }
}

abstract class CrearRecepcionEvent extends Equatable {}

class AgregarProductoEvent extends CrearRecepcionEvent {
  List<Object> get props => [];
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

abstract class CrearRecepcionState extends Equatable {}

class CrearRecepcionInitialState extends CrearRecepcionState {
  
  CrearRecepcionInitialState();
  @override
  List<Object> get props => [];
}

class CrearRecepcionLoadedState extends CrearRecepcionState {
  List<TipoProducto> tipoProductos;
  List<RecepcionProducto> recepcionProductos;
  CrearRecepcionLoadedState(
      {required this.tipoProductos, required this.recepcionProductos});
  @override
  List<Object> get props => [tipoProductos, recepcionProductos];
}

class CrearRecepcionErrorState extends CrearRecepcionState {
  final String errorMessage;
  List<TipoProducto> tipoProductos;
  List<RecepcionProducto> recepcionProductos;
  CrearRecepcionErrorState(
      {this.errorMessage = "",
      this.tipoProductos = const [],
      this.recepcionProductos = const []});
  @override
  List<Object> get props => [errorMessage];
}
