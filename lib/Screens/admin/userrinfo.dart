import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/reviewcard.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/appointmentcard.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:mysalon/elements/salonappointmentcard.dart';
import 'package:mysalon/services/getData/getMybooking.dart';
import 'package:mysalon/services/saveData/disableUser.dart';

class UserInfoAdmin extends StatefulWidget {
  final dynamic userData;
  const UserInfoAdmin({super.key, this.userData});

  @override
  State<UserInfoAdmin> createState() => _UserInfoAdminState();
}

class _UserInfoAdminState extends State<UserInfoAdmin> {
  bool isEnable = true;

  List<dynamic>? mybookingdata = [];

  List<dynamic>? reviewdata = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load();
    getAppointment();
  }

  dynamic user = {};

  load() async {
    user = await getUserById(widget.userData["uid"]);
    isEnable = user["isEnable"];
    setState(() {});
  }

  getAppointment() async {
    mybookingdata = await getMyBookingById(widget.userData["uid"]);
    reviewdata = await getSalonReviewsByUserId(widget.userData["uid"]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarLabel(label: widget.userData["displayName"]),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: 200,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(111, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(widget
                                  .userData["profile"] ??
                              "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.userData["displayName"],
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 20),
                        ),
                        Spacer(),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: isEnable ? Colors.green : Colors.red,
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Status",
                                          style: GoogleFonts.inter(
                                              color: primeColor),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          isEnable ? "Enable" : "Disabled",
                                          style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Join Date",
                                          style: GoogleFonts.inter(
                                              color: primeColor),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          (widget.userData["joinDate"].toDate())
                                              .toString()
                                              .split(" ")
                                              .first,
                                          style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Booked",
                                          style: GoogleFonts.inter(
                                              color: primeColor),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "20",
                                          style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 18),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Expanded(
                              child: Container(
                            child: Column(
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: primeColor,
                                        foregroundColor: Colors.white),
                                    onPressed: () async {
                                      if (user == null) {
                                        print("try After some time");
                                        return;
                                      }
                                      await disableUser(
                                          context,
                                          widget.userData["uid"],
                                          !user["isEnable"]);

                                      setState(() {});

                                      load();

                                      setState(() {});
                                    },
                                    child:
                                        Text(isEnable ? "Disable" : "Enable"))
                              ],
                            ),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              lightLabel(label: "Appointments"),
              mybookingdata == null
                  ? Text("No Data Found")
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: (210 * mybookingdata!.length).toDouble(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mybookingdata!.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.all(10),
                                child: SalonAppointmentCard(
                                  bookingData: mybookingdata![index],
                                ));
                          }),
                    ),
              SizedBox(
                height: 20,
              ),
              lightLabel(label: "Reviews"),
              reviewdata!.isEmpty
                  ? Text("No  Data Found")
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: (150 * reviewdata!.length).toDouble(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: reviewdata!.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.all(10),
                                child: ReviewCard(
                                  reviewObject: reviewdata![index],
                                ));
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
