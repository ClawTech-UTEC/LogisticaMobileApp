import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  child: Text('Dashboard',
                      style: Theme.of(context).textTheme.headline4),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Recepciones",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                  Expanded(child: Container()),
                                  Text("1 recepcion pendiente")
                                ],
                              ),
                              Expanded(child: Container()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          elevation:
                                              MaterialStateProperty.all(0)),
                                      onPressed: () {},
                                      child: Text(
                                        "Crear nueva recepcion",
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      )),
                                ],
                              )
                            ],
                          )),
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text("Pedidos",
                          style: Theme.of(context).textTheme.headline5)),
                )),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
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
