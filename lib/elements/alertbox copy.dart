import 'package:flutter/material.dart';
import 'package:mysalon/elements/lodingbar.dart';

alertBox(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LodingBarElement(); // Show the loading popup
    },
  );
}
