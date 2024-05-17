import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class AdminCardCountingCard extends StatefulWidget {
  final IconData icons;
  final String label;
  final String counter;
  const AdminCardCountingCard(
      {super.key,
      required this.icons,
      required this.label,
      required this.counter});

  @override
  State<AdminCardCountingCard> createState() => _AdminCardCountingCardState();
}

class _AdminCardCountingCardState extends State<AdminCardCountingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 110,
      decoration: BoxDecoration(
          color: primeColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(138, 0, 0, 0),
                spreadRadius: 1.5,
                blurRadius: 2.5)
          ]),
      child: Container(
        margin: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        widget.label,
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 20),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_drop_up_outlined,
                            color: Colors.white,
                            size: 35,
                          ),
                          Text(
                            widget.counter,
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icons,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
