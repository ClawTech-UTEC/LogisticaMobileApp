import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/crear_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async  {
  await dotenv.load();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (_) => AuthenticationViewModel(userService: UserService()),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTEC - Logistica App',
      
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.blue,
          backgroundColor: Color.fromRGBO(229, 115, 115, 1),
          splashColor: Colors.white,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,

          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            
            ),
          ),

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
              
      home:  LoaderOverlay(child: HomePage())),
    );
  }
}
