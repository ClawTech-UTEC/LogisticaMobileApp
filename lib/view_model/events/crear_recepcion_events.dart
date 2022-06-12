//TODO: simplificar el codigo
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:equatable/equatable.dart';

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
