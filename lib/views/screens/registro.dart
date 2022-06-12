import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key, this.errorMessage}) : super(key: key);
  String? errorMessage;
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  final _registrationFormKey = GlobalKey<FormState>();
  late AuthenticationViewModel viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = BlocProvider.of<AuthenticationViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "loginCard",
      child: Card(
          shadowColor: Colors.red,
          elevation: 10,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image(
                        image: AssetImage('assets/logo.png'),
                      )),
                  Form(
                      key: _registrationFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El Email es requerido';
                              } else if (!EmailValidator.validate(value)) {
                                return 'El Email no es valido';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El Password es requerido';
                              } else if (value.length < 6) {
                                return 'El Password debe tener al menos 6 caracteres';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Password',
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordRepeatController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Debes repetir el Password';
                              }
                              if (value != passwordController.text) {
                                return 'Los Password deben coincidir';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Repite Password',
                            ),
                          ),
                          TextFormField(
                            controller: nombreController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Debes ingresar tu nombre';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Nombre',
                            ),
                          ),
                          TextFormField(
                            controller: apellidoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Debes ingresar tu apellido';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Apellido',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                child: Text('Registrarse'),
                                onPressed: () {
                                  if (_registrationFormKey.currentState!
                                      .validate()) {
                                    viewModel.registrarse(
                                        emailController.text,
                                        passwordController.text,
                                        passwordRepeatController.text,
                                        nombreController.text,
                                        apellidoController.text);
                                  }
                                },
                              ),
                              ElevatedButton(
                                child: Text('Login'),
                                onPressed: () {
                                  BlocProvider.of<AuthenticationViewModel>(
                                          context)
                                      .onGoToLoginButtomPressed();
                                },
                              )
                            ],
                          ),
                         
                          // widget.errorMessage != null
                          //     ? Text(widget.errorMessage!)
                          //     : Container(),
                         
                        ],
                      )),
                ]),
              ))),
    );
  }
}
