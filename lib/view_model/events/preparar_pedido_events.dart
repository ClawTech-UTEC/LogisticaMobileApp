import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/producto.dart';

abstract class PrepararPedidoEvent {}

class PrepararPedidoEventAgregarProducto extends PrepararPedidoEvent {
  final String scannedProduct;
  PrepararPedidoEventAgregarProducto(this.scannedProduct);
}

class PrepararPedidoEventConfirmarPedido extends PrepararPedidoEvent {
  PrepararPedidoEventConfirmarPedido();
}

class PrepararPedidoEventLoad extends PrepararPedidoEvent {
  final Pedido pedido;
  PrepararPedidoEventLoad(this.pedido);
}
