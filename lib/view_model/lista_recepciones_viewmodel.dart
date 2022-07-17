import 'dart:async';

import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoRecepcionesViewModel
    extends Bloc<ListadoRecepcionesEvent, ListadoRecepcionesState> {
  ListadoRecepcionesViewModel({
    required this.recepcionService,
  }) : super(ListadoRecepcionesState()) {
    on<LoadListadoRecepciones>(loadRecepciones);
    on<FilterListadoRecepciones>(filterRecepciones);
  }
  final RecepcionService recepcionService;

  loadRecepciones(LoadListadoRecepciones event,
      Emitter<ListadoRecepcionesState> emit) async {
    List<Recepcion> recepciones = await recepcionService.getRecepciones();
        recepciones = recepciones.reversed.toList();

    emit(state.copyWith(
        recepciones: recepciones, state: ListadoRecepcionesStateEnum.loaded));
  }

  FutureOr<void> filterRecepciones(FilterListadoRecepciones event,
      Emitter<ListadoRecepcionesState> emit) async {
    List<Recepcion> recepciones = await recepcionService.getRecepciones();
    ; //TODO: obtener desde la api
    recepciones = recepciones.reversed.toList();

    print(event.filterString);
    for (var element in recepciones) {
      print("-------------");
      print(element.idRecepcion);
      print("-------------");
    }
    if (event.filterString.isNotEmpty) {
      print("-------------");
      recepciones = recepciones
          .where((recepcion) =>
              recepcion.idRecepcion.toString().contains(event.filterString) ||
              recepcion.estadoRecepcion.last.tipoEstado
                  .toString()
                  .contains(event.filterString))
          .toList();
    }
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
    ListadoRecepcionesStateEnum? state,
    List<Recepcion>? recepciones,
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

class FilterListadoRecepciones extends ListadoRecepcionesEvent {
  String filterString;
  FilterListadoRecepciones(this.filterString);
}
