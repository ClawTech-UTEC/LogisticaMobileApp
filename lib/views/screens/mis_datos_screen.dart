import 'package:clawtech_logistica_app/models/usuario.dart';
import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/widgets/card_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MisDatosScreen extends StatefulWidget {
  MisDatosScreen({Key? key}) : super(key: key);

  @override
  State<MisDatosScreen> createState() => _MisDatosScreenState();
}

class _MisDatosScreenState extends State<MisDatosScreen> {
  late AuthenticationViewModel _authenticationViewModel;
  late Usuario _usuario;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authenticationViewModel =
        BlocProvider.of<AuthenticationViewModel>(context);
    _usuario = _authenticationViewModel.state.usuario!;
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
                  "Usuario: ${_usuario.nombre} ${_usuario.apellido}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  "Email: ${_usuario.email}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ListTile(
                leading: Icon(Icons.route_outlined),
                title: Text(
                  "Rol: ${_usuario.tipoUsuario}",
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
