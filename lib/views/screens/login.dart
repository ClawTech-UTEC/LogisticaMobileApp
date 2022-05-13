import 'package:clawtech_logistica_app/services/user_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                    ),
                    Divider(),
                    Form(
                        child: Column(children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                        labelText: 'Password',
                      )),
                      ElevatedButton(
                          onPressed: () {
                            userService
                                .getUser(
                                    "guillermo.rodriguez@estudiantes.utec.edu.uy",
                                    "123456")
                                .then((value) => print(value));
                          },
                          child: Text('Login')),
                      ElevatedButton(
                        onPressed: (() => {}),
                        child: Text('Registrarse'),
                      )
                    ])),
                  ]),
            ),
          ),
        ));
  }
}
