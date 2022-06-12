import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetallePedidoViewModel
    extends Bloc<DetallePedidoEvent, DetallePedidoState> {
  DetallePedidoViewModel()
      : super(DetallePedidoState(DetallePedidoStateEnum.loading, null)) {
    on<LoadPedidoEvent>(onLoadPedido);
  }

  onLoadPedido(
      LoadPedidoEvent event, Emitter<DetallePedidoState> emit) async {
    emit(state.copyWith(
        state: DetallePedidoStateEnum.loaded, pedido: event.pedido));
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
