import 'dart:convert';

import 'package:clawtech_logistica_app/enums/tipo_estado_pedido.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/estado_pedido.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/cliente_service.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/services/stock_service.dart';
import 'package:clawtech_logistica_app/view_model/events/crear_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/crear_pedido_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearPedidoViewModel extends Bloc<CrearPedidoEvent, CrearPedidoState> {
  CrearPedidoViewModel()
      : super(CrearPedidoState(status: CrearPedidoStateEnum.INITIAL)) {
    on<CrearPedidoEventLoad>(onLoad);
    on<CrearPedidoEventSeleccionarProducto>(onSeleccionarProducto);
    on<CrearPedidoEventAgregarProducto>(onAgregarProducto);
    on<CrearPedidoEventConfirmarCliente>(onAgregarCliente);
    on<CrearPedidoEventConfirmarPedido>(onConfirmarPedido);
  }

  ClienteService clienteService = ClienteService();
  StockService stockService = StockService();
  PedidosService pedidosService = PedidosService();
  void onLoad(CrearPedidoEvent event, Emitter<CrearPedidoState> emit) async {
    List<Producto> productos = await stockService.getProductosDisponibles();
    Map<Producto, double> productosPedido = Map<Producto, double>();
    Cliente cliente = Cliente();
    emit(state.copyWith(
        cantidadPorProducto: productosPedido,
        productos: productos,
        // clientes: clientes,
        cliente : cliente,

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
    double cantidadInicial = state.cantidadPorProducto[event.producto] ?? 0;
    double cantidadTotal = cantidadInicial + event.cantidad;
    if (cantidadTotal > event.producto.cantidadDisponible) {
      emit(state.copyWith(
          status: CrearPedidoStateEnum.ERROR,
          error: 'La cantidad ingresada supera la cantidad disponible'));
      return;
    }
    state.cantidadPorProducto[event.producto] = cantidadTotal;
    emit(state.copyWith());
  }

  void onAgregarCliente(
      CrearPedidoEventConfirmarCliente event, Emitter<CrearPedidoState> emit) {
    emit(state.copyWith(
     
    ));
  }

  void onConfirmarPedido(CrearPedidoEventConfirmarPedido event,
      Emitter<CrearPedidoState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    Usuario usuario =
        Usuario(email: authData.email, idUsuario: authData.idUsuario);

    Pedido pedido = Pedido(
      direccion: state.cliente!.direccion,
      cliente: state.cliente!,
      fechaPedido: DateTime.now(),
      productos: List.generate(
          state.cantidadPorProducto.length,
          (index) => PedidoProducto(
              producto:
                  state.cantidadPorProducto.keys.elementAt(index).tipoProducto,
              cantidad: state.cantidadPorProducto.values.elementAt(index))),
      total: state.cantidadPorProducto.entries.fold(
          0,
          (previousValue, element) =>
              (element.key.tipoProducto.precioDeVenta * element.value) +
              previousValue),
      estadoPedido: [
        EstadoPedido(
            tipoEstadoPedido: TipoEstadoPedido.PENDIENTE,
            usuario: usuario,
            fecha: DateTime.now())
      ],
    );

    // try {
      Pedido pedidoCreado = await pedidosService.createPedido(pedido);
      emit(state.copyWith(
        status: CrearPedidoStateEnum.COMPLETED,
        pedido: pedidoCreado,
      ));
    // } catch (e) {
      // print(e);
      // emit(state.copyWith(
      //     status: CrearPedidoStateEnum.ERROR, error: e.toString()));
    
  }
}
