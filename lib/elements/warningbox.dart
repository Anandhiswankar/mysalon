import 'package:flutter/material.dart';
import 'package:mysalon/elements/lodingbar.dart';

warningBox(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(
          Icons.info,
          color: Colors.red,
          size: 40,
        ),
        title: Text(title),
        content: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("close"),
        ),
      ); // Show the loading popup
    },
  );
}
