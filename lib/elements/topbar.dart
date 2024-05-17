import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBarLabel extends StatefulWidget {
  final String label;
  Color textcolor;
  TopBarLabel({super.key, required this.label, this.textcolor = Colors.black});

  @override
  State<TopBarLabel> createState() => _TopBarLabelState();
}

class _TopBarLabelState extends State<TopBarLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios)),
          Text(
            widget.label,
            style: GoogleFonts.inter(
                color: widget.textcolor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
