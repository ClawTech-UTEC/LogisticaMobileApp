import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/services/auth_service.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetallePedidoViewModel
    extends Bloc<DetallePedidoEvent, DetallePedidoState> {
  DetallePedidoViewModel()
      : super(DetallePedidoState(DetallePedidoStateEnum.loading, null)) {
    on<LoadPedidoEvent>(onLoadPedido);
  }
  PedidosService pedidosService = PedidosService();
  AuthService authService = AuthService();

  Future<void> descargarPdfDetallePedido(Pedido pedido) async {
    print("Descargando PDF del pedido ${pedido.idPedido} ");
    await pedidosService.descargarPdfPedido(pedido.idPedido!);
  }

  onLoadPedido(LoadPedidoEvent event, Emitter<DetallePedidoState> emit) async {
    emit(state.copyWith(
      state: DetallePedidoStateEnum.loaded,
      pedido: event.pedido,
    ));
  }

  cancelarPedido(Pedido pedido) async {
    
    print("Cancelando pedido ${pedido.idPedido} ");
    await pedidosService.cancelarPedido(pedido.idPedido!,await authService.getIdUsuario());
  }

  devolverPedido(Pedido pedido) async {
    print("Devolviento pedido ${pedido.idPedido} ");
    await pedidosService.devolverPedido(
        pedido.idPedido!, await authService.getIdUsuario());
  }
  
}

abstract class DetallePedidoEvent {
  DetallePedidoEvent();
}

class LoadPedidoEvent extends DetallePedidoEvent {
  Pedido pedido;
  LoadPedidoEvent(this.pedido);
}

class CancelarPedidoEvent extends DetallePedidoEvent {
  CancelarPedidoEvent();
}

class ModificarPedidoEvent extends DetallePedidoEvent {
  ModificarPedidoEvent();
}

class DetallePedidoState {
  DetallePedidoState(this.state, this.pedido);
  DetallePedidoStateEnum? state;
  Pedido? pedido;

  DetallePedidoState copyWith({
    DetallePedidoStateEnum? state,
    Pedido? pedido,
  }) {
    return DetallePedidoState(
      state ?? this.state,
      pedido ?? this.pedido,
    );
  }
}

enum DetallePedidoStateEnum {
  loading,
  loaded,
  error,
}
