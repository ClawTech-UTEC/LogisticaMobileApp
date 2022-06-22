import 'dart:async';
import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/view_model/events/despachar_pedido_events.dart';
import 'package:clawtech_logistica_app/view_model/states/despachar_pedido_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DespacharPedidoViewModel
    extends Bloc<DespacharPedidoEvent, DespacharPedidoState> {
  DespacharPedidoViewModel()
      : super(DespacharPedidoState(status: DespacharPedidoStateEnum.INITIAL)) {
    on<DespacharPedidoEventConfirmarPedido>(onConfirmarDespacharPedido);
    on<DespacharPedidoEventLoad>(onLoadDespacharPedido);
  }

  PedidosService _pedidosService = PedidosService();

  FutureOr<void> onLoadDespacharPedido(
      DespacharPedidoEventLoad event, Emitter<DespacharPedidoState> emit) {
    emit(state.copyWith(
      status: DespacharPedidoStateEnum.LOADED,
      pedido: event.pedido,   
    ));
  }

  FutureOr<void> onAgregarProducto(DespacharPedidoEventAgregarProducto event,
      Emitter<DespacharPedidoState> emit) {
    try {
      emit(state.copyWith(
        status: DespacharPedidoStateEnum.LOADED,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: DespacharPedidoStateEnum.ERROR,
          error: "No se encontró el producto"));
    }
  }

  FutureOr<void> onConfirmarDespacharPedido(
      DespacharPedidoEventConfirmarPedido event,
      Emitter<DespacharPedidoState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    Usuario usuario =
        Usuario(email: authData.email, idUsuario: authData.idUsuario);

  
    try {
      await _pedidosService.despacharPedido(
        state.pedido!.idPedido!,
        
        usuario.idUsuario!,
        event.distribuidor.idDistribu!,
      );
      emit(state.copyWith(status: DespacharPedidoStateEnum.COMPLETED));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(
            status: DespacharPedidoStateEnum.ERROR, error: e.message));
      }
    }
  }
}
