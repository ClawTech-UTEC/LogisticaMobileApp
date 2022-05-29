import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoRecepcionesViewModel
    extends Bloc<ListadoRecepcionesEvent, ListadoRecepcionesState> {
  ListadoRecepcionesViewModel({
    required this.recepcionService,
  }) : super(ListadoRecepcionesState()) {
    on<LoadListadoRecepciones>(loadRecepciones);
  }
  final RecepcionService recepcionService;

  loadRecepciones(LoadListadoRecepciones event,
      Emitter<ListadoRecepcionesState> emit) async {
    List<Recepcion> recepciones = await recepcionService.getRecepciones();
    emit(state.copyWith(
        recepciones: recepciones, state: ListadoRecepcionesStateEnum.loaded));
  }
}

enum ListadoRecepcionesStateEnum {
  loading,
  loaded,
  selected,
  error,
}

class ListadoRecepcionesState {
  ListadoRecepcionesState(
      {this.state = ListadoRecepcionesStateEnum.loading,
      this.recepciones = const [],
      this.selectedRecepcion = null});

  ListadoRecepcionesStateEnum state;
  List<Recepcion> recepciones;
  Recepcion? selectedRecepcion;

  ListadoRecepcionesState copyWith({
    ListadoRecepcionesStateEnum state = ListadoRecepcionesStateEnum.loading,
    List<Recepcion> recepciones = const [],
    Recepcion? selectedRecepcion,
  }) {
    return ListadoRecepcionesState(
      state: state ?? this.state,
      recepciones: recepciones ?? this.recepciones,
      selectedRecepcion: selectedRecepcion ?? this.selectedRecepcion,
    );
  }
}

abstract class ListadoRecepcionesEvent {
  ListadoRecepcionesEvent();
}

class LoadListadoRecepciones extends ListadoRecepcionesEvent {
  LoadListadoRecepciones();
}
