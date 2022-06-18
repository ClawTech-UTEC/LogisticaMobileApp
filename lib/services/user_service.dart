import 'dart:io';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static final UserService _instance = new UserService.internal();
  factory UserService() => _instance;
  UserService.internal();

  @override
  Future<AuthJwtData> login(String email, String password) async {
    if (email == "" || password == "") {
      throw new BadRequestException(
          "El email y la contraseña son requeridos para iniciar sesión");
    }

    dynamic responseJson;
    final response = await http.post(
      Uri.parse(apiBaseUrl + "/login"),
      body: jsonEncode({"email": email, "password": password}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      AuthJwtData loginResponseJson =
          AuthJwtData.fromJson(json.decode(response.body));
      return loginResponseJson;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw UnauthorisedException("Email o password incorrectos");
    } else if (response.statusCode == 500) {
      throw FetchDataException("No se pudo conectar con el servidor");
    } else {
      throw FetchDataException("Error desconocido");
    }
  }

  @override
  Future<Usuario> createUser(
      String email, String password, String nombre, String apellido) async {
    if (email == "" || password == "") {
      throw new BadRequestException("El email y la contraseña son requeridos");
    }

    dynamic responseJson;
    Usuario user;
    final response = await http.post(Uri.parse(apiBaseUrl + "/register"),
        body: {
          "email": email,
          "password": password,
          "nombre": nombre,
          "apellido": apellido
        });
    print(response.body);

    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      user = Usuario.fromJson(responseJson);
      return user;
    } else if (response.statusCode == 400) {
      throw BadRequestException("Email ya existe");
    } else if (response.statusCode == 500) {
      throw FetchDataException("No se pudo conectar con el servidor");
    } else {
      throw FetchDataException("Error desconocido");
    }
  }

  Future<Usuario> getUsuarioData(int usuarioId) async {
    final response = await http.post(
      Uri.parse(apiBaseUrl + '/usuario/?id=$usuarioId'),
      
       headers: <String, String>{
          'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      Usuario usuario = Usuario.fromJson(json.decode(response.body));
      return usuario;
    } else {
      throw Exception('Failed to load Usuario');
    }
  }
}
