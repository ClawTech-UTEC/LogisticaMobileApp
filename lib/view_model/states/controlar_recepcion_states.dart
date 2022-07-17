import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:flutter/cupertino.dart';

class ControlRecepcionState {
  ControlRecepcionStateEnum status;
  Recepcion? recepcion;

  List<TextEditingController> tableController;

  String? error;
  ControlRecepcionState({
    this.status = ControlRecepcionStateEnum.INITIAL,
    this.recepcion,
    this.error,
    this.tableController = const [],
  });

  ControlRecepcionState copyWith({
    ControlRecepcionStateEnum? status = ControlRecepcionStateEnum.INITIAL,
    Recepcion? recepcion,
    String? error = "",
    List<TextEditingController>? tableController,
  }) {
    return ControlRecepcionState(
        status: status ?? this.status,
        recepcion: recepcion ?? this.recepcion,
        tableController: tableController ?? this.tableController,
        error: error);
  }
}

enum ControlRecepcionStateEnum { INITIAL, LOADED, ERROR, COMPLETED, PRODUCTOAGREGADO }
