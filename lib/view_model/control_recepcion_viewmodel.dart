import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/recepcion_service.dart';
import 'package:clawtech_logistica_app/view_model/events/controlar_recepcion_events.dart';
import 'package:clawtech_logistica_app/view_model/states/controlar_recepcion_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlRecepcionViewModel
    extends Bloc<ControlRecepcionEvent, ControlRecepcionState> {
  ControlRecepcionViewModel()
      : super(
            ControlRecepcionState(status: ControlRecepcionStateEnum.INITIAL)) {
    on<ControlRecepcionEventLoad>(onLoad);
    on<ControlRecepcionEventAddProducto>(onAddProducto);
    on<ControlRecepcionEventCompleted>(onCompleted);
    on<ControlRecepcionEventCompletedWithDiferences>(onCompletedWithDiferences);
  }

  RecepcionService _recepcionService = RecepcionService();

  FutureOr<void> onLoad(
      ControlRecepcionEventLoad event, Emitter<ControlRecepcionState> emit) {
    Map<RecepcionProducto, double> cantidadRecividaPorProducto =
        Map<RecepcionProducto, double>();

    event.recepcion.productos.forEach((producto) {
      cantidadRecividaPorProducto[producto] = 0;
    });

    List<TextEditingController> tableController = List.generate(
        event.recepcion.productos.length,
        (i) => new TextEditingController(text: "0"));

    emit(state.copyWith(
      status: ControlRecepcionStateEnum.LOADED,
      recepcion: event.recepcion,
      tableController: tableController,
    ));
  }

  FutureOr<void> onAddProducto(ControlRecepcionEventAddProducto event,
      Emitter<ControlRecepcionState> emit) {
    print(event.scannedProduct);
    try {
      RecepcionProducto productoEnRecepcion = state.recepcion!.productos
          .where((element) =>
              element.producto.codigoDeBarras.toString() ==
              event.scannedProduct)
          .first;

      int index = state.recepcion!.productos.indexOf(productoEnRecepcion);
      double cantidadOrinal = double.parse(state.tableController[index].text);
      state.tableController[index].text = (cantidadOrinal + 1).toString();
      emit(state.copyWith(
        status: ControlRecepcionStateEnum.PRODUCTOAGREGADO,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: ControlRecepcionStateEnum.ERROR,
          error: "No se encontró el producto"));
    }
  }

  FutureOr<void> onCompleted(ControlRecepcionEventCompleted event,
      Emitter<ControlRecepcionState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    Usuario usuario =
        Usuario(email: authData.email, idUsuario: authData.idUsuario);

    List<TextEditingController> tableController = state.tableController;
    List<double> cantidades = List.generate(
        tableController.length,
        (index) => tableController[index].text.isEmpty
            ? 0
            : double.tryParse(tableController[index].text)??0.0);

    List<RecepcionProducto> productos = state.recepcion!.productos;

    Map<String, String> cantidadRecibidaPorProducto = Map<String, String>();
    for (RecepcionProducto element in productos) {
      cantidadRecibidaPorProducto[element.producto.idTipoProd.toString()] =
          cantidades[productos.indexOf(element)].toString();
    }
    try {
      await _recepcionService.controlarRecepcion(
          state.recepcion!.idRecepcion!,
          cantidadRecibidaPorProducto,
          usuario.idUsuario!,
          event.controlarDiferencias);
      emit(state.copyWith(status: ControlRecepcionStateEnum.COMPLETED));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(
            status: ControlRecepcionStateEnum.ERROR, error: e.message));
      }
    }
  }

  FutureOr<void> onCompletedWithDiferences(
      ControlRecepcionEventCompletedWithDiferences event,
      Emitter<ControlRecepcionState> emit) {}
}
