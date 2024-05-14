import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCard extends StatefulWidget {
  final dynamic notificationData;
  const NotificationCard({super.key, this.notificationData});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      width: MediaQuery.of(context).size.width * 0.95,
      constraints: BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 167, 167, 167),
                spreadRadius: 2.0,
                blurRadius: 2.0)
          ]),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.headset_mic_outlined,
            color: primeColor,
            size: 30,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Text(
                widget.notificationData["msg"] ?? "",
                style: GoogleFonts.inter(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
