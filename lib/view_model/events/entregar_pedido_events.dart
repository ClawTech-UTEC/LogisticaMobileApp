
import 'package:clawtech_logistica_app/models/pedidos.dart';

abstract class EntregarPedidoEvent {}

class EntregarPedidoEventAgregarProducto extends EntregarPedidoEvent {
}

class EntregarPedidoEventConfirmarPedido extends EntregarPedidoEvent {
  EntregarPedidoEventConfirmarPedido();
}

class EntregarPedidoEventLoad extends EntregarPedidoEvent {
  final Pedido pedido;
  EntregarPedidoEventLoad(this.pedido);
}
