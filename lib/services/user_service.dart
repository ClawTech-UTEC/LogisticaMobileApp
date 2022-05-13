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
    dynamic responseJson;
    Usuario user;
    final response = await http.post(Uri.parse("http://10.0.2.2:8081/api/login"),
        body: {"email": email, "password": password});
        print(response.body);
    user = Usuario.fromJson(jsonDecode(response.body));

    return user;
  }
}
