import 'dart:io';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/Screens/salonRegister/registerSalonC.dart';

class registerSalonB extends StatefulWidget {
  final Map<String, dynamic> salonData;
  bool isUpdate;
  registerSalonB({super.key, required this.salonData, this.isUpdate = false});

  @override
  State<registerSalonB> createState() => _registerSalonBState();
}

class _registerSalonBState extends State<registerSalonB> {
  TextEditingController info = TextEditingController();
  TextEditingController website = TextEditingController();

  TextEditingController salonImage = TextEditingController();
  TextEditingController salonBanner = TextEditingController();

  TextEditingController image1 = TextEditingController();
  TextEditingController image2 = TextEditingController();
  TextEditingController image3 = TextEditingController();
  TextEditingController image4 = TextEditingController();

  File? file1 = null;
  File? file2 = null;
  File? file3 = null;
  File? file4 = null;

  File? SalonImageFile = null;
  File? SalonCoverFile = null;

  int selected = 0;

  bool loading = true;

  String? nullLogo = "";
  String? nullCover = "";

  String? nullImage1 = "";
  String? nullImage2 = "";
  String? nullImage3 = "";
  String? nullImage4 = "";

  @override
  void initState() {
    super.initState();

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
      info.text = saloninfo["salonInfo"];
      website.text = saloninfo["salonWebsite"];
    }

    if (salonMedia != null) {
      nullLogo = salonMedia["salonLogo"];
      nullCover = salonMedia["salonCover"];

      print(salonMedia["Slider"] as List<dynamic>);

      nullImage1 = salonMedia["Slider"][0];
      nullImage2 = salonMedia["Slider"][1];
      nullImage3 = salonMedia["Slider"][2];
      nullImage4 = salonMedia["Slider"][3];
    }

    loading = false;

    setState(() {});
  }

  Future<XFile?> getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: loading
            ? screenLoader()
            : Scaffold(
                resizeToAvoidBottomInset: true,
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 180,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(61, 0, 0, 0),
                                  blurRadius: 2.2,
                                  offset: Offset(0, 3),
                                  spreadRadius: 0.2)
                            ]),
                        child: TextField(
                          controller: info,
                          maxLines: 7,
                          decoration:
                              InputDecoration(hintText: "Enter Salon info"),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomInputBox(
                        placeholder: "Enter Website",
                        icons: Icons.link,
                        controller: website,
                        text: "",
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      lightLabel(label: "Upload Media"),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await getImage();
                          SalonImageFile = File(image!.path);

                          salonImage.text =
                              SalonImageFile!.path.split("/").last.toString();
                          setState(() {});
                        },
                        child: CustomInputBox(
                          placeholder: "Upload Salon Logo",
                          icons: Icons.image,
                          controller: salonImage,
                          text: "",
                          enable: false,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await getImage();
                          SalonCoverFile = File(image!.path);

                          salonBanner.text =
                              SalonCoverFile!.path.split("/").last.toString();
                          setState(() {});
                        },
                        child: CustomInputBox(
                          placeholder: "Upload Salon Banner",
                          icons: Icons.image,
                          controller: salonBanner,
                          text: "",
                          enable: false,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      lightLabel(label: "Upload Media"),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await getImage();
                          file1 = File(image!.path);

                          image1.text = image.path.split("/").last.toString();
                          setState(() {});
                        },
                        child: CustomInputBox(
                          placeholder: "Image 1",
                          icons: Icons.image,
                          controller: image1,
                          text: "",
                          enable: false,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await getImage();
                          file2 = File(image!.path);

                          image2.text = image.path.split("/").last.toString();
                          setState(() {});
                        },
                        child: CustomInputBox(
                          placeholder: "Image 2",
                          icons: Icons.image,
                          controller: image2,
                          text: "",
                          enable: false,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await getImage();
                          file3 = File(image!.path);

                          image3.text = image.path.split("/").last.toString();
                          setState(() {});
                        },
                        child: CustomInputBox(
                          placeholder: "Image 3",
                          icons: Icons.image,
                          controller: image3,
                          text: "",
                          enable: false,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await getImage();
                          file4 = File(image!.path);

                          image4.text = image.path.split("/").last.toString();
                          setState(() {});
                        },
                        child: CustomInputBox(
                          placeholder: "Image 4",
                          icons: Icons.image,
                          controller: image4,
                          text: "",
                          enable: false,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            if (widget.isUpdate) {
                              if (info.text.isNotEmpty &&
                                  website.text.isNotEmpty) {
                                var data = {
                                  "SalonInfo": info.text,
                                  "SalonWebsite": website.text,
                                  "SalonBanner": SalonCoverFile ?? nullCover,
                                  "SalonLogo": SalonImageFile ?? nullLogo,
                                  "Image1": file1 ?? nullImage1,
                                  "Image2": file2 ?? nullImage2,
                                  "Image3": file3 ?? nullImage3,
                                  "Image4": file4 ?? nullImage4,
                                };

                                widget.salonData.addAll(data);

                                print(widget.salonData);

                                nextScreen(
                                    context,
                                    registerSalonC(
                                      salonData: widget.salonData,
                                      isUpdate: widget.isUpdate,
                                    ));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Required All Data");
                              }
                            } else {
                              if (info.text.isNotEmpty &&
                                  website.text.isNotEmpty &&
                                  file1 != null &&
                                  file2 != null &&
                                  file3 != null &&
                                  file4 != null &&
                                  SalonImageFile != null &&
                                  SalonCoverFile != null) {
                                var data = {
                                  "SalonInfo": info.text,
                                  "SalonWebsite": website.text,
                                  "SalonBanner": SalonCoverFile,
                                  "SalonLogo": SalonImageFile,
                                  "Image1": file1,
                                  "Image2": file2,
                                  "Image3": file3,
                                  "Image4": file4,
                                };

                                widget.salonData.addAll(data);

                                print(widget.salonData);

                                nextScreen(
                                    context,
                                    registerSalonC(
                                      salonData: widget.salonData,
                                    ));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Upload And fill All data");
                              }
                            }
                          },
                          child: fullviewbtn(
                            inverse: true,
                            isDisabled:
                                info.text.length > 0 && website.text.length > 0
                                    ? false
                                    : true,
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
