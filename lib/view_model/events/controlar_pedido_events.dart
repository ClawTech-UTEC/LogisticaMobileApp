import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';

abstract class ControlarPedidoEvent {}

class ControlarPedidoEventAgregarProducto extends ControlarPedidoEvent {
  final String scannedProduct;
  ControlarPedidoEventAgregarProducto(this.scannedProduct);
}

class ControlarPedidoEventConfirmarPedido extends ControlarPedidoEvent {
  ControlarPedidoEventConfirmarPedido();
}

class ControlarPedidoEventLoad extends ControlarPedidoEvent {
  final Pedido pedido;
  ControlarPedidoEventLoad(this.pedido);
}
