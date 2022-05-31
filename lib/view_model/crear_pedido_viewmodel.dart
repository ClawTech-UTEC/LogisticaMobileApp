import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/services/cliente_service.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/services/stock_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearPedidoViewModel extends Bloc<CrearPedidoEvent, CrearPedidoState> {
  CrearPedidoViewModel()
      : super(CrearPedidoState(status: CrearPedidoStateEnum.INITIAL)) {
    on<CrearPedidoEventLoad>(onLoad);
    on<CrearPedidoEventSeleccionarProducto>(onSeleccionarProducto);
    on<CrearPedidoEventAgregarProducto>(onAgregarProducto);
  }

  ClienteService clienteService = ClienteService();
  StockService stockService = StockService();
  void onLoad(CrearPedidoEvent event, Emitter<CrearPedidoState> emit) async {
    List<Cliente> clientes = await clienteService.getAllClientes();
    List<Producto> productos = await stockService.getProductosDisponibles();
    Map<Producto, int> productosPedido = Map<Producto, int>();
    // productos.forEach((producto) {
    //   productosPedido[producto] = 0;
    // });
    emit(state.copyWith(
        cantidadPorProducto: productosPedido,
        productos: productos,
        clientes: clientes,
        status: CrearPedidoStateEnum.LOADED));
  }

  void onSeleccionarProducto(CrearPedidoEventSeleccionarProducto event,
      Emitter<CrearPedidoState> emit) {
    emit(state.copyWith(
      productoSeleccionado: event.producto,
    ));
  }

  void onAgregarProducto(
      CrearPedidoEventAgregarProducto event, Emitter<CrearPedidoState> emit) {
    int cantidadInicial = state.cantidadPorProducto[event.producto] ?? 0;
    int cantidadTotal = cantidadInicial + event.cantidad;
    if (cantidadTotal > event.producto.cantidadDisponible) {
      emit(state.copyWith(
          status: CrearPedidoStateEnum.ERROR,
          error: 'La cantidad ingresada supera la cantidad disponible'));
      return;
    }
    state.cantidadPorProducto[event.producto] = cantidadTotal;
    emit(state.copyWith());
  }
}

enum CrearPedidoStateEnum { INITIAL, LOADED, ERROR, COMPLETED }

abstract class CrearPedidoEvent {}

class CrearPedidoEventLoad extends CrearPedidoEvent {
  CrearPedidoEventLoad();
}

class CrearPedidoEventSeleccionarProducto extends CrearPedidoEvent {
  final Producto producto;
  CrearPedidoEventSeleccionarProducto({required this.producto});
}

class CrearPedidoEventAgregarProducto extends CrearPedidoEvent {
  final Producto producto;
  final int cantidad;
  CrearPedidoEventAgregarProducto(
      {required this.producto, required this.cantidad});
}

class CrearPedidoEventConfirmarPedido extends CrearPedidoEvent {
  final Producto producto;
  CrearPedidoEventConfirmarPedido({required this.producto});
}

class CrearPedidoState {
  CrearPedidoStateEnum status;
  Pedido? pedido;
  List<Cliente> clientes;
  List<Distribuidor> distribuidores;
  List<Producto> productos;
  Map<Producto, int> cantidadPorProducto = Map<Producto, int>();
  Producto? productoSeleccionado;
  String? error;
  CrearPedidoState({
    this.status = CrearPedidoStateEnum.INITIAL,
    this.clientes = const [],
    this.distribuidores = const [],
    this.pedido,
    this.cantidadPorProducto = const {},
    this.productos = const [],
    this.productoSeleccionado,
    this.error,
  });

  CrearPedidoState copyWith({
    CrearPedidoStateEnum? status,
    Pedido? pedido,
    List<Cliente>? clientes,
    List<Distribuidor>? distribuidores,
    Map<Producto, int>? cantidadPorProducto,
    List<Producto>? productos,
    Producto? productoSeleccionado,
    String? error,
  }) {
    return CrearPedidoState(
      status: status ?? this.status,
      pedido: pedido ?? this.pedido,
      clientes: clientes ?? this.clientes,
      distribuidores: distribuidores ?? this.distribuidores,
      cantidadPorProducto: cantidadPorProducto ?? this.cantidadPorProducto,
      productos: productos ?? this.productos,
      productoSeleccionado: productoSeleccionado ?? this.productoSeleccionado,
      error: error ?? this.error,
    );
  }
}
