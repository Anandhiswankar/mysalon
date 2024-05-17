import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';

class nameCircle extends StatefulWidget {
  final bool inverse;
  const nameCircle({
    super.key,
    required this.inverse,
  });

  @override
  State<nameCircle> createState() => _nameCircleState();
}

class _nameCircleState extends State<nameCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.inverse ? primeColor : Colors.white,
          shape: BoxShape.circle),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Ziggly",
          style: GoogleFonts.aclonica(
              fontSize: 45, color: widget.inverse ? Colors.white : primeColor),
        ),
      ),
    );
  }
}
