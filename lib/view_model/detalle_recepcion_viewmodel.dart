import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetalleRecepcionViewModel
    extends Bloc<DetalleRecepcionEvent, DetalleRecepcionState> {
  DetalleRecepcionViewModel()
      : super(DetalleRecepcionState(DetalleRecepcionStateEnum.loading, null)) {
    on<LoadRecepcionEvent>(onLoadRecepcion);
  }

  onLoadRecepcion(
      LoadRecepcionEvent event, Emitter<DetalleRecepcionState> emit) async {
    emit(state.copyWith(
        state: DetalleRecepcionStateEnum.loaded, recepcion: event.recepcion));
  }
}

abstract class DetalleRecepcionEvent {
  DetalleRecepcionEvent();
}

class LoadRecepcionEvent extends DetalleRecepcionEvent {
  Recepcion recepcion;
  LoadRecepcionEvent(this.recepcion);
}

class CancelarRecepcionEvent extends DetalleRecepcionEvent {
  CancelarRecepcionEvent();
}

class ModificarRecepcionEvent extends DetalleRecepcionEvent {
  ModificarRecepcionEvent();
}

class DetalleRecepcionState {
  DetalleRecepcionState(this.state, this.recepcion);
  DetalleRecepcionStateEnum state;
  Recepcion? recepcion;

  DetalleRecepcionState copyWith({
    DetalleRecepcionStateEnum state = DetalleRecepcionStateEnum.loading,
    Recepcion? recepcion,
  }) {
    return DetalleRecepcionState(
      state ?? this.state,
      recepcion ?? this.recepcion,
    );
  }
}

enum DetalleRecepcionStateEnum {
  loading,
  loaded,
  error,
}
