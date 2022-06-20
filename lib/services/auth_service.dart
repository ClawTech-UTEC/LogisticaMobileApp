import 'dart:convert';

import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = new AuthService.internal();
  factory AuthService() => _instance;
  AuthService.internal();

  Future<int> getIdUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authJwtData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData") ?? "{}"));
    return authJwtData.idUsuario;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthJwtData authJwtData =
        AuthJwtData.fromJson(jsonDecode(prefs.getString("authData") ?? "{}"));
    return authJwtData.jwt;
  }
}
