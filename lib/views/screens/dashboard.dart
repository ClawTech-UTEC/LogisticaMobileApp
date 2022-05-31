import 'package:clawtech_logistica_app/view_model/authentication_viewmodel.dart';
import 'package:clawtech_logistica_app/views/screens/crear_pedido_screen.dart';
import 'package:clawtech_logistica_app/views/screens/crear_recepcion_screen.dart';
import 'package:clawtech_logistica_app/views/screens/recepciones_listado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Center(
              child: Text('Dashboard',
                  style: Theme.of(context).textTheme.headline4)),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Salir"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                BlocProvider.of<AuthenticationViewModel>(context)
                    .onSignOutButtonPressed();
              }
            }),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: PageView(
          children: [
            ResumenPrincipal(),
            ListadoRecepciones(),
          ],
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Pedidos',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Recepciones',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
              backgroundColor: Theme.of(context).backgroundColor,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).splashColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class ResumenPrincipal extends StatelessWidget {
  const ResumenPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: RecepcionesCard()),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PedidosCard(),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class PedidosCard extends StatelessWidget {
  const PedidosCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Pedidos",
                        style: Theme.of(context).textTheme.headline5),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Text("1 pedido nuevo"),
                        Text("2 pedidos pendientes de aprovacion")
                      ],
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CrearPedidoScreen()),
                          );
                        },
                        child: Text(
                          "Crear nuevo pedido",
                          style: TextStyle(color: Colors.blueAccent),
                        )),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class RecepcionesCard extends StatelessWidget {
  const RecepcionesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "recepciones_card",
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Recepciones",
                          style: Theme.of(context).textTheme.headline5),
                      Expanded(child: Container()),
                      Column(
                        children: [
                          Text("1 recepcion nueva"),
                          Text("1 recepcion pendientes de aprovar")
                        ],
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0)),
                          onPressed: () {},
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CrearRecepcionScreen()),
                              );
                            },
                            child: Text("Crear nueva recepcion",
                                style: TextStyle(color: Colors.blueAccent)),
                          )),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
