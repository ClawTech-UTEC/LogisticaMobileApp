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
      prefs.setString("token", usuario.idUsuario.toString());
      emit(AuthenticationSuccessState());
    } catch (e) {
      if (e is BadRequestException) {
        print(e.message);
        emit(ErrorState(e.message));
      } else if (e is UnauthorisedException) {
        print(e.message);
        emit(ErrorState(e.message));
      } else if (e is FetchDataException) {
        print(e.message);
        emit(ErrorState(e.message));
      } else {
        emit(ErrorState("Error desconocido"));
      }
    }
  }

  void initialAithentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
       //todo: guardar token real de jtw
      prefs.getString("token");
      emit(AuthenticationSuccessState( ));
    } catch (e) {}
  }

  void onGoToRegistrationButtomPressed() {
    emit(SigningUpState());
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
      prefs.setString("token", user.idUsuario.toString());
      emit(AuthenticationSuccessState());
    } catch (e) {
      if (e is BadRequestException) {
        print(e.message);
        emit(ErrorState(e.message));
      }
    }
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

class SigningUpState extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class RegistrationErrorState extends AuthenticationState {
  RegistrationErrorState(this.message);
  String message;

  @override
  List<Object> get props => [message];
}

class ErrorState extends AuthenticationState {
  ErrorState(this.message);
  String message;
  @override
  List<Object> get props => [message];
}
