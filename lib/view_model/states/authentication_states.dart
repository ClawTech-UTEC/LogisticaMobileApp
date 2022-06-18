import 'package:flutter/cupertino.dart';

abstract class AuthenticationState {
  String? message;
  PageController controller = PageController();
    bool loading = false;
  bool emailRepetido = false;

}

class LoadingState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {

AuthenticationSuccessState({this.message , this.loading = false});
  String? message;
  bool loading;
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
