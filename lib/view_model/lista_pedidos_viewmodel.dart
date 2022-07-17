import 'dart:async';

import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListadoPedidosViewModel
    extends Bloc<ListadoPedidosEvent, ListadoPedidosState> {
  ListadoPedidosViewModel({
    required this.pedidosService,
  }) : super(ListadoPedidosState()) {
    on<LoadListadoPedidos>(loadPedidos);
    on<FilterListadoPedidos>(filterPedidos);
  }
  final PedidosService pedidosService;

  loadPedidos(
      LoadListadoPedidos event, Emitter<ListadoPedidosState> emit) async {
    List<Pedido> pedidos = await pedidosService.getPedidos();
    pedidos = pedidos.reversed.toList();
    emit(state.copyWith(
        pedidos: pedidos, state: ListadoPedidosStateEnum.loaded));
  }

  FutureOr<void> filterPedidos(
      FilterListadoPedidos event, Emitter<ListadoPedidosState> emit) async {
    List<Pedido> pedidos =
        await pedidosService.getPedidos(); //TODO: obtener desde la api
            pedidos = pedidos.reversed.toList();

    if (event.filterString.isNotEmpty) {
      pedidos = pedidos
          .where((pedido) =>
              pedido.idPedido.toString().contains(event.filterString))
          .toList();
    }
    emit(state.copyWith(
        pedidos: pedidos, state: ListadoPedidosStateEnum.loaded));
  }
}

enum ListadoPedidosStateEnum {
  loading,
  loaded,
  selected,
  error,
}

class ListadoPedidosState {
  ListadoPedidosState(
      {this.state = ListadoPedidosStateEnum.loading,
      this.pedidos = const [],
      this.selectedPedido = null});

  ListadoPedidosStateEnum state;
  List<Pedido> pedidos;
  Pedido? selectedPedido;

  ListadoPedidosState copyWith({
    ListadoPedidosStateEnum? state,
    List<Pedido>? pedidos,
    Pedido? selectedPedido,
  }) {
    return ListadoPedidosState(
      state: state ?? this.state,
      pedidos: pedidos ?? this.pedidos,
      selectedPedido: selectedPedido ?? this.selectedPedido,
    );
  }
}

abstract class ListadoPedidosEvent {
  ListadoPedidosEvent();
}

class LoadListadoPedidos extends ListadoPedidosEvent {
  LoadListadoPedidos();
}

class FilterListadoPedidos extends ListadoPedidosEvent {
  String filterString;
  FilterListadoPedidos(this.filterString);
}
