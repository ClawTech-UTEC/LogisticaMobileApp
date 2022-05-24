import 'dart:io';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/constants.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  @override
  Future<Usuario> getUser(String email, String password) async {
    if (email == "" || password == "") {
      throw new BadRequestException(
          "El email y la contraseña son requeridos para iniciar sesión");
    }

    dynamic responseJson;
    final response = await http.post(Uri.parse(apiBaseUrl + "/loginMovil"),
        body: {"email": email, "password": password});
    print(response.body);

    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      Usuario user = Usuario.fromJson(responseJson);
      print(user);
      return user;
    } else if (response.statusCode == 401) {
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
}
