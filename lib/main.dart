import 'package:clawtech_logistica_app/views/screens/crear_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'UTEC - Logistica App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.blue,
        backgroundColor: Colors.red[300],
        
        splashColor: Colors.white,
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
        ),
      ),
      home:   CrearRecepcionScreen(),
    );
  }
}
