import 'dart:async';
import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/view_model/events/preparar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/preparar_pedido_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrepararPedidoViewModel
    extends Bloc<PrepararPedidoEvent, PrepararPedidoState> {
  PrepararPedidoViewModel()
      : super(PrepararPedidoState(status: PrepararPedidoStateEnum.INITIAL)) {
    on<PrepararPedidoEventAgregarProducto>(onAgregarProducto);
    on<PrepararPedidoEventConfirmarPedido>(onConfirmarPrepararPedido);
    on<PrepararPedidoEventLoad>(onLoadPrepararPedido);
  }

  PedidosService _pedidosService = PedidosService();

  FutureOr<void> onLoadPrepararPedido(
      PrepararPedidoEventLoad event, Emitter<PrepararPedidoState> emit) {
    Map<PedidoProducto, double> cantidadRecividaPorProducto =
        Map<PedidoProducto, double>();

    event.pedido.productos.forEach((producto) {
      cantidadRecividaPorProducto[producto] = 0;
    });

    List<TextEditingController> tableController = List.filled(
        event.pedido.productos.length, TextEditingController(text: "0"));

    emit(state.copyWith(
      status: PrepararPedidoStateEnum.LOADED,
      pedido: event.pedido,
      tableController: tableController,
    ));
  }

  FutureOr<void> onAgregarProducto(PrepararPedidoEventAgregarProducto event,
      Emitter<PrepararPedidoState> emit) {
    print(event.scannedProduct);
    try {
      PedidoProducto productoEnRecepcion = state.pedido!.productos
          .where((element) =>
              element.producto.codigoDeBarras.toString() ==
              event.scannedProduct)
          .first;

      int index = state.pedido!.productos.indexOf(productoEnRecepcion);
      double cantidadOrinal = double.parse(state.tableController[index].text);
      state.tableController[index].text = (cantidadOrinal + 1).toString();
      emit(state.copyWith(
        status: PrepararPedidoStateEnum.LOADED,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: PrepararPedidoStateEnum.ERROR,
          error: "No se encontró el producto"));
    }
  }

  FutureOr<void> onConfirmarPrepararPedido(
      PrepararPedidoEventConfirmarPedido event,
      Emitter<PrepararPedidoState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    Usuario usuario =
        Usuario(email: authData.email, idUsuario: authData.idUsuario);

    List<TextEditingController> tableController = state.tableController;
    List<double> cantidades = List.generate(
        tableController.length,
        (index) => tableController[index].text.isEmpty
            ? 0
            : double.parse(tableController[index].text));

    List<PedidoProducto> productos = state.pedido!.productos;

    Map<String, String> cantidadRecibidaPorProducto = Map<String, String>();
    for (PedidoProducto element in productos) {
      cantidadRecibidaPorProducto[element.producto.idTipoProd.toString()] =
          cantidades[productos.indexOf(element)].toString();
    }
    try {
      await _pedidosService.controlarPedido(
        state.pedido!.idPedido!,
        cantidadRecibidaPorProducto,
        usuario.idUsuario!,
      );
      emit(state.copyWith(status: PrepararPedidoStateEnum.COMPLETED));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(
            status: PrepararPedidoStateEnum.ERROR, error: e.message));
      }
    }
  }
}
