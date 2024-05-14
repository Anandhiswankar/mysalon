import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class lightLabel extends StatefulWidget {
  final String label;
  bool isblack;
  double fontSize;

  lightLabel(
      {super.key,
      required this.label,
      this.fontSize = 17,
      this.isblack = false});

  @override
  State<lightLabel> createState() => _lightLabelState();
}

class _lightLabelState extends State<lightLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      height: 40,
      child: Text(widget.label,
          style: GoogleFonts.inter(
              color: widget.isblack ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize)),
    );
  }
}
