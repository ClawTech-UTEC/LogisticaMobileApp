import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/home.dart';
import 'package:clawtech_logistica_app/views/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScaffoldGeneralBackground extends StatefulWidget {
  ScaffoldGeneralBackground(
      {Key? key, required this.title, required this.child, this.onCompartir})
      : super(key: key);
  String title;
  Widget child;
  Function? onCompartir;

  @override
  State<ScaffoldGeneralBackground> createState() =>
      _ScaffoldGeneralBackgroundState();
}

class _ScaffoldGeneralBackgroundState extends State<ScaffoldGeneralBackground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Center(
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(widget.title,
                    style: Theme.of(context).textTheme.headlineSmall))),
        actions: [
          PopupMenuButton(
              itemBuilder: getPopupMenuItems(),
              onSelected: (value) {
                if (value == 0) {
                  BlocProvider.of<AuthenticationViewModel>(context)
                      .onSignOutButtonPressed();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
                if (value == 1) {
                  print("Imprimir");
                  widget.onCompartir != null
                      ? widget.onCompartir!()
                      : print("No se ha definido una funcion para Compartir");
                  
                }
              }),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: widget.child,
    );
  }

  List<PopupMenuEntry<int>> Function(BuildContext) getPopupMenuItems() {
    if (widget.onCompartir != null) {
      return (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: Text("Salir"),
            ),
            PopupMenuItem(
              value: 1,
              child: Text("Compartir"),
            ),
          ];
    } else {
      return (BuildContext context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Text("Salir"),
          ),
        ];
      };
    }
  }
}
