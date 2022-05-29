import 'package:clawtech_logistica_app/enums/tipo_estado_pedido.dart';
import 'package:clawtech_logistica_app/models/categoria.dart';
import 'package:clawtech_logistica_app/models/estado_recepcion.dart';
import 'package:clawtech_logistica_app/models/provedor.dart';
import 'package:clawtech_logistica_app/models/recepcion.dart';
import 'package:clawtech_logistica_app/models/recepcion_producto.dart';
import 'package:clawtech_logistica_app/models/subcategoria.dart';
import 'package:clawtech_logistica_app/models/tipo_producto.dart';

Provedor provedor =
    Provedor(idProv: 1, nombreProv: 'Clawtech', contacto: '3123123', email: '');

Categoria categoria = Categoria(
  idCat: 1,
  nombre: 'Categoria 1',
);

SubCategoria subCategoria = SubCategoria(
  idSubCat: 1,
  nombre: 'Subcategoria 1',
);
TipoProducto tipoProducto = TipoProducto(
  idTipoProd: 1,
  codigoDeBarras: 5555,
  nombre: 'Producto 1',
  descripcion: 'Producto 1',
  precio: 0.0,
  neto: 0,
  categoria: categoria,
  subCat: subCategoria,
);

TipoProducto tipoProducto2 = TipoProducto(
  idTipoProd: 1,
  codigoDeBarras: 5555,
  nombre: 'Producto 2',
  descripcion: 'Producto 2',
  precio: 0.0,
  neto: 0,
  categoria: categoria,
  subCat: subCategoria,
);

RecepcionProducto recepcionProducto = RecepcionProducto(
  idRecepcionProducto: 1,
  cantidad: 1,
  producto: tipoProducto,
  recepcion: recepcion
);



EstadoRecepcion estadoRecepcion = EstadoRecepcion(
  idEstadoRecepcion: 1,
  fecha: DateTime.now(),
);

Recepcion recepcion = Recepcion(
  idRecepcion: 1,
  provedor: provedor,
  productos: [recepcionProducto, recepcionProducto],
  estadoRecepcion: [estadoRecepcion, estadoRecepcion],
);

List<Recepcion> recepciones = [recepcion, recepcion, recepcion];
