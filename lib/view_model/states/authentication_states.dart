import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationState {
  String? message;
  PageController controller = PageController();
    bool loading = false;
  bool emailRepetido = false;
  Usuario? usuario;

}

class LoadingState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {

AuthenticationSuccessState({this.message , this.loading = false, this.usuario});
  String? message;
  bool loading;
  Usuario? usuario;
}

class SignInState extends AuthenticationState {
  SignInState({this.message, this.loading = false}): super();
  String? message;
  bool loading;
}

class SignUpState extends AuthenticationState {
  SignUpState({this.message, this.emailRepetido = false, this.loading = false}): super();
  String? message;
  bool loading;
    bool emailRepetido;

}
