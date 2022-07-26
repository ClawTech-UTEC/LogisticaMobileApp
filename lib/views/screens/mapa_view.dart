import 'dart:async';
import 'dart:convert';

import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/pedidos.dart';
import 'package:clawtech_logistica_app/services/pedidos_service.dart';
import 'package:clawtech_logistica_app/utils/confirmation_diolog.dart';
import 'package:clawtech_logistica_app/views/screens/dashboard.dart';
import 'package:clawtech_logistica_app/views/screens/loading_screen.dart';
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
  String _currentAddress = '';
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();
  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;
  PedidosService pedidosService = PedidosService();
  late MapCubit cubit;

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target: LatLng(latidudInicial, longitudInicial),
      zoom: 14.4746,
    );
    cubit = MapCubit(
      widget.pedidos,
      latidudInicial,
      longitudInicial,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapCubit, MapState>(
          bloc: cubit..loadData(),
          builder: (context, state) {
            if (state.ultimaMillaState == UltimaMillaStateEnum.INITIAL) {
              return LoadingPage();
            }

            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    // _getCurrentLocation();
                  },
                  markers: state.markers,
                  polylines: state.polylinesSet,
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
                                "Siguiente pedido:",
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Cliente: ${state.pedidoSeleccionado?.cliente.razonSocial}\n Direccion: ${state.pedidoSeleccionado?.direccion}',
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
                                  'DISTANCIA:  km ${state.pedidosDistancia[state.pedidoSeleccionado]?.toStringAsFixed(2)}\n Tiempo estimado: ${(state.pedidosDistancia[state.pedidoSeleccionado]! * 1.5).toStringAsFixed(2)} min',
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
                                        cubit.entregarPedido(
                                            state.pedidoSeleccionado!,
                                            pedidosService,
                                            context);
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
                              SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () async {
                                  confirmarcionDiolog(
                                      context: context,
                                      title: "¿Desea no entregar el pedido?",
                                      onConfirm: () async {
                                        cubit.noEntregarPedido(
                                            state.pedidoSeleccionado!, context);
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'No Entregar Pedido'.toUpperCase(),
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
  Map<Pedido, double> pedidosDistancia = {};
  List<Pedido> pedidos;
  double latitudInicial;
  double longitudInicial;
  SharedPreferences? prefs;
  AuthJwtData? authData;
  Pedido? pedidoSeleccionado;
  PolylinePoints? polylinePoints;
  UltimaMillaStateEnum ultimaMillaState;

  MapState({
    required this.pedidos,
    required this.latitudInicial,
    required this.longitudInicial,
    this.pedidoSeleccionado,
    this.ultimaMillaState = UltimaMillaStateEnum.INITIAL,
    this.polylinePoints,
    this.prefs,
    this.authData,
    this.polylinesSet = const {},
    this.pedidosDistancia = const {},
    this.markers = const {},
  }) {}

  copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylinesSet,
    Map<Pedido, double>? pedidosDistancia,
    List<Pedido>? pedidos,
    double? latitudInicial,
    double? longitudInicial,
    Pedido? pedidoSeleccionado,
    UltimaMillaStateEnum? ultimaMillaState,
    PolylinePoints? polylinePoints,
    SharedPreferences? prefs,
    AuthJwtData? authData,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      polylinesSet: polylinesSet ?? this.polylinesSet,
      pedidosDistancia: pedidosDistancia ?? this.pedidosDistancia,
      pedidos: pedidos ?? this.pedidos,
      latitudInicial: latitudInicial ?? this.latitudInicial,
      longitudInicial: longitudInicial ?? this.longitudInicial,
      pedidoSeleccionado: pedidoSeleccionado ?? this.pedidoSeleccionado,
      ultimaMillaState: ultimaMillaState ?? this.ultimaMillaState,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      prefs: prefs ?? this.prefs,
      authData: authData ?? this.authData,
    );
  }
}

class MapCubit extends Cubit<MapState> {
  MapCubit(List<Pedido> pedidos, double lat, double lng)
      : super(MapState(
            pedidos: pedidos, latitudInicial: lat, longitudInicial: lng));

  void loadData() async {
    Map<Pedido, double> mapaPedidosDistancia = {};
    Set<Marker> markers = await getMarkersDePedidos(
        state.pedidos, state.latitudInicial, state.longitudInicial);
    List<Marker> markersOrdenados = await getListaMarcadoresOrdenada(
        mapaPedidosDistanacia: mapaPedidosDistancia,
        markers: markers.toList(),
        latitudIn: state.latitudInicial,
        longitudIn: state.longitudInicial);

    Set<Polyline> polylinesSet = await getPolylinesDePedidos(
        markersOrdenados, state.latitudInicial, state.longitudInicial);
    Pedido pedidoSeleccionado = mapaPedidosDistancia.keys.first;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));

    MapState mapState = state.copyWith(
        markers: markers,
        polylinesSet: polylinesSet,
        pedidosDistancia: mapaPedidosDistancia,
        pedidoSeleccionado: pedidoSeleccionado,
        prefs: prefs,
        authData: authData,
        ultimaMillaState: UltimaMillaStateEnum.LOADED);
    emit(mapState);
  }

  void addMarker(Marker marker) {
    state.markers.add(marker);
    emit(state);
  }

  void addPolyline(Polyline polyline) {
    state.polylinesSet.add(polyline);
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

  void clearMarkers() {
    state.markers.clear();
    emit(state);
  }

  void clearPolylines() {
    state.polylinesSet.clear();
    emit(state);
  }

  void removePedido(Pedido pedido) {
    state.pedidos.remove(pedido);
    emit(state);
  }

  void entregarPedido(
      Pedido pedido, PedidosService pedidosService, context) async {
    pedidosService
        .entregarPedido(
            state.pedidoSeleccionado!.idPedido!, state.authData!.idUsuario)
        .then((value) async {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        content: Text('Pedido entregado'),
      ));
      state.pedidos.remove(pedido);

      if (state.pedidos.isEmpty) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Se Completo el Reparto"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DashboardPage()));
                },
                child: Text("Ok"),
              ),
            ],
          ),
        );
        return;
      }

      List<Pedido> pedidos = state.pedidos.toList();

      Map<Pedido, double> mapaPedidosDistancia = {};
      Set<Marker> markers = await getMarkersDePedidos(
          pedidos, state.latitudInicial, state.longitudInicial);
      List<Marker> markersOrdenados = await getListaMarcadoresOrdenada(
          mapaPedidosDistanacia: mapaPedidosDistancia,
          markers: markers.toList(),
          latitudIn: state.latitudInicial,
          longitudIn: state.longitudInicial);

      Set<Polyline> polylinesSet = await getPolylinesDePedidos(
          markersOrdenados, state.latitudInicial, state.longitudInicial);
      Pedido pedidoSeleccionado = mapaPedidosDistancia.keys.first;
      MapState mapState = state.copyWith(
          markers: markers,
          polylinesSet: polylinesSet,
          pedidosDistancia: mapaPedidosDistancia,
          pedidoSeleccionado: pedidoSeleccionado,
          ultimaMillaState: UltimaMillaStateEnum.LOADED);
      emit(mapState);
    }).catchError((onError) => {
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).accentColor,
                content: Text('Error al entregar pedido'),
              ))
            });
  }

  void noEntregarPedido(Pedido pedido, context) async {
    state.pedidos.remove(pedido);
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text('Pedido no entregado'),
    ));
    Future.sync(() => null).then((value) async {if (state.pedidos.isEmpty)  {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Se Termino el Reparto"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashboardPage()));
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
      return;
    }

    List<Pedido> pedidos = state.pedidos.toList();

    Map<Pedido, double> mapaPedidosDistancia = {};
    Set<Marker> markers = await getMarkersDePedidos(
        pedidos, state.latitudInicial, state.longitudInicial);
    List<Marker> markersOrdenados = await getListaMarcadoresOrdenada(
        mapaPedidosDistanacia: mapaPedidosDistancia,
        markers: markers.toList(),
        latitudIn: state.latitudInicial,
        longitudIn: state.longitudInicial);

    Set<Polyline> polylinesSet = await getPolylinesDePedidos(
        markersOrdenados, state.latitudInicial, state.longitudInicial);
    Pedido pedidoSeleccionado = mapaPedidosDistancia.keys.first;
    MapState mapState = state.copyWith(
        markers: markers,
        polylinesSet: polylinesSet,
        pedidosDistancia: mapaPedidosDistancia,
        pedidoSeleccionado: pedidoSeleccionado,
        ultimaMillaState: UltimaMillaStateEnum.LOADED);
    emit(mapState);});
    
  }

  void clearPedidos() {
    state.pedidos.clear();
    emit(state);
  }

  void clearAll() {
    clearMarkers();
    clearPolylines();
    clearPedidos();
  }

  Map<Pedido, double> getMapaPedidosDistanaciaVacio(List<Pedido> pedidos) {
    Map<Pedido, double> mapaPedidosDistanacia = {};

    pedidos.forEach((pedido) {
      mapaPedidosDistanacia[pedido] = 0.0;
    });

    return mapaPedidosDistanacia;
  }

  Future<Set<Marker>> getMarkersDePedidos(
      List<Pedido> pedidos, double latitudIn, double longitudIn) async {
    Set<Marker> markers = {};
    Marker _marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(latitudIn, longitudIn),
      infoWindow: InfoWindow(
        title: 'Clawtech',
        snippet: 'Av. Las Heras 1234',
      ),
    );
    markers.add(_marker);
    for (var pedido in pedidos) {
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
    return markers;
  }

  List<Marker> getListaMarcadoresOrdenada(
      {required List<Marker> markers,
      required Map<Pedido, double> mapaPedidosDistanacia,
      required double latitudIn,
      required double longitudIn}) {
    List<Marker> _markersOrdenadoDistancia = [];
    List<Marker> _markersParaOrdenar = markers.toList();
    Marker markerMasCercano = _markersParaOrdenar.first;

    _markersOrdenadoDistancia.add(markerMasCercano);
    _markersParaOrdenar.remove(markerMasCercano);
    Marker nuevoMarkadorMasCercano = markerMasCercano;
    while (_markersParaOrdenar.isNotEmpty) {
      double distanciaMasCercano = double.infinity;
      for (var marker in _markersParaOrdenar) {
        double distancia = _coordinateDistance(
          latitudIn,
          longitudIn,
          marker.position.latitude,
          marker.position.longitude,
        );
        if (distancia < distanciaMasCercano) {
          distanciaMasCercano = distancia;
          nuevoMarkadorMasCercano = marker;
        }
      }
      _markersOrdenadoDistancia.add(nuevoMarkadorMasCercano);
      mapaPedidosDistanacia[state.pedidos.firstWhere((pedido) =>
              pedido.idPedido ==
              int.parse(nuevoMarkadorMasCercano.markerId.value))] =
          distanciaMasCercano;
      _markersParaOrdenar.remove(nuevoMarkadorMasCercano);
      markerMasCercano = nuevoMarkadorMasCercano;
    }

    return _markersOrdenadoDistancia;
  }

  Future<Set<Polyline>> getPolylinesDePedidos(
      List<Marker> _markersOrdenadoDistancia,
      double latitudInicial,
      double longitudInicial) async {
    Set<Polyline> polylines = {};
    double latitudAnterior = latitudInicial;
    double longitudAnterior = longitudInicial;
    for (Marker data in _markersOrdenadoDistancia) {
      polylines.add(await _createPolylines(
          latitudAnterior,
          longitudAnterior,
          data.position.latitude,
          data.position.longitude,
          data.markerId.value));
      latitudAnterior = data.position.latitude;
      longitudAnterior = data.position.longitude;

      print(data.position.latitude);
    }
    return polylines;
  }

  Future<Polyline> _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      String marketId) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

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

    PolylineId id = PolylineId(marketId);

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    return polyline;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

abstract class UltimaMillaEvent {}

class UltimaMillaEventEntregarPedido extends UltimaMillaEvent {
  final Pedido pedido;
  UltimaMillaEventEntregarPedido(this.pedido);
}

enum UltimaMillaStateEnum { INITIAL, LOADED, ERROR, COMPLETED }
