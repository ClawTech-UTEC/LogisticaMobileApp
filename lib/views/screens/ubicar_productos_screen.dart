import 'package:clawtech_logistica_app/models/deposito.dart';
import 'package:clawtech_logistica_app/models/espacio.dart';
import 'package:clawtech_logistica_app/models/pasillo.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/deposito_service.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UbicarProductoScreen extends StatefulWidget {
  UbicarProductoScreen({Key? key, required this.recepcion}) : super(key: key);
  Recepcion recepcion;
  DepositoService depositoService = new DepositoService();
  @override
  State<UbicarProductoScreen> createState() => _UbicarProductoScreenState();
}

class _UbicarProductoScreenState extends State<UbicarProductoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cantidadController = TextEditingController();
  RecepcionProducto? _selectedTipoProducto;
  Future<Deposito>? _deposito;
  double cantidadMaxima = 0;
  Espacio? _selectedEspacio;
  @override
  void initState() {
    super.initState();
    _deposito = widget.depositoService.getDepositoById(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _deposito,
      builder: (context, snapshot) {
        print(snapshot.data);

        if (snapshot.data == null) {
          return LoadingPage();
        }
        Deposito deposito = snapshot.data as Deposito;
        print(deposito.toJson());
        return ScaffoldGeneralBackground(
            title: "Ubicar Productos",
            child: CardGeneral(
                child: Column(children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownSearch<RecepcionProducto>(
                        popupProps: PopupProps.menu(showSearchBox: true),
                        validator: (value) => value == null
                            ? 'Debe seleccionar un Provedor'
                            : null,
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Producto',
                        ),
                        selectedItem: _selectedTipoProducto,
                        itemAsString: (item) => item.producto.nombre,
                        items: widget.recepcion.productos,
                        onChanged: (x) {
                          _selectedTipoProducto = x;
                          cantidadMaxima = x!.cantidad;
                        },
                      ),
                      TextFormField(
                        controller: _cantidadController,
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (double.parse(value) > cantidadMaxima) {
                              _cantidadController.text =
                                  cantidadMaxima.toString();
                            }
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese una cantidad';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // width: 500,
                        height: 200,
                        child: GridView.count(
                            scrollDirection: Axis.vertical,
                            crossAxisCount: deposito.pasillos![0].espacio!.length,
                            children:
                                _buildGridTiles(deposito)),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: Text("Agregar Producto"))
                    ],
                  )),
            ])));
      },
    );
  }

  List<Widget> _buildGridTiles(Deposito deposito) {
    List<Widget> list = [];

    for (Pasillo pasillo in deposito.pasillos!) {
      for (Espacio espacio in pasillo.espacio!) {
        list.add(ListTile(
          leading: Text(pasillo.nomPasillo + " - " + espacio.nomEspacio),
          title: Radio<Espacio>(
            value: espacio,
            groupValue: _selectedEspacio,
            onChanged: (Espacio? value) {
              _selectedEspacio = value!;
              setState(() {
                
              });
            },
          ),
        ));
      }
    }

    return list;
  }
}


