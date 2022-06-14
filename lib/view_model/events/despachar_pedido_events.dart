import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';

abstract class DespacharPedidoEvent {}

class DespacharPedidoEventAgregarProducto extends DespacharPedidoEvent {
}

class DespacharPedidoEventConfirmarPedido extends DespacharPedidoEvent {
  final Distribuidor distribuidor;
  DespacharPedidoEventConfirmarPedido(this.distribuidor);
}

class DespacharPedidoEventLoad extends DespacharPedidoEvent {
  final Pedido pedido;
  DespacharPedidoEventLoad(this.pedido);
}
