import 'package:clawtech_logistica_app/enums/tipo_usuarios.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Usuario {
  int? idUsuario;
  String? nombre;
  String? apellido;
  String? email;
  String? password;
  bool? active;
  TipoUsuario? tipoUsuario;

  Usuario(
      { this.idUsuario,
      this.nombre,
      this.apellido,
      this.email,
      this.password,
      this.active,
      this.tipoUsuario});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json['idUsuario'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        email: json['email'],
        password: json['password'],
        active: json['active'],
        tipoUsuario: json['tipoUsuario'] != null
            ? TipoUsuario.values.byName(json['tipoUsuario'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'idUsuario': idUsuario,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'password': password,
        'active': active,
        'tipoUsuario': tipoUsuario != null ? tipoUsuario!.name : null,
      };
}
