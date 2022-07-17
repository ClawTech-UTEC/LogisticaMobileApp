import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDownConLectorCodigoDeBarras extends StatefulWidget {
  DropDownConLectorCodigoDeBarras({
    Key? key,
    required this.selectedTipoProducto,
    required this.tipoProductos,
    this.onResult,
  }) : super(key: key);
  TipoProducto? selectedTipoProducto;
  List<TipoProducto> tipoProductos;
  Function(TipoProducto result)? onResult;
  @override
  State<DropDownConLectorCodigoDeBarras> createState() =>
      _DropDownConLectorCodigoDeBarrasState();
}

class _DropDownConLectorCodigoDeBarrasState
    extends State<DropDownConLectorCodigoDeBarras> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<TipoProducto>(
      selectedItem: widget.selectedTipoProducto,
      popupProps: PopupProps.menu(showSearchBox: true),
      validator: (value) =>
          value == null ? 'Debe seleccionar un Producto' : null,
      dropdownSearchDecoration: InputDecoration(
          labelText: 'Producto',
          icon: IconButton(
              icon: Icon(CupertinoIcons.barcode, size: 48),
              onPressed: () async {
                String barcodeScannerResult = await BarcodeScanner.scan(
                    options: ScanOptions(strings: const {
                  "cancel": "Cancelar",
                  "flash_on": "Flash",
                  "flash_off": "Flash",
                })).then((value) => value.rawContent);
                bool encontrado = false;

                widget.tipoProductos.forEach((element) {
                  if (element.codigoDeBarras.toString() ==
                      barcodeScannerResult) {
                    print("Producto" + barcodeScannerResult);

                    widget.selectedTipoProducto = element;
                    setState(() {});
                    widget.onResult != null
                        ? widget.onResult!(widget.selectedTipoProducto!)
                        : null;
                    encontrado = true;
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).accentColor,
                        content: Text('Producto Encontrado'),
                      ),
                    );
                    return;
                  }
                });

                if (!encontrado) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).accentColor,
                      content: Text('No se encontro producto'),
                    ),
                  );
                }
              })),
      onChanged: (x) {
        print("Producto" + x.toString());
        widget.selectedTipoProducto = x as TipoProducto;
        widget.onResult!(widget.selectedTipoProducto!);
      },
      items: widget.tipoProductos,
      itemAsString: (item) => item.nombre,
    );
  }
}
