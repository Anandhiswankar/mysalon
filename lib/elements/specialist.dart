import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialistCard extends StatefulWidget {
  bool showEditIcon;
  bool isSelected;
  int index;
  String name;
  String info;
  String profile;
  Function? delete;
  Function? edit;
  SpecialistCard(
      {super.key,
      this.showEditIcon = true,
      this.isSelected = false,
      this.index = 0,
      this.name = "Username",
      this.info = "info",
      this.profile = "",
      this.delete,
      this.edit});

  @override
  State<SpecialistCard> createState() => _SpecialistCardState();
}

class _SpecialistCardState extends State<SpecialistCard> {
  TextEditingController name = TextEditingController();
  TextEditingController info = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  loadData() async {
    name.text = widget.name;
    info.text = widget.info;
  }

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

  editValues() {
    return showModalBottomSheet(
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
                      style: TextStyle(color: Colors.black, fontSize: 22),
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
                                  image: profileImage != null
                                      ? FileImage(File(profileImage!.path))
                                          as ImageProvider
                                      : NetworkImage(widget.profile ??
                                          "https://st4.depositphotos.com/3917667/21802/i/450/depositphotos_218020158-stock-photo-high-fashion-model-woman-in.jpg"),
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
                                var ss = await getImage();
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
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 120,
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
                      decoration: InputDecoration(hintText: "Enter info"),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        if (name.text.isNotEmpty && info.text.isNotEmpty) {
                          var data = {
                            "name": name.text,
                            "info": info.text,
                            "profile": profileImage ?? widget.profile,
                            "timestamp": Timestamp.now()
                          };

                          widget.edit!(widget.index, data);

                          mystate(() {});
                          setState(() {});

                          Fluttertoast.showToast(msg: "Added");
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(msg: "Enter info for save");
                        }
                      },
                      child: fullviewbtn(
                        inverse: true,
                        isDisabled: true ? false : true,
                        text: "Save",
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      decoration: BoxDecoration(
          color: widget.isSelected ? primeColor : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(59, 79, 79, 79),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(20)),
      height: 130,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: widget.profile.isEmpty
                        ? NetworkImage(
                            "https://st4.depositphotos.com/3917667/21802/i/450/depositphotos_218020158-stock-photo-high-fashion-model-woman-in.jpg")
                        : widget.profile.contains('https://') ||
                                widget.profile.contains('http://')
                            ? NetworkImage(widget.profile)
                            : FileImage(File(widget.profile)) as ImageProvider,
                    fit: BoxFit.cover)),
            width: 140,
            height: 140,
            clipBehavior: Clip.hardEdge,
          ),
          Expanded(
            child: Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      widget.showEditIcon
                          ? InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                editValues();
                                              },
                                              child: fullviewbtn(
                                                  text: "Edits",
                                                  inverse: true,
                                                  isDisabled: false),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                widget.delete!(widget.index);
                                                Navigator.of(context).pop();
                                              },
                                              child: fullviewbtn(
                                                  text: "Delete",
                                                  inverse: true,
                                                  isDisabled: false),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.info)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
