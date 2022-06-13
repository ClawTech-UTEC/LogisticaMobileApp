import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/services/cliente_service.dart';
import 'package:clawtech_logistica_app/view_model/crear_pedido_viewmodel.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AgregarClientePedidoForm extends StatefulWidget {
  AgregarClientePedidoForm(
      {Key? key,
      required this.formKey,
      required this.viewModel,
      required this.cliente})
      : super(key: key);
  final GlobalKey<FormState> formKey;
  final CrearPedidoViewModel viewModel;
  Cliente cliente;

  @override
  State<AgregarClientePedidoForm> createState() =>
      _AgregarClientePedidoFormState();
}

class _AgregarClientePedidoFormState extends State<AgregarClientePedidoForm> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _razonSocialController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _documentoController = TextEditingController();
  TextEditingController _ciudadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TypeAheadFormField<Cliente>(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _documentoController,
                    onChanged: (value) {
                      widget.cliente.documento = value;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Documento',
                    )),
                suggestionsCallback: (pattern) async {
                  return await ClienteService()
                      .searchClienteByDocument(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.documento),
                  );
                },
                validator: (value) =>
                    value!.isEmpty ? 'Debe ingresar un documento' : null,
                onSaved: (value) {
                  print(value);
                  widget.cliente.documento = value!;
                },
                onSuggestionSelected: (suggestion) {
                  _documentoController.text = suggestion.documento;
                  _nombreController.text = suggestion.nombre;
                  _razonSocialController.text = suggestion.razonSocial;
                  _direccionController.text = suggestion.direccion;
                  _ciudadController.text = suggestion.ciudad;
                  _telefonoController.text = suggestion.telefono;
                  _emailController.text = suggestion.email;
                  widget.viewModel.state.cliente = suggestion;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Nombre',
                ),
                controller: _nombreController,
                validator: (value) =>
                    value!.isEmpty ? 'Debe ingresar un nombre' : null,
                onChanged: (value) {
                  widget.cliente.nombre = value;
                },
                onSaved: (value) {
                  widget.cliente.nombre = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Razon Social',
                ),
                controller: _razonSocialController,
                validator: (value) =>
                    value!.isEmpty ? 'Debe ingresar un Razon Social' : null,
                onChanged: (value) {
                  widget.cliente.razonSocial = value;
                },
                onSaved: (value) {
                  widget.cliente.razonSocial = value!;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Telefono',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Debe ingresar un telefono' : null,
                onChanged: (value) {
                  widget.cliente.telefono = value;
                },
                onSaved: (value) {
                  widget.cliente.telefono = value!;
                },
              ),
              TextFormField(
                controller: _ciudadController,
                decoration: InputDecoration(
                  icon: Icon(Icons.location_city),
                  labelText: 'Ciudad',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Debe ingresar una Ciudad' : null,
                onChanged: (value) {
                  widget.cliente.ciudad = value;
                },
                onSaved: (value) {
                  widget.cliente.ciudad = value!;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Direccion',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Debe ingresar una direccion' : null,
                onChanged: (value) {
                  widget.cliente.direccion = value;
                },
                onSaved: (value) {
                  widget.cliente.direccion = value!;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                validator: (value) => value!.isEmpty
                    ? null
                    : EmailValidator.validate(value)
                        ? null
                        : 'El Email no es valido',
                onChanged: (value) {
                  widget.cliente.email = value;
                },
                onSaved: (value) {
                  widget.cliente.email = value!;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
