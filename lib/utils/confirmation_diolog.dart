import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void confirmarcionDiolog(
      {required BuildContext context,
      required String title,
      required VoidCallback onConfirm}) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Por favor confirmar'),
            content: Text(title),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    onConfirm();

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Si')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );});}