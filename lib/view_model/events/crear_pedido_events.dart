import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/models/producto.dart';

abstract class CrearPedidoEvent {}

class CrearPedidoEventLoad extends CrearPedidoEvent {
  CrearPedidoEventLoad();
}

class CrearPedidoEventSeleccionarProducto extends CrearPedidoEvent {
  final Producto producto;
  CrearPedidoEventSeleccionarProducto({required this.producto});
}

class CrearPedidoEventAgregarProducto extends CrearPedidoEvent {
  final Producto producto;
  final int cantidad;
  CrearPedidoEventAgregarProducto(
      {required this.producto, required this.cantidad});
}

class CrearPedidoEventConfirmarPedido extends CrearPedidoEvent {
  CrearPedidoEventConfirmarPedido();
}

//Termino de agregar productos, pasa a la pantalla de clientes
class CrearPedidoEventConfirmarProductos extends CrearPedidoEvent {
  CrearPedidoEventConfirmarProductos();
}

class CrearPedidoEventConfirmarCliente extends CrearPedidoEvent {
  Cliente cliente;
  CrearPedidoEventConfirmarCliente({required this.cliente});
}
