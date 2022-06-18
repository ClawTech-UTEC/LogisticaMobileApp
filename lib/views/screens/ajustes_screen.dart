import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AjustesScreen extends StatefulWidget {
  AjustesScreen({Key? key}) : super(key: key);

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  late AuthenticationViewModel _authenticationViewModel;
  late Usuario _usuario;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authenticationViewModel =
        BlocProvider.of<AuthenticationViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return CardGeneral(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset("assets/perfil1.png")),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView(children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Usuario: GUILLERMO RODRIGUEZ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  "Email: guillermo@utec.edu.uy",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ListTile(
                leading: Icon(Icons.route_outlined),
                title: Text(
                  "Rol: Administrador",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
