import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';

class authIconBtn extends StatefulWidget {
  final bool isgoogle;
  const authIconBtn({super.key, required this.isgoogle});

  @override
  State<authIconBtn> createState() => _authIconBtnState();
}

class _authIconBtnState extends State<authIconBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.80,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80), color: Colors.white),
      alignment: Alignment.center,
      child: Row(
        children: [
          const Spacer(),
          Container(
            padding: EdgeInsets.all(5),
            width: 50,
            height: 50,
            child: Image.asset(
              widget.isgoogle
                  ? "assets/icons/googleicon.png"
                  : "assets/icons/facbookicon.png",
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          Text(
            widget.isgoogle ? "Google" : "Facebook",
            style: GoogleFonts.inter(
                fontSize: 30, color: primeColor, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
