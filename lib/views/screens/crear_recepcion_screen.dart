import 'package:clawtech_logistica_app/models/tipo_producto.dart';
import 'package:clawtech_logistica_app/services/producto_service.dart';
import 'package:clawtech_logistica_app/view_model/crear_recepcion_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrearRecepcionScreen extends StatefulWidget {
  CrearRecepcionScreen({Key? key}) : super(key: key);

  @override
  State<CrearRecepcionScreen> createState() => _CrearRecepcionScreenState();
}

class _CrearRecepcionScreenState extends State<CrearRecepcionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: CrearRecepcionViewModel(productoService: ProductoService())
          ..add(OnStartedEvent()),
        builder: (context, state) {
          if (state is CrearRecepcionInitialState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CrearRecepcionLoadedState) {
            return CrearRecepcionForm(tipoProductos: state.tipoProductos);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class CrearRecepcionForm extends StatelessWidget {
  const CrearRecepcionForm({
    this.tipoProductos = const [],
    Key? key,
  }) : super(key: key);
  final List<TipoProducto> tipoProductos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Recepcion'),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                    child: Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Tipo De Producto',
                      ),
                      onChanged: (x) {},
                      items: tipoProductos
                          .map((tipoProducto) => DropdownMenuItem(
                                child: Text(tipoProducto.nombre),
                                value: tipoProducto,
                              ))
                          .toList(),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                      ),
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Estado del producto',
                      ),
                      onChanged: (x) {},
                      items: ["Disponible", "Reservado", "No Disponible"]
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text("Agregar Producto"))
                  ],
                )),
                Divider(),
                Form(child: Column())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
