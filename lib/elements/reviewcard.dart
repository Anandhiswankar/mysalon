import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatefulWidget {
  final dynamic reviewObject;
  const ReviewCard({super.key, required this.reviewObject});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  var profile = null;
  var name = null;

  loadData() async {
    var users = await getUserById(widget.reviewObject!["uid"]);

    profile = users["profile"];
    name = users["displayName"];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 130,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.red,
            backgroundImage: NetworkImage(profile ??
                "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        name ?? "Verified User",
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 20,
                        child: RatingBar(
                          ignoreGestures: true,
                          itemSize: 10,
                          initialRating: double.parse(
                              widget.reviewObject!["rating"].toString()),
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          glow: true,
                          glowColor: Colors.white,
                          glowRadius: 20,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.favorite,
                              color: primeColor,
                            ),
                            half: Icon(Icons.favorite),
                            empty: Icon(
                              Icons.favorite_border_rounded,
                              color: primeColor,
                            ),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.reviewObject!["msg"],
                    style: GoogleFonts.inter(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (widget.reviewObject!["timestamp"] as Timestamp)
                        .toDate()
                        .toString()
                        .split(" ")
                        .first,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
