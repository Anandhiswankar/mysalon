import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';

screenLoader() {
  return Center(
    child: Container(
      alignment: Alignment.center,
      width: 150,
      height: 150,
      child: CircularProgressIndicator(
        color: primeColor,
      ),
    ),
  );
}

screenLoaderWhite() {
  return Center(
    child: Container(
      alignment: Alignment.center,
      width: 150,
      height: 150,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    ),
  );
}
