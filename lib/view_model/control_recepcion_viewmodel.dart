import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlRecepcionViewModel
    extends Bloc<ControlRecepcionEvent, ControlRecepcionState> {
  ControlRecepcionViewModel()
      : super(
            ControlRecepcionState(status: ControlRecepcionStateEnum.INITIAL)) {}
}

class ControlRecepcionState {
  ControlRecepcionStateEnum status;
  Recepcion? recepcion;
  Map<RecepcionProducto, int> cantidadRecividaPorProducto =
      Map<RecepcionProducto, int>();

  ControlRecepcionState(
      {this.status = ControlRecepcionStateEnum.INITIAL,
      this.recepcion,
      this.cantidadRecividaPorProducto = const {}});

  ControlRecepcionState copyWith({
    ControlRecepcionStateEnum status = ControlRecepcionStateEnum.INITIAL,
    Recepcion? recepcion,
    Map<RecepcionProducto, int> cantidadRecividaPorProducto = const {},
  }) {
    return ControlRecepcionState(
      status: status ?? this.status,
      recepcion: recepcion ?? this.recepcion,
      cantidadRecividaPorProducto:
          cantidadRecividaPorProducto ?? this.cantidadRecividaPorProducto,
    );
  }
}

enum ControlRecepcionStateEnum { INITIAL, LOADED, ERROR, COMPLETED }

abstract class ControlRecepcionEvent {}

class ControlRecepcionEventLoaded extends ControlRecepcionEvent {
  final Recepcion recepcion;
  ControlRecepcionEventLoaded({required this.recepcion});
}

class ControlRecepcionEventModifyTable extends ControlRecepcionEvent {
  final Recepcion recepcion;
  Map<RecepcionProducto, int> cantidadRecividaPorProducto;
  ControlRecepcionEventModifyTable(
      {required this.recepcion, required this.cantidadRecividaPorProducto});
}

class ControlRecepcionEventCompleted extends ControlRecepcionEvent {
  final Recepcion recepcion;
  ControlRecepcionEventCompleted({required this.recepcion});
}
