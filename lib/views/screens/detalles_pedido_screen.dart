import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/view_model/detalle_pedido_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/widgets/card_detalles_pedido.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetallePedidoScreen extends StatefulWidget {
  DetallePedidoScreen({Key? key, required Pedido this.pedido})
      : super(key: key);
  Pedido pedido;
  @override
  State<DetallePedidoScreen> createState() => _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
  final DetallePedidoViewModel _detallePedidoViewModel =
      DetallePedidoViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _detallePedidoViewModel.add(LoadPedidoEvent(widget.pedido));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: "Detalle Pedido",
        child: BlocBuilder(
            bloc: _detallePedidoViewModel,
            builder: (context, DetallePedidoState state) {
            return  CardDetallePedido(pedido: widget.pedido);
            }));
  }
}
