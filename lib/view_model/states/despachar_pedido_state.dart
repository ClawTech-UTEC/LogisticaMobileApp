import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:flutter/material.dart';

class DespacharPedidoState {
  DespacharPedidoStateEnum status;
  Pedido? pedido;
  Distribuidor? distribuidor;
  String? error;

  DespacharPedidoState({
    this.status = DespacharPedidoStateEnum.INITIAL,
    this.pedido,
    this.error,
    this.distribuidor
  });

  DespacharPedidoState copyWith({
    DespacharPedidoStateEnum? status,
    Pedido? pedido,
    String? error,
    Distribuidor? distribuidor
  }) {
    return DespacharPedidoState(
        status: status ?? this.status,
        pedido: pedido ?? this.pedido,
        distribuidor : distribuidor ?? this.distribuidor,
        error: error ?? this.error);
  }
}

enum DespacharPedidoStateEnum { INITIAL, LOADED, ERROR, COMPLETED }
