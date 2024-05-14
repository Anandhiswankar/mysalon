import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../elements/custominputbox.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/saveData/postAds.dart';
import 'package:mysalon/services/getData/getPostedAds.dart';

class AdsAndService extends StatefulWidget {
  const AdsAndService({super.key});

  @override
  State<AdsAndService> createState() => _AdsAndServiceState();
}

class _AdsAndServiceState extends State<AdsAndService> {
  TextEditingController name = TextEditingController();
  TextEditingController info = TextEditingController();

  String startDate = "";
  String endDate = "";

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  List<QueryDocumentSnapshot<dynamic>>? postedAds = null;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    startDate = DateTime.now().toString().split(" ").first;
    endDate = DateTime.now().add(Duration(days: 1)).toString().split(" ").first;

    postedAds = await getPostedAds();

    setState(() {});
  }

  postAds() async {
    if (DateTime.parse(endDate).isAfter(DateTime.parse(startDate))) {
      // End date is greater than start date

      var uid = await getCurrentUser();

      var data = {
        "title": name.text,
        "info": info.text,
        "startDate": Timestamp.fromDate(DateTime.parse(startDate)),
        "endDate": Timestamp.fromDate(DateTime.parse(endDate)),
        "timestamp": Timestamp.now(),
        "enable": false,
        "paymentStatus": "pending",
        "payment": 10,
        "msg": "",
        "isRejected": false,
        "isApproved": false,
        "uid": uid!.uid
      };

      var ss = await postAdsFirestore(context, data);

      Navigator.of(context).pop();
    } else {
      // End date is not greater than start date
      warningBox(context, "End date must be greater then start Date");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: primeColor,
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Ads & Service",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text(
                  "Promote your salon in your search. Pay small cost for ads and display 1st in search page. Engage more user for you salon",
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.80,
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(108, 0, 0, 0),
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 2))
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        "Apply for Advertisement",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: primeColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Post in single click",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: primeColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Select Duration fro Ads",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: primeColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "One to One payment",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: primeColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Low Cost",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            showDragHandle: true,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, mystate) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text(
                                          "Post Ads",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                      ),
                                      Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://cdn-icons-png.flaticon.com/512/1804/1804155.png"),
                                                      fit: BoxFit.cover)),
                                              width: 140,
                                              height: 140,
                                              clipBehavior: Clip.hardEdge,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CustomInputBox(
                                        placeholder: "Enter title",
                                        icons: Icons.person,
                                        controller: name,
                                        text: "",
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        height: 120,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      61, 0, 0, 0),
                                                  blurRadius: 2.2,
                                                  offset: Offset(0, 3),
                                                  spreadRadius: 0.2)
                                            ]),
                                        child: TextField(
                                          controller: info,
                                          maxLines: 7,
                                          decoration: InputDecoration(
                                              hintText: "Enter info"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Open Time",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    var ss =
                                                        await showDatePicker(
                                                            context: context,
                                                            firstDate:
                                                                DateTime.now(),
                                                            lastDate: DateTime
                                                                    .now()
                                                                .add(Duration(
                                                                    days: 30)));

                                                    print(ss);

                                                    startDate = ss!
                                                        .toString()
                                                        .split(" ")
                                                        .first;

                                                    _startDate = ss!;

                                                    mystate(() {});
                                                    setState(() {});

                                                    print(startDate);
                                                  },
                                                  child: Chip(
                                                      backgroundColor:
                                                          primeColor,
                                                      avatar: Icon(
                                                        Icons.timer,
                                                        color: Colors.white,
                                                      ),
                                                      label: Text(
                                                        startDate,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Close Time",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      var ss =
                                                          await showDatePicker(
                                                              context: context,
                                                              firstDate:
                                                                  DateTime
                                                                      .now(),
                                                              lastDate: DateTime
                                                                      .now()
                                                                  .add(Duration(
                                                                      days:
                                                                          30)));

                                                      endDate = ss!
                                                          .toString()
                                                          .split(" ")
                                                          .first;

                                                      _endDate = ss!;

                                                      mystate(() {});
                                                      setState(() {});
                                                    },
                                                    child: Chip(
                                                        backgroundColor:
                                                            primeColor,
                                                        avatar: Icon(
                                                          Icons.timer,
                                                          color: Colors.white,
                                                        ),
                                                        label: Text(
                                                          endDate,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: InkWell(
                                          onTap: () {
                                            postAds();
                                          },
                                          child: fullviewbtn(
                                            inverse: true,
                                            isDisabled: name.text.isNotEmpty &&
                                                    info.text.isNotEmpty
                                                ? false
                                                : true,
                                            text: "Save",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: primeColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "POST",
                          style: GoogleFonts.inter(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              lightLabel(label: "All Request"),
              SizedBox(
                height: 20,
              ),
              postedAds == null
                  ? Text("No Request found")
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.40,
                      child: ListView.builder(
                          itemCount: postedAds!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              margin: const EdgeInsets.all(10),
                              height: 190,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            const Color.fromARGB(108, 0, 0, 0),
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(0, 2))
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    child: Text(
                                      "Id : " + postedAds![index].id,
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Text("Ads Duration: "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          ((postedAds![index].data()[
                                                              "startDate"]
                                                          as Timestamp)
                                                      .toDate()
                                                      .toString()
                                                      .split(" ")
                                                      .first)
                                                  .toString() +
                                              " To " +
                                              ((postedAds![index]
                                                              .data()["endDate"]
                                                          as Timestamp)
                                                      .toDate()
                                                      .toString()
                                                      .split(" ")
                                                      .first)
                                                  .toString(),
                                          style: GoogleFonts.inter(
                                            color: primeColor,
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Text("Paid "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          postedAds![index]
                                              .data()["paymentStatus"],
                                          style: GoogleFonts.inter(
                                            color: primeColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Text("Status: "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          postedAds![index].data()["isApproved"]
                                              ? "Approved"
                                              : postedAds![index]
                                                      .data()["isRejected"]
                                                  ? "Rejcted"
                                                  : "Pending",
                                          style: GoogleFonts.inter(
                                            color: primeColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Text("Comments: "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          postedAds![index].data()["msg"] == ""
                                              ? "Pending"
                                              : postedAds![index].data()["msg"],
                                          style: GoogleFonts.inter(
                                            color: primeColor,
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
