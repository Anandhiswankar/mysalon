import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/services/location/getlatloglocation.dart';
import 'package:mysalon/Screens/salonRegister/registerSalonB.dart';

class registerSalonA extends StatefulWidget {
  bool isUpdate;
  registerSalonA({super.key, this.isUpdate = false});

  @override
  State<registerSalonA> createState() => _registerSalonAState();
}

class _registerSalonAState extends State<registerSalonA> {
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController salonName = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController addr = TextEditingController();
  TextEditingController location = TextEditingController();

  int selected = 0;

  bool allow = false;

  var locations = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadData();

    if (widget.isUpdate) {
      updateData();
    } else {
      loading = false;
    }
  }

  updateData() async {
    var saloninfo = await getSalonInfo(context);
    var salonMedia = await getSalonMedia(context);
    var salonSpecialist = await getSalonSpecialist(context);
    var salonService = await getSalonServices(context);

    if (saloninfo != null) {
      name.text = saloninfo["name"];
      salonName.text = saloninfo["salonName"];
      contact.text = saloninfo["contact"];
      addr.text = saloninfo["contact"];

      location.text = saloninfo["fetchAddr"];

      locations["lat"] = saloninfo["location"]["lat"];
      locations["long"] = saloninfo["location"]["long"];

      if (saloninfo["salonFor"] == 1) {
        selected = 1;
      }
      if (saloninfo["salonFor"] == 2) {
        selected = 2;
      }
      if (saloninfo["salonFor"] == 3) {
        selected = 3;
      }
    }

    loading = false;

    setState(() {});
  }

  loadData() async {
    //var loc =

    var user = await getCurrentUser();
    mail.text = user!.email!;

    var place = await getAddressFromLocation();

    if (!widget.isUpdate) {
      location.text = place.locality! +
          " " +
          place.subLocality! +
          " " +
          place.street! +
          " ";

      locations = await getlatlongLocation();
    }

    print(locations);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: loading
          ? screenLoader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.inter(
                          color: primeColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInputBox(
                      placeholder: "Enter Name",
                      icons: Icons.person,
                      controller: name,
                      text: ""),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInputBox(
                      enable: false,
                      placeholder: "Enter Mail",
                      icons: Icons.mail,
                      controller: mail,
                      text: ""),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInputBox(
                      placeholder: "Enter Salon name",
                      icons: Icons.store,
                      controller: salonName,
                      text: ""),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInputBox(
                      isNumber: true,
                      placeholder: "Enter contact number",
                      icons: Icons.call,
                      controller: contact,
                      text: ""),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInputBox(
                      placeholder: "Enter Address",
                      icons: Icons.location_city,
                      controller: addr,
                      text: ""),
                  SizedBox(
                    height: 30,
                  ),
                  CustomInputBox(
                      enable: false,
                      placeholder: "Select Location",
                      icons: Icons.location_on,
                      controller: location,
                      text: ""),
                  SizedBox(
                    height: 25,
                  ),
                  lightLabel(
                    label: "Salon for",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            selected = 1;
                            setState(() {});
                          },
                          child: Container(
                            width: 120,
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(90, 0, 0, 0),
                                      blurRadius: 2.2,
                                      offset: Offset(0, 3),
                                      spreadRadius: 0.5)
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    selected == 1
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: primeColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child:
                                      Image.asset("assets/icons/maleicon.png"),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Male",
                                      style: GoogleFonts.inter(
                                          color: primeColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            selected = 2;
                            setState(() {});
                          },
                          child: Container(
                            width: 120,
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(90, 0, 0, 0),
                                      blurRadius: 2.2,
                                      offset: Offset(0, 3),
                                      spreadRadius: 0.5)
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    selected == 2
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: primeColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                      "assets/icons/femaleicon.png"),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("Female",
                                      style: GoogleFonts.inter(
                                          color: primeColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            selected = 3;
                            setState(() {});
                          },
                          child: Container(
                            width: 120,
                            height: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(90, 0, 0, 0),
                                      blurRadius: 2.2,
                                      offset: Offset(0, 3),
                                      spreadRadius: 0.5)
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    selected == 3
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: primeColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset("assets/icons/unisex.png"),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text("unisex",
                                      style: GoogleFonts.inter(
                                          color: primeColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      if (name.text.isNotEmpty &&
                          mail.text.isNotEmpty &&
                          salonName.text.isNotEmpty &&
                          contact.text.isNotEmpty &&
                          addr.text.isNotEmpty &&
                          location.text.isNotEmpty &&
                          contact.text.length == 10) {
                        Map<String, dynamic> data = {
                          "name": name.text,
                          "mail": mail.text,
                          "salonName": salonName.text,
                          "contact": contact.text,
                          "addr": addr.text,
                          "fetchAddr": location.text,
                          "location": {
                            "lat": locations["lat"],
                            "long": locations["long"]
                          },
                          "salonFor": selected,
                        };

                        print(data);

                        nextScreen(
                            context,
                            registerSalonB(
                              salonData: data,
                              isUpdate: widget.isUpdate,
                            ));
                      } else {
                        Fluttertoast.showToast(msg: "Enter All Required Info");
                      }
                    },
                    child: Container(
                      child: fullviewbtn(
                        inverse: true,
                        isDisabled: selected > 0 ? false : true,
                        text: "Next",
                      ),
                    ),
                  )
                ],
              ),
            ),
    ));
  }
}
