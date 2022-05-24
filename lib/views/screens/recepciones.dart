import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/mockdata.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:flutter/material.dart';

class ListadoRecepciones extends StatefulWidget {
  ListadoRecepciones({Key? key}) : super(key: key);

  @override
  State<ListadoRecepciones> createState() => _ListadoRecepcionesState();
}

class _ListadoRecepcionesState extends State<ListadoRecepciones> {
  
 


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recepciones.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            tileColor: Colors.white,
            title: Text('Recepcion $index'),
            subtitle: Text('Estado: ${recepciones[index].estadoRecepcion.last.tipoEstado!.nombre}'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, 'recepciones/$index');
            },
          ),
        );
      },
    
    );
  }
}
