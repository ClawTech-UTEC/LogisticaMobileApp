import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/view_model/states/authentication_states.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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
  late AuthenticationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = BlocProvider.of<AuthenticationViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  key: _loginFormKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Divider(),
                        Column(children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El Email es requerido';
                              } else if (!EmailValidator.validate(value.trim().toLowerCase())) {
                                return 'El Email no es valido';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                print(value);
                                return 'El Password es requerido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password),
                              labelText: 'Password',
                            ),
                            obscureText: true,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  viewModel.onLoginButtonPressed(
                                      emailController.text.toLowerCase().trim(),
                                      passwordController.text);
                                }
                              },
                              child: Text(
                                'Login',
                              )),
                          ElevatedButton(
                            onPressed: (() =>
                                {viewModel.onGoToRegistrationButtomPressed()}),
                            child: Text('Registrarse'),
                          )
                        ]),
                       
                        // widget.errorMessage != null
                        //     ? Text(widget.errorMessage!)
                        //     : Container(),
                      ]),
                ),
              ]),
            )));
  }
}
