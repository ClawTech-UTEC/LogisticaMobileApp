import 'dart:convert';

import 'package:clawtech_logistica_app/apis/api_exeptions.dart';
import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationViewModel extends Cubit<AuthenticationState> {
  AuthenticationViewModel({required UserService this.userService})
      : super(InitialState());
  final UserService userService;

  void onLoginButtonPressed(String email, String password) async {
    print("onLoginButtonPressed");
    try {
      Usuario usuario = await userService.getUser(email, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      //todo: guardar token real de jtw
      prefs.setString("token", jsonEncode(usuario));
      emit(AuthenticationSuccessState());
    } catch (e) {
      if (e is UnauthorisedException) {
        print(e.message);
        emit(SignInErrorState(e.message));
      } else if (e is BadRequestException) {
        print(e.message);
        emit(SignInErrorState(e.message));
      } else if (e is FetchDataException) {
        print(e.message);
        emit(SignInErrorState(e.message));
      } else {
        emit(SignInErrorState("Error al conectarte - Intentalo de nuevo"));
      }
    }
  }

  void initialAithentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //todo: guardar token real de jtw
    String? userToken = prefs.getString("token");
    if (userToken != null) {
      emit(AuthenticationSuccessState());
    } else {
      emit(SignInState());
    }
  }

  void onGoToRegistrationButtomPressed() {
    emit(SignUpState());
  }

  void onGoToLoginButtomPressed() {
    emit(InitialState());
  }

  void registrarse(String email, String password, String repeatPassword,
      String nombre, String apellido) async {
    try {
      Usuario user =
          await userService.createUser(email, password, nombre, apellido);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //todo: guardar token real de jtw
      prefs.setString("token", jsonEncode(user));
      emit(AuthenticationSuccessState());
    } catch (e) {
      if (e is BadRequestException) {
        print(e.message);
        emit(SignUpErrorState(message: e.message, emailRepetido: true));
      } else {
        emit(SignUpErrorState(
            message: "Error al registrarte - Intentalo de nuevo"));
      }
    }
  }

  void onSignOutButtonPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    emit(SignInState());
  }
}

abstract class AuthenticationState extends Equatable {}

class InitialState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccessState extends AuthenticationState {
  AuthenticationSuccessState();
  // Usuario usuario;

  @override
  List<Object> get props => [];
}

class SignInState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class SignUpState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class SignUpErrorState extends AuthenticationState {
  SignUpErrorState({this.message = "", this.emailRepetido = false});
  String message;
  bool emailRepetido;

  @override
  List<Object> get props => [message, emailRepetido];
}

class SignInErrorState extends AuthenticationState {
  SignInErrorState(this.message);
  String message;
  @override
  List<Object> get props => [message];
}
