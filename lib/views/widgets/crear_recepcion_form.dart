import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/provedor_service.dart';
import 'package:clawtech_logistica_app/view_model/crear_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/events/crear_recepcion_events.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CrearRecepcionForm extends StatefulWidget {
  CrearRecepcionForm({
    this.tipoProductos = const [],
    this.provedores = const [],
    required this.viewModel,
    Key? key,
  }) : super(key: key);
  List<TipoProducto> tipoProductos;

  List<Provedor> provedores;

  final CrearRecepcionViewModel viewModel;

  @override
  State<CrearRecepcionForm> createState() => _CrearRecepcionFormState();
}

class _CrearRecepcionFormState extends State<CrearRecepcionForm> {
  final _formKey = GlobalKey<FormState>();

  TipoProducto? _selectedTipoProducto;
  Provedor? _selectedProvedor;
  TextEditingController _cantidadController = TextEditingController();
  Key _key = UniqueKey();
  late String _estado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Hero(
              tag: "recepciones_card",
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              DropdownSearch<Provedor>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true
                                ),
                                validator: (value) => value == null
                                    ? 'Debe seleccionar un Provedor'
                                    : null,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: 'Provedor',
                                ),
                                selectedItem:
                                    widget.viewModel.state.selectedProvedor,
                                itemAsString: (item) => item.nombreProv,
                                asyncItems: (searchValue) async {
                                  return searchValue.isNotEmpty
                                      ? await ProvedorService()
                                          .getProvedoresByName(searchValue)
                                      : widget.provedores;
                                },
                                onChanged: (x) {
                                  if (x ==
                                      widget.viewModel.state.selectedProvedor) {
                                    print("mismo provedor");
                                    return;
                                  } else {
                                    print("nuevo provedor");
                                    _formKey.currentState!.reset();
                                    _selectedProvedor = x as Provedor;
                                    _selectedTipoProducto = null;

                                    widget.viewModel.add(OnCambiarProvedorEvent(
                                        provedor: _selectedProvedor!));
                                  }
                                },
                              ),
                              DropdownButtonFormField(
                                key: _key,
                                validator: (value) => value == null
                                    ? 'Debe seleccionar un Provedor'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Tipo De Producto',
                                ),
                                onChanged: (x) {
                                  _selectedTipoProducto = x as TipoProducto;
                                },
                                value: _selectedTipoProducto,
                                items: widget.tipoProductos
                                    .map((tipoProducto) => DropdownMenuItem(
                                          child: Text(tipoProducto.nombre),
                                          value: tipoProducto,
                                        ))
                                    .toList(),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese una cantidad';
                                  }
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      widget.viewModel.add(AgregarProductoEvent(
                                        _selectedTipoProducto!,
                                        double.parse(_cantidadController.text),
                                      ));
                                    }
                                  },
                                  child: Text("Agregar Producto"))
                            ],
                          )),
                      Divider(),
                      Form(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: ListView.separated(
                              itemBuilder: ((context, index) => ListTile(
                                    title: Text(widget.viewModel.state.recepcion
                                        .productos[index].producto.nombre),
                                    subtitle: Text(widget.viewModel.state
                                        .recepcion.productos[index].cantidad
                                        .toString()),
                                  )),
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: widget
                                  .viewModel.state.recepcion.productos.length),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {
                    widget.viewModel.add(ConfirmarRecepcionEvent());
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text("Crear Recepcion")))),
            )
          ],
        ),
      ),
    );
  }
}
