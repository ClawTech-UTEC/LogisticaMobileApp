import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/view_model/crear_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearRecepcionScreen extends StatefulWidget {
  CrearRecepcionScreen({Key? key}) : super(key: key);

  @override
  State<CrearRecepcionScreen> createState() => _CrearRecepcionScreenState();
}

class _CrearRecepcionScreenState extends State<CrearRecepcionScreen> {
  CrearRecepcionViewModel viewModel =
      CrearRecepcionViewModel(productoService: ProductoService());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: viewModel..add(OnStartedEvent()),
        builder: (context, state) {
          if (state is CrearRecepcionInitialState) {
            return LoadingPage();
          } else if (state is CrearRecepcionLoadedState) {
            return CrearRecepcionForm(
                tipoProductos: state.tipoProductos,
                recepcionProductos: state.recepcionProductos,
                viewModel: viewModel);
          } else {
            return LoadingPage();
          }
        });
  }
}

class CrearRecepcionForm extends StatefulWidget {
  CrearRecepcionForm({
    this.tipoProductos = const [],
    this.recepcionProductos = const [],
    required this.viewModel,
    Key? key,
  }) : super(key: key);
  List<TipoProducto> tipoProductos;
  List<RecepcionProducto> recepcionProductos;
  final CrearRecepcionViewModel viewModel;

  @override
  State<CrearRecepcionForm> createState() => _CrearRecepcionFormState();
}

class _CrearRecepcionFormState extends State<CrearRecepcionForm> {
  final _formKey = GlobalKey<FormState>();

  late TipoProducto _selectedTipoProducto;
  TextEditingController _cantidadController = TextEditingController();
  late String _estado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.recepcionProductos.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Recepcion'),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: 'Tipo De Producto',
                                ),
                                onChanged: (x) {
                                  _selectedTipoProducto = x as TipoProducto;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese una cantidad';
                                  }
                                  return null;
                                },
                              ),
                              // DropdownButtonFormField(
                              //   decoration: InputDecoration(
                              //     labelText: 'Estado del producto',
                              //   ),
                              //   onChanged: (x) {_estado = x as String;},
                              //   items: ["Disponible", "Reservado", "No Disponible"]
                              //       .map((e) => DropdownMenuItem(
                              //             child: Text(e),
                              //             value: e,
                              //           ))
                              //       .toList(),
                              // ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      widget.viewModel.add(AgregarProductoEvent(
                                        _selectedTipoProducto,
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
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.separated(
                              itemBuilder: ((context, index) => ListTile(
                                    title: Text(widget
                                        .viewModel
                                        .state
                                        .recepcionProductos[index]
                                        .producto
                                        
                                        .nombre),
                                    subtitle: Text(widget.viewModel.state
                                        .recepcionProductos[index].cantidad
                                        .toString()),
                                  )),
                              separatorBuilder: (context, index) => Divider(),
                              itemCount:
                                  widget.viewModel.state.recepcionProductos.length),
                        ),
                      )
                    ],
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
                  onPressed: (){}, child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Crear Recepcion")))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
