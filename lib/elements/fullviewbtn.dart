import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';

class fullviewbtn extends StatefulWidget {
  final String text;
  final bool inverse;
  final bool isDisabled;
  double fontSize;
  fullviewbtn(
      {super.key,
      required this.text,
      required this.inverse,
      required this.isDisabled,
      this.fontSize = 30});

  @override
  State<fullviewbtn> createState() => _fullviewbtnState();
}

class _fullviewbtnState extends State<fullviewbtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.80,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: widget.isDisabled
              ? Colors.grey
              : widget.inverse
                  ? primeColor
                  : Colors.white),
      alignment: Alignment.center,
      child: Text(
        widget.text,
        style: GoogleFonts.inter(
            fontSize: widget.fontSize,
            color: widget.inverse ? Colors.white : primeColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
