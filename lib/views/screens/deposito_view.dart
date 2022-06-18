import 'package:clawtech_logistica_app/views/widgets/scafold_general_background.dart';
import 'package:flutter/material.dart';

class DepositoView extends StatefulWidget {
  DepositoView({Key? key}) : super(key: key);

  @override
  State<DepositoView> createState() => _DepositoViewState();
}

class _DepositoViewState extends State<DepositoView> {
  @override
  Widget build(BuildContext context) {
    return   ListView(
          children: <Widget>[
            Text("Title 1"),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: Text("index: $index"),
                );
              },
            ),
            Text("Title 2"),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: Text("index: $index"),
                );
              },
            ),
            Text("Title 3"),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: Text("index: $index"),
                );
              },
            ),
            Text("Title 4"),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: Text("index: $index"),
                );
              },
            )
          ],
        );
  }
}
