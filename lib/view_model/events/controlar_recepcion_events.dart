import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';

abstract class ControlRecepcionEvent {}

class ControlRecepcionEventLoad extends ControlRecepcionEvent {
  final Recepcion recepcion;
  ControlRecepcionEventLoad({required this.recepcion});
}

class ControlRecepcionEventAddProducto extends ControlRecepcionEvent {
  final String scannedProduct;

  ControlRecepcionEventAddProducto({required this.scannedProduct});
}

class ControlRecepcionEventModifyTable extends ControlRecepcionEvent {
  final Recepcion recepcion;
  Map<RecepcionProducto, double> cantidadRecividaPorProducto;
  ControlRecepcionEventModifyTable(
      {required this.recepcion, required this.cantidadRecividaPorProducto});
}

class ControlRecepcionEventCompleted extends ControlRecepcionEvent {
  final bool controlarDiferencias;
  ControlRecepcionEventCompleted({required this.controlarDiferencias});
}

class ControlRecepcionEventCompletedWithDiferences
    extends ControlRecepcionEvent {
  ControlRecepcionEventCompletedWithDiferences();
}
