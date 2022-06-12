import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';

enum CrearPedidoStateEnum { INITIAL, LOADED, ERROR, COMPLETED }

class CrearPedidoState {
  CrearPedidoStateEnum status;
  Pedido? pedido;
  List<Cliente> clientes;
  List<Distribuidor> distribuidores;
  List<Producto> productos;
  Map<Producto, double> cantidadPorProducto = Map<Producto, double>();
  Producto? productoSeleccionado;
  String? error;
  Cliente? cliente;

  CrearPedidoState({
    this.status = CrearPedidoStateEnum.INITIAL,
    this.clientes = const [],
    this.distribuidores = const [],
    this.pedido,
    this.cantidadPorProducto = const {},
    this.productos = const [],
    this.productoSeleccionado,
    this.error,
    this.cliente,
  });

  CrearPedidoState copyWith({
    CrearPedidoStateEnum? status,
    Pedido? pedido,
    List<Cliente>? clientes,
    List<Distribuidor>? distribuidores,
    Map<Producto, double>? cantidadPorProducto,
    List<Producto>? productos,
    Producto? productoSeleccionado,
    String? error = null,
    Cliente? cliente,
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
      cliente: cliente ?? this.cliente,
    );
  }
}
