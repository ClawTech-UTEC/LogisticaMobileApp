import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:flutter/material.dart';

class PrepararPedidoState {
  PrepararPedidoStateEnum status;
  Pedido? pedido;
  String? error;
  List<TextEditingController> tableController;

  PrepararPedidoState({
    this.status = PrepararPedidoStateEnum.INITIAL,
    this.pedido,
    this.error,
    this.tableController = const [],
  });

  PrepararPedidoState copyWith({
    PrepararPedidoStateEnum? status,
    Pedido? pedido,
    String? error,
    List<TextEditingController>? tableController,
  }) {
    return PrepararPedidoState(
        status: status ?? this.status,
        pedido: pedido ?? this.pedido,
        error: error ?? this.error,
        tableController: tableController ?? this.tableController);
  }
}

enum PrepararPedidoStateEnum { INITIAL, LOADED, ERROR, COMPLETED }
