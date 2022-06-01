import 'package:clawtech_logistica_app/models/cliente.dart';
import 'package:clawtech_logistica_app/view_model/crear_pedido_viewmodel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class AgregarClientePedidoForm extends StatefulWidget {
  AgregarClientePedidoForm({
    Key? key,
    required this.formKey,
    required this.viewModel,
    required this.cliente
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final CrearPedidoViewModel viewModel;
  Cliente cliente;

  @override
  State<AgregarClientePedidoForm> createState() =>
      _AgregarClientePedidoFormState();
}

class _AgregarClientePedidoFormState extends State<AgregarClientePedidoForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Documento',
            ),
            validator: (value) =>
                value!.isEmpty ? 'Debe ingresar un documento' : null,
            onChanged: (value) {
              widget.cliente.documento = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Nombre',
            ),
            validator: (value) =>
                value!.isEmpty ? 'Debe ingresar un nombre' : null,
            onChanged: (value) {
              widget.cliente.nombre = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Razon Social',
            ),
            validator: (value) =>
                value!.isEmpty ? 'Debe ingresar un Razon Social' : null,
            onChanged: (value) {
              widget.cliente.razonSocial = value;
            
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Telefono',
            ),
            validator: (value) =>
                value!.isEmpty ? 'Debe ingresar un telefono' : null,
            onChanged: (value) {
              widget.cliente.telefono = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Direccion',
            ),
            validator: (value) =>
                value!.isEmpty ? 'Debe ingresar una direccion' : null,
            onChanged: (value) {
              widget.cliente.direccion = value;
            
            },
          ),
          TextFormField(
            decoration: InputDecoration(
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
          ),
        ],
      ),
    );
  }
}
