import 'package:flutter/material.dart';
import 'package:mysalon/elements/lodingbar.dart';

warningBox(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(
          Icons.warning_amber,
          color: Colors.red,
          size: 40,
        ),
        title: Text(title),
      ); // Show the loading popup
    },
  );
}
