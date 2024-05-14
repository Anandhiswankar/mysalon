import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';

class LodingBarElement extends StatefulWidget {
  const LodingBarElement({super.key});
  @override
  State<LodingBarElement> createState() => _LodingBarElementState();
}

class _LodingBarElementState extends State<LodingBarElement> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(), // Show a loading indicator
          SizedBox(height: 16), // Add some space
          Text('Loading...'), // Display a loading message
        ],
      ),
    );
  }
}
