import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:flutter/material.dart';

class EntregarPedidoState {
  EntregarPedidoStateEnum status;
  Pedido? pedido;
  Distribuidor? distribuidor;
  String? error;

  EntregarPedidoState({
    this.status = EntregarPedidoStateEnum.INITIAL,
    this.pedido,
    this.error,
    this.distribuidor
  });

  EntregarPedidoState copyWith({
    EntregarPedidoStateEnum? status,
    Pedido? pedido,
    String? error,
    Distribuidor? distribuidor
  }) {
    return EntregarPedidoState(
        status: status ?? this.status,
        pedido: pedido ?? this.pedido,
        distribuidor : distribuidor ?? this.distribuidor,
        error: error ?? this.error);
  }
}

enum EntregarPedidoStateEnum { INITIAL, LOADED, ERROR, COMPLETED }
