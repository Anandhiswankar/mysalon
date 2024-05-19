import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_pickerr/time_pickerr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/specialist.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/Screens/salon/homepage.dart';
import 'package:mysalon/services/auth/saveUser.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';

class registerSalonD extends StatefulWidget {
  bool isUpdate;
  final Map<String, dynamic> salonData;
  registerSalonD({super.key, required this.salonData, this.isUpdate = false});

  @override
  State<registerSalonD> createState() => _registerSalonDState();
}

class _registerSalonDState extends State<registerSalonD> {
  int selected = 0;

  int chairs = 0;

  TextEditingController name = TextEditingController();
  TextEditingController info = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      updateData();
    }
  }

  bool loading = true;

  updateData() async {
    var saloninfo = await getSalonInfo(context);
    var salonMedia = await getSalonMedia(context);
    var salonSpecialist = await getSalonSpecialist(context);
    var salonService = await getSalonServices(context);

    loading = false;

    openTime = saloninfo["openTime"];

    closeTime = saloninfo["closeTime"];

    chairs = saloninfo["chairs"];

    var speList = salonSpecialist["specialist"];

    print(speList);

    specialists = speList;

    setState(() {});
  }

  String openTime = "10:00";
  String closeTime = "10.00";

  var specialists = [];

  File? profileImage = null;

  Future<XFile?> getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImage = File(image.path);
      setState(() {});
      return image;
    } else {
      return null;
    }
  }

  deleteSpecilist(int i) {
    specialists.removeAt(i);
    Fluttertoast.showToast(msg: "Removed");
    setState(() {});
  }

  EditData(int i, dynamic data) {
    print(data);
    specialists[i] = data;
    Fluttertoast.showToast(msg: "Edited");
    setState(() {});
  }

  saveData() async {
    print(widget.salonData);

    alertBox(context);

    storeUser(false);

    storeSalon();
  }

  Future<String?> uploadImageToFirebase(File imageFile, String uid) async {
    try {
      // Create a reference to the Firebase Storage bucket
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child(uid)
          .child("Media")
          .child('images/${DateTime.now()}.jpg');

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      final TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});

      // Get the download URL for the file
      final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error uploading image: $error');
      return null;
    }
  }

  uploadImage() async {
    try {
      var user = await getCurrentUser();
      List<dynamic> imageUrl = [];

      if (!widget.salonData["SalonBanner"].toString().contains("https://") &&
          !widget.salonData["SalonBanner"].toString().contains("http://")) {
        widget.salonData["SalonBanner"] = await uploadImageToFirebase(
            widget.salonData["SalonBanner"], user!.uid);
      }

      if (!widget.salonData["SalonLogo"].toString().contains("https://") &&
          !widget.salonData["SalonLogo"].toString().contains("http://")) {
        widget.salonData["SalonLogo"] = await uploadImageToFirebase(
            widget.salonData["SalonLogo"], user!.uid);
      }

      //showcase files

      if (!widget.salonData["Image1"].toString().contains("https://") &&
          !widget.salonData["Image1"].toString().contains("http://")) {
        widget.salonData["Image1"] =
            await uploadImageToFirebase(widget.salonData["Image1"], user!.uid);
      }

      if (!widget.salonData["Image2"].toString().contains("https://") &&
          !widget.salonData["Image2"].toString().contains("http://")) {
        widget.salonData["Image2"] =
            await uploadImageToFirebase(widget.salonData["Image2"], user!.uid);
      }

      if (!widget.salonData["Image3"].toString().contains("https://") &&
          !widget.salonData["Image3"].toString().contains("http://")) {
        widget.salonData["Image3"] =
            await uploadImageToFirebase(widget.salonData["Image3"], user!.uid);
      }

      if (!widget.salonData["Image4"].toString().contains("https://") &&
          !widget.salonData["Image4"].toString().contains("http://")) {
        widget.salonData["Image4"] =
            await uploadImageToFirebase(widget.salonData["Image4"], user!.uid);
      }
    } catch (er) {
      print("Error to Store image:" + er.toString());

      //warningBox(context, "Image Upload Error: " + er.toString());
    }
  }

  storeSalon() async {
    var user = await getCurrentUser();

    Map<String, dynamic> data = {
      "name": widget.salonData["name"],
      "mail": widget.salonData["mail"],
      "salonName": widget.salonData["salonName"],
      "contact": widget.salonData["contact"],
      "addr": widget.salonData["addr"],
      "fetchAddr": widget.salonData["fetchAddr"],
      "location": widget.salonData["location"],
      "joinDate": Timestamp.now(),
      "salonInfo": widget.salonData["SalonInfo"],
      "salonWebsite": widget.salonData["SalonWebsite"],
      "openTime": widget.salonData["OpenTime"],
      "closeTime": widget.salonData["CloseTime"],
      "chairs": widget.salonData["Chairs"],
      "isOpen": false,
      "salonFor": widget.salonData["salonFor"]
      // "specialist": widget.salonData["Specialist"]
    };

    print(data);

    FirebaseFirestore.instance
        .collection("salons")
        .doc(user!.uid)
        .set(data)
        .then((value) async {
      print("Basic Salon Info Stored");

      //Storing Media

      await uploadImage();

      var mediaData = {
        "salonCover": widget.salonData["SalonBanner"],
        "salonLogo": widget.salonData["SalonLogo"],
        "Slider": [
          widget.salonData["Image1"],
          widget.salonData["Image2"],
          widget.salonData["Image3"],
          widget.salonData["Image4"]
        ],
      };

      print(mediaData);

      FirebaseFirestore.instance
          .collection("salons")
          .doc(user!.uid)
          .collection("Media")
          .doc("Images")
          .set(mediaData)
          .then((value) {
        print("Media Part is Stored");

        var data = {
          "salonType": widget.salonData["salonType"],
          "salonOffer": widget.salonData["salonOffer"],
          "salonWorking": widget.salonData["wokringDays"],
        };

        FirebaseFirestore.instance
            .collection("salons")
            .doc(user.uid)
            .collection("Services")
            .doc("salons")
            .set(data)
            .then((value) async {
          print("Salon type updated");

          List<dynamic> spe = specialists;

          for (int i = 0; i < spe.length; i++) {
            if (!spe[i]["profile"].toString().contains("https://") &&
                !spe[i]["profile"].toString().contains("http://")) {
              spe[i]["profile"] =
                  await uploadImageToFirebase(spe[i]["profile"], user.uid);
            }
          }

          FirebaseFirestore.instance
              .collection("salons")
              .doc(user.uid)
              .collection("specialists")
              .doc("Allspecialists")
              .set({"specialist": spe}).then((value) {
            print("Specialist Added");
            replaceScreen(context, SalonHomePage());
          }).catchError((onError) {
            print(onError);
            Navigator.of(context).pop();
            warningBox(
                context, "Error to StoreS Specialist" + onError.toString());
          });
        }).catchError((onError) {
          print("Salon offers error to store:  " + onError.toString());

          Navigator.of(context).pop();

          warningBox(
              context, "Error to Store offers and type" + onError.toString());
        });
      }).catchError((onError) {
        Navigator.of(context).pop();
        print("Media part Store error: " + onError.toString());

        warningBox(context, "Error to Store media" + onError.toString());
      });
    }).catchError((onError) {
      Navigator.of(context).pop();
      print("Error to store base salon info: " + onError.toString());

      warningBox(context, "Error to Store basic info" + onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            lightLabel(label: "Operating Hours"),
            SizedBox(
              height: 5,
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
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomHourPicker(
                                elevation: 2,
                                onPositivePressed: (context, time) {
                                  print('onPositive');
                                  openTime = time.hour.toString() +
                                      ":" +
                                      time.minute.toString();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                onNegativePressed: (context) {
                                  print('onNegative');
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                        child: Chip(
                            backgroundColor: primeColor,
                            avatar: Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            label: Text(
                              openTime,
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomHourPicker(
                            elevation: 2,
                            onPositivePressed: (context, time) {
                              print('onPositive');
                              closeTime = time.hour.toString() +
                                  ":" +
                                  time.minute.toString();
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            onNegativePressed: (context) {
                              print('onNegative');
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Close Time",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Chip(
                            backgroundColor: primeColor,
                            avatar: Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            label: Text(
                              closeTime,
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            lightLabel(label: "Available chairs"),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Total Chairs",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: primeColor,
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              chairs += 1;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        Text(
                          chairs.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        InkWell(
                            onTap: () {
                              if (chairs > 1) {
                                chairs -= 1;
                              }
                              setState(() {});
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            lightLabel(label: "Add Specialist"),
            Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: true,
                        showDragHandle: true,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, mystate) {
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
                                      "Add Specialist",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 22),
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
                                                  image: profileImage == null
                                                      ? NetworkImage(
                                                          "https://st4.depositphotos.com/3917667/21802/i/450/depositphotos_218020158-stock-photo-high-fashion-model-woman-in.jpg")
                                                      : FileImage(File(
                                                              profileImage!
                                                                  .path))
                                                          as ImageProvider,
                                                  fit: BoxFit.cover)),
                                          width: 140,
                                          height: 140,
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        Positioned(
                                            right: 10,
                                            bottom: 10,
                                            child: InkWell(
                                              onTap: () async {
                                                await getImage();
                                                mystate(() {});
                                                setState(() {});
                                              },
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.black,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  )),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomInputBox(
                                    placeholder: "Enter Name",
                                    icons: Icons.person,
                                    controller: name,
                                    text: "",
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: 120,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(61, 0, 0, 0),
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
                                    child: InkWell(
                                      onTap: () {
                                        if (name.text.isNotEmpty &&
                                            info.text.isNotEmpty) {
                                          var data = {
                                            "name": name.text,
                                            "info": info.text,
                                            "profile": profileImage,
                                            "timestamp": Timestamp.now()
                                          };

                                          specialists.add(data);

                                          mystate(() {});
                                          setState(() {});

                                          Fluttertoast.showToast(msg: "Added");
                                          Navigator.of(context).pop();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Enter info for save");
                                        }
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
                  child: Text("Add"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primeColor,
                      foregroundColor: Colors.white),
                )),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150 * specialists.length.toDouble(),
              child: ListView.builder(
                  itemCount: specialists.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.all(10),
                        child: SpecialistCard(
                          index: index,
                          delete: deleteSpecilist,
                          edit: EditData,
                          name: specialists[index]["name"],
                          info: specialists[index]["info"],
                          profile: specialists[index]["profile"]
                                  .toString()
                                  .contains("https://")
                              ? specialists[index]["profile"]
                              : specialists[index]["profile"] != null
                                  ? (specialists[index]["profile"] as File).path
                                  : "",
                        ));
                  }),
            ),
            Container(
              child: InkWell(
                onTap: () {
                  if (specialists.length > 0 && chairs > 0) {
                    var data = {
                      "OpenTime": openTime,
                      "CloseTime": closeTime,
                      "Chairs": chairs,
                      "Specialist": specialists
                    };

                    widget.salonData.addAll(data);
                    setState(() {});

                    saveData();
                  } else {
                    Fluttertoast.showToast(msg: "Enter All Field");
                  }
                },
                child: fullviewbtn(
                  inverse: true,
                  isDisabled:
                      specialists.length > 0 && chairs > 0 ? false : true,
                  text: "Save",
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
          ],
        ),
      ),
    ));
  }
}
