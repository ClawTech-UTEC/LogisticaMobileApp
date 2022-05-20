import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/login_viewmodel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  Login({Key? key, String? this.errorMessage}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
  String? errorMessage;
}

class _LoginState extends State<Login> {
  UserService userService = UserService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Text(
                    'Clawtech Logistica App',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 32.0),
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Image(
                                      image: AssetImage('assets/logo.png'),
                                    )),
                                Form(
                                  key: _loginFormKey,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Login',
                                        ),
                                        Divider(),
                                        Column(children: <Widget>[
                                          TextFormField(
                                            controller: emailController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'El Email es requerido';
                                              }
                                              else if (!EmailValidator.validate(
                                                  value)) {
                                                return 'El Email no es valido';
                                              }else {
return null;
                                              }
                                              
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Email',
                                            ),
                                          ),
                                          TextFormField(
                                            controller: passwordController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                print(value);
                                                return 'El Password es requerido';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                            ),
                                            obscureText: true,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (_loginFormKey.currentState!
                                                    .validate()) {
                                                  BlocProvider.of<
                                                              AuthenticationViewModel>(
                                                          context)
                                                      .onLoginButtonPressed(
                                                          emailController.text,
                                                          passwordController
                                                              .text);
                                                }
                                              },
                                              child: Text('Login')),
                                          ElevatedButton(
                                            onPressed: (() => {
                                                  BlocProvider.of<
                                                              AuthenticationViewModel>(
                                                          context)
                                                      .onGoToRegistrationButtomPressed()
                                                }),
                                            child: Text('Registrarse'),
                                          )
                                        ]),
                                        widget.errorMessage != null
                                            ? Text(widget.errorMessage!)
                                            : Container()
                                      ]),
                                ),
                              ]))))
                ])))));
  }
}
