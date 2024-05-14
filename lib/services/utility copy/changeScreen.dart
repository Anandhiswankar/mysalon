import 'package:flutter/material.dart';

nextScreen(BuildContext context, dynamic object) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return object;
  }));
}

replaceScreen(BuildContext context, dynamic object) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    return object;
  }));
}

StartfromScreen(BuildContext context, dynamic object) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) {
    return object;
  }), (route) => false);
}
