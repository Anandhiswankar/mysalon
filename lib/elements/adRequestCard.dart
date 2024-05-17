import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/saveData/adsRequestUpdate.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';

class AdRequestCard extends StatefulWidget {
  final dynamic adRequestData;
  final Function load;
  const AdRequestCard({super.key, this.adRequestData, required this.load});

  @override
  State<AdRequestCard> createState() => _AdRequestCardState();
}

class _AdRequestCardState extends State<AdRequestCard> {
  @override
  void initState() {
    super.initState();

    load();
  }

  dynamic salonData = {};

  load() async {
    salonData = await getSalonInfobyId(context, widget.adRequestData["uid"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(81, 0, 0, 0),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(salonData["profile"] ??
                        "https://images.pexels.com/photos/3992870/pexels-photo-3992870.jpeg?auto=compress&cs=tinysrgb&w=600"),
                    fit: BoxFit.cover),
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20)),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Text(
                    salonData["name"] ?? "",
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 20),
                  ),
                ),
                Row(
                  children: [
                    Text("Start Date: "),
                    Text(((widget.adRequestData["startDate"] as Timestamp)
                            .toDate()
                            .toString()
                            .split(" ")
                            .first) ??
                        "")
                  ],
                ),
                Row(
                  children: [
                    Text("End Date: "),
                    Text(((widget.adRequestData["endDate"] as Timestamp)
                            .toDate()
                            .toString()
                            .split(" ")
                            .first) ??
                        "")
                  ],
                ),
                Row(
                  children: [
                    Text("Payment: "),
                    Text(
                        widget.adRequestData["payment"].toString() + " Rs Done")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                widget.adRequestData["isRejected"]
                    ? const Text("Rejected")
                    : Row(
                        children: [
                          !widget.adRequestData["isApproved"]
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primeColor,
                                      foregroundColor: Colors.white),
                                  onPressed: () async {
                                    await approveAdsRequestAllow(
                                        context,
                                        widget.adRequestData["id"],
                                        widget.adRequestData["uid"]);

                                    widget.load();
                                  },
                                  child: Text("Approve"))
                              : SizedBox(),
                          SizedBox(
                            width: 5,
                          ),
                          !widget.adRequestData["isApproved"]
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primeColor,
                                      foregroundColor: Colors.white),
                                  onPressed: () async {
                                    await approveAdsRequestReject(
                                        context,
                                        widget.adRequestData["id"],
                                        widget.adRequestData["uid"]);

                                    widget.load();
                                  },
                                  child: Text("Reject"))
                              : SizedBox(),
                          widget.adRequestData["isApproved"]
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primeColor,
                                      foregroundColor: Colors.white),
                                  onPressed: () async {
                                    await approveAdsRequestReject(
                                        context,
                                        widget.adRequestData["id"],
                                        widget.adRequestData["uid"]);

                                    widget.load();
                                  },
                                  child: Text("Cancel"))
                              : SizedBox(),
                        ],
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
