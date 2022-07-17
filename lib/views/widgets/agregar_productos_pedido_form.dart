import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:clawtech_logistica_app/models/producto.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/services/stock_service.dart';
import 'package:clawtech_logistica_app/view_model/crear_pedido_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/events/crear_pedido_events.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AgregarProductosPedidoForm extends StatefulWidget {
  const AgregarProductosPedidoForm({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.viewModel,
    required TextEditingController cantidadController,
  })  : _formKey = formKey,
        _cantidadController = cantidadController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final CrearPedidoViewModel viewModel;
  final TextEditingController _cantidadController;

  @override
  State<AgregarProductosPedidoForm> createState() =>
      _AgregarProductosPedidoFormState();
}

class _AgregarProductosPedidoFormState
    extends State<AgregarProductosPedidoForm> {
  Producto? _producto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: double.maxFinite,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: widget._formKey,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: DropdownSearch<Producto>(
                          popupProps: PopupProps.menu(showSearchBox: true),
                          validator: (value) => value == null
                              ? 'Debe seleccionar un Producto'
                              : null,
                          dropdownSearchDecoration: InputDecoration(
                              labelText: 'Producto',
                              icon: IconButton(
                                  icon: Icon(CupertinoIcons.barcode, size: 48),
                                  onPressed: () async {
                                    String barcodeScannerResult =
                                        await BarcodeScanner.scan(
                                            options:
                                                ScanOptions(strings: const {
                                      "cancel": "Cancelar",
                                      "flash_on": "Flash",
                                      "flash_off": "Flash",
                                    })).then((value) => value.rawContent);
                                    bool encontrado = false;
                                    widget.viewModel.state.productos
                                        .forEach((element) {
                                      if (element.tipoProducto.codigoDeBarras
                                              .toString() ==
                                          barcodeScannerResult) {
                                        print(
                                            "Producto" + barcodeScannerResult);
                                        _producto = element;
                                        setState(() {});
                                        widget.viewModel.add(
                                            CrearPedidoEventSeleccionarProducto(
                                                producto: element));
                                        encontrado = true;
                                      }
                                    });

                                    if (!encontrado) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          content:
                                              Text('No se encontro producto'),
                                        ),
                                      );
                                    }
                                  })),
                          onChanged: (x) {
                            widget.viewModel.add(
                                CrearPedidoEventSeleccionarProducto(
                                    producto: x as Producto));
                          },
                          selectedItem: _producto,
                          itemAsString: (item) => item.tipoProducto.nombre,
                          asyncItems: (searchValue) async {
                            return searchValue.isNotEmpty
                                ? await StockService()
                                    .searchProductStockByNameOrCodigoDeBarras(
                                        searchValue, int.tryParse(searchValue))
                                : widget.viewModel.state.productos;
                          },
                        ),
                      ),
                    ),
                    Text(
                        "Disponible: ${widget.viewModel.state.productoSeleccionado?.cantidadDisponible.toString() ?? ""}",
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextFormField(
                      controller: widget._cantidadController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                      ),
                      onChanged: (value) {
                        if (double.parse(value) >
                            widget.viewModel.state.productoSeleccionado!
                                .cantidadDisponible) {
                          widget._cantidadController.text = widget.viewModel
                              .state.productoSeleccionado!.cantidadDisponible
                              .toString();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una cantidad';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (widget._formKey.currentState!.validate()) {
                            widget.viewModel
                                .add(CrearPedidoEventAgregarProducto(
                              producto:
                                  widget.viewModel.state.productoSeleccionado!,
                              cantidad:
                                  int.parse(widget._cantidadController.text),
                            ));
                          }
                        },
                        child: Text("Agregar Producto")),
                    FittedBox(
                      child: _createPedidoProductsDataTable(
                          widget.viewModel.state.cantidadPorProducto),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DataTable _createPedidoProductsDataTable(
  Map<Producto, double> productos,
) {
  return DataTable(
      columns: _createPedidoProductsColumns(),
      rows: _createPedidoProductsRows(productos));
}

List<DataColumn> _createPedidoProductsColumns() {
  return [
    DataColumn(label: Text('Producto')),
    DataColumn(label: Text('Cantidad')),
    DataColumn(label: Text('Precio'))
  ];
}

List<DataRow> _createPedidoProductsRows(Map<Producto, double> productos) {
  List<DataRow> list = [];

  productos.forEach((producto, cantidad) => list.add(DataRow(
        cells: [
          DataCell(Text(producto.tipoProducto.nombre)),
          DataCell(Text(cantidad.toString())),
          DataCell(Text(producto.tipoProducto.precioDeVenta.toString()))
        ],
      )));
  return list;
}
