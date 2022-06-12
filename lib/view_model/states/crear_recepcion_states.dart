import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';

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
