import 'dart:async';
import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/view_model/events/controlar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/events/preparar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/controlar_pedido_state.dart';
import 'package:clawtech_logistica_app/view_model/states/preparar_pedido_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlarPedidoViewModel
    extends Bloc<ControlarPedidoEvent, ControlarPedidoState> {
  ControlarPedidoViewModel()
      : super(ControlarPedidoState(status: ControlarPedidoStateEnum.INITIAL)) {
    on<ControlarPedidoEventAgregarProducto>(onAgregarProducto);
    on<ControlarPedidoEventConfirmarPedido>(onConfirmarControlarPedido);
    on<ControlarPedidoEventLoad>(onLoadControlarPedido);
  }

  PedidosService _pedidosService = PedidosService();

  FutureOr<void> onLoadControlarPedido(
      ControlarPedidoEventLoad event, Emitter<ControlarPedidoState> emit) {
    Map<PedidoProducto, double> cantidadRecividaPorProducto =
        Map<PedidoProducto, double>();

    event.pedido.productos.forEach((producto) {
      cantidadRecividaPorProducto[producto] = 0;
    });

    List<TextEditingController> tableController = List.generate(
        event.pedido.productos.length,
        (i) => new TextEditingController(text: "0"));

    emit(state.copyWith(
      status: ControlarPedidoStateEnum.LOADED,
      pedido: event.pedido,
      tableController: tableController,
    ));
  }

  FutureOr<void> onAgregarProducto(ControlarPedidoEventAgregarProducto event,
      Emitter<ControlarPedidoState> emit) {
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
        status: ControlarPedidoStateEnum.PRODUCTOAGREGADO,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: ControlarPedidoStateEnum.ERROR,
          error: "No se encontró el producto"));
    }
  }

  FutureOr<void> onConfirmarControlarPedido(
      ControlarPedidoEventConfirmarPedido event,
      Emitter<ControlarPedidoState> emit) async {
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
      emit(state.copyWith(status: ControlarPedidoStateEnum.COMPLETED));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(
            status: ControlarPedidoStateEnum.ERROR, error: e.message));
      }
    }
  }
}
