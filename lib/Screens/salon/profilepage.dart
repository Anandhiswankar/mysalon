import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/services/auth/logout.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/Screens/salon/managespecialist.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/Screens/salonRegister/registerSalonA.dart';

class ProfilePageSalonOwner extends StatefulWidget {
  const ProfilePageSalonOwner({super.key});

  @override
  State<ProfilePageSalonOwner> createState() => _ProfilePageSalonOwnerState();
}

class _ProfilePageSalonOwnerState extends State<ProfilePageSalonOwner> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  var salonData = null;
  var salonMedia = null;

  loadData() async {
    salonData = await getSalonInfo(context);

    salonMedia = await getSalonMedia(context);

    print("Profile: " + salonMedia["salonLogo"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: salonData == null && salonMedia == null
            ? screenLoader()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Profile",
                            style: GoogleFonts.inter(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: 150,
                      decoration: BoxDecoration(
                          color: primeColor,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(salonMedia[
                                    "salonLogo"] ??
                                "https://images.pexels.com/photos/1689731/pexels-photo-1689731.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(salonData["salonName"] ?? "loading..",
                              style: GoogleFonts.inter(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              logoutUser(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.logout,
                                size: 30,
                                color: Colors.white,
                              ),
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
                        nextScreen(
                            context,
                            registerSalonA(
                              isUpdate: true,
                            ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.edit,
                              color: primeColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Edit Profile",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primeColor,
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          nextScreen(context, ManageSpecialist());
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.person_3_outlined,
                              color: primeColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Specialist",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primeColor,
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
