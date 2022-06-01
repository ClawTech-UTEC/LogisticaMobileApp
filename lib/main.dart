import 'package:clawtech_logistica_app/views/screens/crear_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTEC - Logistica App',
      
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.blue,
          backgroundColor: Colors.red[300],
          splashColor: Colors.white,
          textTheme: GoogleFonts.robotoTextTheme(textTheme).copyWith(
              bodyMedium: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black),
              headlineSmall: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(color: Colors.white),
              headlineLarge: GoogleFonts.cevicheOne(
                textStyle: TextStyle(
                  color: Colors.grey[700],
                  decoration: TextDecoration.underline,
                ),
              ),
              titleLarge: TextStyle(color: Colors.black),
              titleSmall: TextStyle(color: Colors.black),
            
              
              )),
              
      home: HomePage(),
    );
  }
}
