import 'package:flutter/material.dart';

class CardGeneral extends StatefulWidget {
  CardGeneral({Key? key, required this.child}) : super(key: key);

  Widget child;

  @override
  State<CardGeneral> createState() => _CardGeneralState();
}

class _CardGeneralState extends State<CardGeneral> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 40.0),
        child: Card(
            color: Colors.white,
            child: Container(
                height: double.maxFinite,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: widget.child)))));
  }
}
