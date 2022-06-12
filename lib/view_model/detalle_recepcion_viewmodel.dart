import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/services/auth_service.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetalleRecepcionViewModel
    extends Bloc<DetalleRecepcionEvent, DetalleRecepcionState> {
  DetalleRecepcionViewModel()
      : super(DetalleRecepcionState(
            DetalleRecepcionStateEnum.loading, null, null)) {
    on<LoadRecepcionEvent>(onLoadRecepcion);
  }
  RecepcionService recepcionService = new RecepcionService();
  AuthService authService = new AuthService();

  onLoadRecepcion(
      LoadRecepcionEvent event, Emitter<DetalleRecepcionState> emit) async {
    emit(state.copyWith(
        state: DetalleRecepcionStateEnum.loaded, recepcion: event.recepcion));
  }

  onCancelarRecepcion(
      CancelarRecepcionEvent event, Emitter<DetalleRecepcionState> emit) async {
    recepcionService.cancelarRecepcion(
        state.recepcion!.idRecepcion!, await authService.getIdUsuario());

    emit(state.copyWith(state: DetalleRecepcionStateEnum.loaded));
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
  DetalleRecepcionState(this.state, this.recepcion, this.message);
  DetalleRecepcionStateEnum? state;
  Recepcion? recepcion;
  String? message;

  DetalleRecepcionState copyWith({
    DetalleRecepcionStateEnum? state,
    Recepcion? recepcion,
    String? message,
  }) {
    return DetalleRecepcionState(
      state ?? this.state,
      recepcion ?? this.recepcion,
      message ?? this.message,
    );
  }
}

enum DetalleRecepcionStateEnum {
  loading,
  loaded,
  error,
}
