import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/auth_data.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/states/authentication_states.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationViewModel extends Cubit<AuthenticationState> {
  AuthenticationViewModel({required UserService this.userService})
      : super(LoadingState());
  final UserService userService;

  void onLoginButtonPressed(String email, String password) async {
    print("onLoginButtonPressed");
    emit(SignInState(loading: true));
    try {
      AuthJwtData authData = await userService.login(email, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("authData", jsonEncode(authData));
      emit(AuthenticationSuccessState());
    } catch (e) {
      if (e is UnauthorisedException) {
        print(e.message);
        emit(SignInState(message: e.message));
      } else if (e is BadRequestException) {
        print(e.message);
        emit(SignInState(message: e.message));
      } else if (e is FetchDataException) {
        print(e.message);
        emit(SignInState(message: e.message));
      } else {
        emit(SignInState(message: "Error de conexión"));
      }
    }
  }

  void initialAithentication() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      AuthJwtData? authJwtData =
          AuthJwtData.fromJson(jsonDecode(prefs.getString("authData")!));
      if (authJwtData != null
          ? !JwtDecoder.isExpired(authJwtData.jwt)
          : false) {
        emit(AuthenticationSuccessState());
      } else {
        emit(SignInState());
      }
    } catch (e) {
      emit(SignInState(message: "Error de conexión"));
    }
  }

  void onGoToRegistrationButtomPressed() {
    state.controller.animateToPage(
      1,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    emit(SignUpState());
  }

  void onGoToLoginButtomPressed() {
    state.controller.animateToPage(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    emit(SignInState());
  }

  void registrarse(String email, String password, String repeatPassword,
      String nombre, String apellido) async {
    emit(SignUpState(loading: true));

    try {
      Usuario user =
          await userService.createUser(email, password, nombre, apellido);
      state.controller.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      emit(SignInState(message: "Usuario creado correctamente"));
    } catch (e) {
      if (e is BadRequestException) {
        print(e.message);
        emit(SignUpState(message: e.message, emailRepetido: true));
      } else {
        emit(SignUpState(message: "Error al registrarte - Intentalo de nuevo"));
      }
    }
  }

  void onSignOutButtonPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("authData");
    emit(SignInState());
  }
}
