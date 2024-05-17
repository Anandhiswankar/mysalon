import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/authbtn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/namecircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/elements/custominputbox.dart';

class newAccount extends StatefulWidget {
  const newAccount({super.key});

  @override
  State<newAccount> createState() => _newAccountState();
}

class _newAccountState extends State<newAccount> {
  TextEditingController mail = TextEditingController();

  int selected = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load();
  }

  load() async {
    await getCurrentUser().then((value) {
      mail.text = value!.email.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 160,
                      height: 160,
                      child: nameCircle(
                        inverse: true,
                      ))),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Create Your Account",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: primeColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                child: CustomInputBox(
                  text: "s",
                  controller: mail,
                  icons: Icons.mail,
                  placeholder: "Enter your mail",
                  enable: false,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Create Your Account As",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: primeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50,
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
                        width: 140,
                        height: 170,
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
                              width: 80,
                              height: 80,
                              child: Image.asset("assets/icons/usericon.png"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text("User",
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
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        selected = 2;
                        setState(() {});
                      },
                      child: Container(
                        width: 140,
                        height: 170,
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
                              width: 80,
                              height: 80,
                              child: Image.asset("assets/icons/shopIcon.png"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text("Salon",
                                  style: GoogleFonts.inter(
                                      color: primeColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: InkWell(
                  onTap: () async {
                    // if (selected == 1) {
                    //   var cp = await storeUser(true);
                    //   print(cp);
                    //   if (cp) {
                    //     nextScreen(context, HomePageUser());
                    //   }
                    // } else {
                    //   nextScreen(context, registerSalonA());
                    // }
                  },
                  child: fullviewbtn(
                    inverse: true,
                    isDisabled:
                        selected > 0 && mail.text.isNotEmpty ? false : true,
                    text: "Next",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
