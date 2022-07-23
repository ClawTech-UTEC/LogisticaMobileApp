import 'dart:async';
import 'dart:convert';

import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/utils/confirmation_diolog.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:shared_preferences/shared_preferences.dart';

class MapaRuta extends StatefulWidget {
  MapaRuta({Key? key, required this.pedidos}) : super(key: key);
  final List<Pedido> pedidos;
  @override
  State<MapaRuta> createState() => _MapaRutaState();
}

class _MapaRutaState extends State<MapaRuta> {
  double latidudInicial = -33.1182835;
  double longitudInicial = -58.32952;
  late CameraPosition _kGooglePlex;
  GoogleMapController? _controller;
  Position? _currentPosition;
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  late Future<Set<Marker>> makers;
  String _currentAddress = '';
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();
  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;
  Map<Pedido, double> pedidos = {};
  Pedido? pedidoSeleccionado;
  PedidosService pedidosService = PedidosService();
  late SharedPreferences prefs;
  late AuthJwtData authData;
  Set<Marker> markers = {};
  Set<Polyline> polylinesSet = {};

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target: LatLng(latidudInicial, longitudInicial),
      zoom: 14.4746,
    );
    widget.pedidos.forEach((pedido) {
      pedidos[pedido] = 0.0;
    });
  }

  Future<void> crearRutas(double latitudIn, double longitudIn) async {
    markers.clear();
    polylinesSet.clear();
    polylineCoordinates.clear();

    Marker _marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(latitudIn, longitudIn),
      infoWindow: InfoWindow(
        title: 'Clawtech',
        snippet: 'Av. Las Heras 1234',
      ),
    );
    prefs = await SharedPreferences.getInstance();
    authData = AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));
    markers.add(_marker);
    double latitudAnterior = latidudInicial;
    double longitudAnterior = longitudInicial;
    for (var pedido in pedidos.keys) {
      GeoData data = await Geocoder2.getDataFromAddress(
          address: pedido.direccion,
          googleMapApiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!);
      markers.add(Marker(
        markerId: MarkerId(pedido.idPedido.toString()),
        position: LatLng(data.latitude, data.longitude),
        infoWindow: InfoWindow(
          title: pedido.cliente.razonSocial,
          snippet: pedido.direccion,
        ),
      ));
    }
    ;
    List<Marker> _markersOrdenadoDistancia = [];
    List<Marker> _markersParaOrdenar = markers.toList();
    Marker markerMasCercano = _markersParaOrdenar.first;
    _markersParaOrdenar.remove(markerMasCercano);
    Marker nuevoMarkadorMasCercano = markerMasCercano;
    while (_markersParaOrdenar.isNotEmpty) {
      double distanciaMasCercano = double.infinity;
      for (var marker in _markersParaOrdenar) {
        double distancia = _coordinateDistance(
          markerMasCercano.position.latitude,
          markerMasCercano.position.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );
        if (distancia < distanciaMasCercano) {
          distanciaMasCercano = distancia;
          nuevoMarkadorMasCercano = marker;
        }
      }
      _markersOrdenadoDistancia.add(nuevoMarkadorMasCercano);
      pedidos[pedidos.keys.firstWhere((pedido) =>
              pedido.idPedido ==
              int.parse(nuevoMarkadorMasCercano.markerId.value))] =
          distanciaMasCercano;
      _markersParaOrdenar.remove(nuevoMarkadorMasCercano);
      markerMasCercano = nuevoMarkadorMasCercano;
    }
    pedidoSeleccionado = pedidos.keys.first;

    for (Marker data in _markersOrdenadoDistancia) {
      await _createPolylines(latitudAnterior, longitudAnterior,
          data.position.latitude, data.position.longitude);
      latitudAnterior = data.position.latitude;
      longitudAnterior = data.position.longitude;
      print(data.position.latitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: crearRutas(latidudInicial, longitudInicial),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      // _getCurrentLocation();
                    },
                    markers: markers,
                    polylines: polylinesSet,
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Siguiente Pedido: ${pedidoSeleccionado?.cliente.razonSocial}\n${pedidoSeleccionado?.direccion}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                SizedBox(height: 10),
                                SizedBox(height: 10),
                                Visibility(
                                  visible:
                                      true, //_placeDistance == null ? false : true,
                                  child: Text(
                                    'DISTANCIA:  km ${pedidos[pedidoSeleccionado]?.toStringAsFixed(2)} ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                ElevatedButton(
                                  onPressed: () async {
                                    confirmarcionDiolog(
                                        context: context,
                                        title:
                                            "¿Desea marcar el pedido como entregado?",
                                        onConfirm: () async {
                                          pedidosService
                                              .entregarPedido(
                                                  pedidoSeleccionado!.idPedido!,
                                                  authData.idUsuario)
                                              .then((value) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor:
                                                  Theme.of(context).accentColor,
                                              content: Text('Pedido entregado'),
                                            ));

                                            pedidos.remove(pedidoSeleccionado);
                                            if (pedidos.isEmpty) {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      "Se Completo el Reparto"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DashboardPage()));
                                                      },
                                                      child: Text("Ok"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              return;
                                            } else {
                                              setState(() {});
                                            }
                                            // markers.remove(markers.firstWhere(
                                            //     (marker) =>
                                            //         marker.markerId.value ==
                                            //         pedidoSeleccionado!
                                            //             .idPedido
                                            //             .toString()));
                                          }).catchError((onError) => {
                                                    Scaffold.of(context)
                                                        .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .accentColor,
                                                      content: Text(
                                                          'Error al entregar pedido'),
                                                    ))
                                                  });
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Entregar Pedido'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<Position> _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });

    return _currentPosition!;
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      dotenv.env['GOOGLE_MAPS_API_KEY']!, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    polylinesSet.add(polyline);
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }
}

class MapState {
  Set<Marker> markers = {};
  Set<Polyline> polylinesSet = {};
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Map<Pedido, double> pedidos = {};

  MapState();
}

class CounterCubit extends Cubit<MapState> {
  CounterCubit() : super(MapState());
  void addMarker(Marker marker) {
    state.markers.add(marker);
    emit(state);
  }

  void addPolyline(Polyline polyline) {
    state.polylinesSet.add(polyline);
    emit(state);
  }

  void addPolylineCoordinates(LatLng latLng) {
    state.polylineCoordinates.add(latLng);
    emit(state);
  }

  void addPolylines(Map<PolylineId, Polyline> polylines) {
    state.polylines = polylines;
    emit(state);
  }

  void removeMarker(Marker marker) {
    state.markers.remove(marker);
    emit(state);
  }

  void removePolyline(Polyline polyline) {
    state.polylinesSet.remove(polyline);
    emit(state);
  }

  void removePolylineCoordinates(LatLng latLng) {
    state.polylineCoordinates.remove(latLng);
    emit(state);
  }

  void removePolylines(Map<PolylineId, Polyline> polylines) {
    state.polylines = polylines;
    emit(state);
  }

  void clearMarkers() {
    state.markers.clear();
    emit(state);
  }

  void clearPolylines() {
    state.polylinesSet.clear();
    emit(state);
  }

  void clearPolylineCoordinates() {
    state.polylineCoordinates.clear();
    emit(state);
  }

  

  void addPedido(Pedido pedido, double distance) {
    state.pedidos[pedido] = distance;
    emit(state);
  }

  void removePedido(Pedido pedido) {
    state.pedidos.remove(pedido);
    emit(state);
  }

  void clearPedidos() {
    state.pedidos.clear();
    emit(state);
  }

  void clearAll() {
    clearMarkers();
    clearPolylines();
    clearPolylineCoordinates();
    clearPedidos();
  }
  

  
}
