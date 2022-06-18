import 'dart:async';
import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/view_model/events/entregar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/entregar_pedido_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntregarPedidoViewModel
    extends Bloc<EntregarPedidoEvent, EntregarPedidoState> {
  EntregarPedidoViewModel()
      : super(EntregarPedidoState(status: EntregarPedidoStateEnum.INITIAL)) {
    on<EntregarPedidoEventConfirmarPedido>(onConfirmarEntregarPedido);
    on<EntregarPedidoEventLoad>(onLoadEntregarPedido);
  }

  PedidosService _pedidosService = PedidosService();

  FutureOr<void> onLoadEntregarPedido(
      EntregarPedidoEventLoad event, Emitter<EntregarPedidoState> emit) {
    emit(state.copyWith(
      status: EntregarPedidoStateEnum.LOADED,
      pedido: event.pedido,
    ));
  }

  FutureOr<void> onAgregarProducto(EntregarPedidoEventAgregarProducto event,
      Emitter<EntregarPedidoState> emit) {
    try {
      emit(state.copyWith(
        status: EntregarPedidoStateEnum.LOADED,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: EntregarPedidoStateEnum.ERROR,
          error: "No se encontró el producto"));
    }
  }

  FutureOr<void> onConfirmarEntregarPedido(
      EntregarPedidoEventConfirmarPedido event,
      Emitter<EntregarPedidoState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    Usuario usuario =
        Usuario(email: authData.email, idUsuario: authData.idUsuario);

    try {
      await _pedidosService.entregarPedido(
        state.pedido!.idPedido!,
        usuario.idUsuario!,
      );
      print( "Pedido entregado");
      emit(state.copyWith(status: EntregarPedidoStateEnum.COMPLETED));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(
            status: EntregarPedidoStateEnum.ERROR, error: e.message));
      }
    }
  }
}
