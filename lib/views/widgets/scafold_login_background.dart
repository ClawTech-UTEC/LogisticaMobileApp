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
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'iLog Logistica App',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 32.0),
                              child: widget.child)
                        ]),
                      ),
                  ),
                ))));
  }
}
