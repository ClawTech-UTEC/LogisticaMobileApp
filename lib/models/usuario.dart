import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class Usuario {
  int idUsuario;
  String nombre;
  String apellido;
  String email;
  String password;
  bool active;


  Usuario(
      {required this.idUsuario,
      required this.nombre,
      required this.apellido,
      required this.email,
      required this.password,
      required this.active});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json['idUsuario'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        email: json['email'],
        password: json['password'],
        active: json['active'],
      );

  Map<String, dynamic> toJson() => {
        'idUsuario': idUsuario,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'password': password,
        'active': active,
      };
}
