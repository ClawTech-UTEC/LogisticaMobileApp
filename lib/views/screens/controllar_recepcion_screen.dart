import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/control_recepcion_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/events/controlar_recepcion_events.dart';
import 'package:clawtech_logistica_app/view_model/states/controlar_recepcion_states.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
import 'package:clawtech_logistica_app/views/widgets/barcode_search_textform.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControllarRecepcionScreen extends StatefulWidget {
  ControllarRecepcionScreen({Key? key, required this.recepcion})
      : super(key: key);
  Recepcion recepcion;

  @override
  State<ControllarRecepcionScreen> createState() =>
      _ControllarRecepcionScreenState();
}

class _ControllarRecepcionScreenState extends State<ControllarRecepcionScreen> {
  ControlRecepcionViewModel viewModel = ControlRecepcionViewModel();
  TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGeneralBackground(
        title: "Controlar Recepción",
        child: BlocListener(
          bloc: viewModel,
          listener: (context, ControlRecepcionState state) {
            if (state.status == ControlRecepcionStateEnum.ERROR) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text('${state.error}'),
                ),
              );
        
        
            }
            if (state.status == ControlRecepcionStateEnum.PRODUCTOAGREGADO) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text('Producto Agregado'),
                ),
              );
            }




            if (state.status == ControlRecepcionStateEnum.COMPLETED) {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage()),
              );
            }
          },
          child: BlocBuilder(
              bloc: viewModel
                ..add(ControlRecepcionEventLoad(
                  recepcion: widget.recepcion,
                )),
              builder: (context, ControlRecepcionState state) {
                if (state.status == ControlRecepcionStateEnum.INITIAL) {
                  return LoadingPage();
                }

                return CardGeneral(
                  child: Column(
                    children: [
                      BarcodeSearchTextFile(
                          onChanged: (_) => {},
                          searchController: _searchController,
                          onScanCompleted: (String x) {
                            viewModel.add((ControlRecepcionEventAddProducto(
                              scannedProduct: x,
                            )));
                          },
                          onSearch: () {
                            viewModel.add((ControlRecepcionEventAddProducto(
                              scannedProduct: _searchController.text,
                            )));
                          }),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Form(
                          key: _formKey,
                          child: _createControllRecepctionDataTable(
                              state.recepcion!.productos,
                              state.tableController),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor,
                            )),
                            onPressed: (() => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      confirmarcionDiolog(
                                          onConfirm: () {
                                            viewModel.add(
                                                ControlRecepcionEventCompleted(
                                                    controlarDiferencias:
                                                        true));
                                          },
                                          context: context,
                                          title:
                                              "¿Confirma acepatar la recepcion?")
                                    }
                                  else
                                    {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          content: Text('Datos no coinciden'),
                                        ),
                                      )
                                    }
                                }),
                            child: Text("Aceptar recepcion"),
                          ),
                          // ElevatedButton(
                          //   style: ButtonStyle(
                          //       backgroundColor: MaterialStateProperty.all(
                          //     Theme.of(context).accentColor,
                          //   )),
                          //   onPressed: (() => {
                          //         confirmarcionDiolog(
                          //             onConfirm: () {
                          //               viewModel.add(
                          //                   ControlRecepcionEventCompleted(
                          //                       controlarDiferencias: false));
                          //             },
                          //             context: context,
                          //             title:
                          //                 "Aceptar la recepcion con diferencias")
                          //       }),
                          //   child: Text("Aceptar con diferencias"),
                          // ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ));
  }

  void confirmarcionDiolog(
      {required BuildContext context,
      required String title,
      required VoidCallback onConfirm}) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Por favor confirmar'),
            content: Text(title),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    onConfirm();

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Si')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}

DataTable _createControllRecepctionDataTable(
    List<RecepcionProducto> productosCantidad,
    List<TextEditingController> controllersCantidadIngresada) {
  return DataTable(
      columnSpacing: 40,
      columns: _controllRecepctionProductsColumns(),
      rows: _controllRecepctionProductsRows(
          productosCantidad, controllersCantidadIngresada));
}

List<DataColumn> _controllRecepctionProductsColumns() {
  return [
    DataColumn(label: Text('Producto')),
    DataColumn(label: Text('Codigo')),
    DataColumn(label: Text('Esperado'), numeric: true),
    DataColumn(label: Text('Recibido'), numeric: true),
  ];
}

List<DataRow> _controllRecepctionProductsRows(List<RecepcionProducto> productos,
    List<TextEditingController> controllersCantidadIngresada) {
  TextEditingController _textEditing = TextEditingController();
  return productos.map((entry) {
    return DataRow(cells: [
      DataCell(Text('${entry.producto.nombre}')),
      DataCell(Text('${entry.producto.codigoDeBarras}')),
      DataCell(Text('${entry.cantidad}')),
      DataCell(
          TextFormField(


            validator: (value) {
              print(value);
              if (value == null) {
                return '';
              }
              if (value != entry.cantidad.toString()){
                return '';
              }
              return null;
            },
            controller: controllersCantidadIngresada[productos.indexOf(entry)],
            //  initialValue: '${entry.value}',
           
            decoration: InputDecoration(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              // FilteringTextInputFormatter.digitsOnly,
             
            ],
          ),
          showEditIcon: true)
    ]);
  }).toList();
}
