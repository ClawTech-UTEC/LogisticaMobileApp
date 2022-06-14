import 'package:barcode_widget/barcode_widget.dart';
import 'package:clawtech_logistica_app/models/distribuidor.dart';
import 'package:clawtech_logistica_app/models/pedido_producto.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/services/distribuidor_service.dart';
import 'package:clawtech_logistica_app/utils/confirmation_diolog.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:clawtech_logistica_app/views/widgets/tabla_detalle_pedido.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DespacharPedidoScren extends StatefulWidget {
  DespacharPedidoScren({Key? key, required this.pedido}) : super(key: key);
  Pedido pedido;
  @override
  State<DespacharPedidoScren> createState() => _DespacharPedidoScrenState();
}

class _DespacharPedidoScrenState extends State<DespacharPedidoScren> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
      title: 'Despachar Pedido',
      child: CardGeneral(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido: ${widget.pedido.idPedido}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                BarcodeWidget(
                  height: 30,
                  drawText: false,
                  barcode: Barcode.code128(),
                  data: '${widget.pedido.idPedido}',
                )
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Text('Productos: ', style: Theme.of(context).textTheme.titleMedium),
            FittedBox(
                fit: BoxFit.fitWidth,
                child: TablaDetallePedido(pedido: widget.pedido)),
            Divider(
              thickness: 1,
            ),
            Text('Cliente: ${widget.pedido.cliente.nombre}',
                style: Theme.of(context).textTheme.titleMedium),
            FittedBox(
                fit: BoxFit.fitWidth,
                child: DataTable(
                  headingTextStyle: Theme.of(context).textTheme.titleSmall,
                  dataTextStyle: Theme.of(context).textTheme.bodySmall,
                  columns: [
                    DataColumn(
                      label: Text("Fecha:"),
                    ),
                    DataColumn(label: Text("TOTAL:"))
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('${widget.pedido.getFecha}')),
                      DataCell(Text('\$${widget.pedido.total}'))
                    ])
                  ],
                )),
            DropdownSearch<Distribuidor>(
              popupProps: PopupProps.menu(showSearchBox: true),
              validator: (value) =>
                  value == null ? 'Debe seleccionar un Distribuidor' : null,
              dropdownSearchDecoration: InputDecoration(
                labelText: 'Distribuidor',
              ),
              selectedItem: null,
              itemAsString: (item) => item.chofer,
              asyncItems: (searchValue) async {
                return await DistribuidoresService().getDistribuidores();
              },
             
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    confirmarcionDiolog(
                      context: context, 
                      title: 'Confirmar Despacho',
                      onConfirm: (){}
                    );
                  })
            ])
          ])),
    );
  }
}
