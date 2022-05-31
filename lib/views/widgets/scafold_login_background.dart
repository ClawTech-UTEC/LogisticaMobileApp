import 'package:flutter/material.dart';

class ScaffoldLoginBackground extends StatefulWidget {
  ScaffoldLoginBackground({Key? key, required this.child}) : super(key: key);
  Widget child;
  @override
  State<ScaffoldLoginBackground> createState() =>
      _ScaffoldLoginBackgroundState();
}

class _ScaffoldLoginBackgroundState extends State<ScaffoldLoginBackground> {
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
                      child:  widget.child)
                ])))));
  }
}
