import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:flutter/material.dart';

class ControlarPedidoState {
  ControlarPedidoStateEnum status;
  Pedido? pedido;
  String? error;
  List<TextEditingController> tableController;

  ControlarPedidoState({
    this.status = ControlarPedidoStateEnum.INITIAL,
    this.pedido,
    this.error,
    this.tableController = const [],
  });

  ControlarPedidoState copyWith({
    ControlarPedidoStateEnum? status,
    Pedido? pedido,
    String? error,
    List<TextEditingController>? tableController,
  }) {
    return ControlarPedidoState(
        status: status ?? this.status,
        pedido: pedido ?? this.pedido,
        error: error ?? this.error,
        tableController: tableController ?? this.tableController);
  }
}

enum ControlarPedidoStateEnum { INITIAL, LOADED, ERROR, COMPLETED }
